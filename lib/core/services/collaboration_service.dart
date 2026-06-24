import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:frontend/core/networking/app_config.dart';
import 'package:frontend/core/networking/token_service.dart';

class Collaborator {
  final String userId;
  final String displayName;
  final String? target;

  Collaborator({
    required this.userId,
    required this.displayName,
    this.target,
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    return Collaborator(
      userId: json['user_id']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? 'Anonymous',
      target: json['target']?.toString(),
    );
  }
}

class CollaborationState {
  final String roomId;
  final bool isConnected;
  final List<Collaborator> collaborators;
  final Map<String, Map<String, dynamic>> leases; // target_id -> lease_info
  final String? collisionTarget;
  final String? collisionHeldBy;
  final String? myUserId;
  final String? myDisplayName;

  CollaborationState({
    required this.roomId,
    this.isConnected = false,
    this.collaborators = const [],
    this.leases = const {},
    this.collisionTarget,
    this.collisionHeldBy,
    this.myUserId,
    this.myDisplayName,
  });

  CollaborationState copyWith({
    String? roomId,
    bool? isConnected,
    List<Collaborator>? collaborators,
    Map<String, Map<String, dynamic>>? leases,
    String? collisionTarget,
    String? collisionHeldBy,
    String? myUserId,
    String? myDisplayName,
  }) {
    return CollaborationState(
      roomId: roomId ?? this.roomId,
      isConnected: isConnected ?? this.isConnected,
      collaborators: collaborators ?? this.collaborators,
      leases: leases ?? this.leases,
      collisionTarget: collisionTarget,
      collisionHeldBy: collisionHeldBy,
      myUserId: myUserId ?? this.myUserId,
      myDisplayName: myDisplayName ?? this.myDisplayName,
    );
  }
}

final collaborationProvider = StateNotifierProvider.family<CollaborationNotifier, CollaborationState, String>((ref, arg) {
  // arg is resourceId
  return CollaborationNotifier(ref, arg);
});

class CollaborationNotifier extends StateNotifier<CollaborationState> {
  final Ref _ref;
  final String _resourceType;
  final String _resourceId;
  io.Socket? _socket;
  Timer? _leaseTimer;

  CollaborationNotifier(this._ref, String arg)
      : _resourceType = arg.contains(':') ? arg.split(':')[0] : 'form',
        _resourceId = arg.contains(':') ? arg.split(':')[1] : arg,
        super(CollaborationState(
          roomId: arg.contains(':')
              ? 'collab:$arg'
              : 'collab:form:$arg',
        )) {
    _initSocket();
  }

  void _initSocket() async {
    final tokenState = _ref.read(tokenServiceProvider).value;
    final token = tokenState?.accessToken;

    if (token == null) return;

    // Build socket server endpoint from AppConfig apiServerUrl
    final serverUrl = AppConfig.apiServerUrl;
    
    // Decode user info from token to have initial state
    String? localUserId;
    String? localDisplayName;
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );
        localUserId = payload['sub']?.toString();
        localDisplayName = payload['username']?.toString();
      }
    } catch (_) {}

    state = state.copyWith(
      myUserId: localUserId,
      myDisplayName: localDisplayName,
    );

    _socket = io.io('$serverUrl/collab', io.OptionBuilder()
        .setTransports(['websocket'])
        .setQuery({'token': token})
        .enableAutoConnect()
        .build());

    _socket?.onConnect((_) {
      state = state.copyWith(isConnected: true);
      _joinRoom();
    });

    _socket?.onDisconnect((_) {
      state = state.copyWith(isConnected: false);
    });

    _socket?.on('authenticated', (data) {
      if (data is Map) {
        state = state.copyWith(
          myUserId: data['user_id']?.toString(),
          myDisplayName: data['display_name']?.toString(),
        );
      }
    });

    _socket?.on('presence_update', (data) {
      if (data is Map) {
        final list = data['collaborators'] as List? ?? [];
        final collabList = list.map((item) => Collaborator.fromJson(Map<String, dynamic>.from(item))).toList();
        state = state.copyWith(collaborators: collabList);
      }
    });

    _socket?.on('leases_sync', (data) {
      if (data is Map) {
        final leasesMap = Map<String, Map<String, dynamic>>.from(data['leases'] ?? {});
        state = state.copyWith(leases: leasesMap);
      }
    });

    _socket?.on('lease_acquired', (data) {
      if (data is Map) {
        final target = data['target']?.toString() ?? '';
        final newLeases = Map<String, Map<String, dynamic>>.from(state.leases);
        newLeases[target] = Map<String, dynamic>.from(data);
        state = state.copyWith(leases: newLeases);
      }
    });

    _socket?.on('lease_released', (data) {
      if (data is Map) {
        final target = data['target']?.toString() ?? '';
        final newLeases = Map<String, Map<String, dynamic>>.from(state.leases);
        newLeases.remove(target);
        state = state.copyWith(leases: newLeases);
      }
    });

    _socket?.on('collision', (data) {
      if (data is Map) {
        final target = data['target']?.toString() ?? '';
        final heldBy = data['held_by']?.toString() ?? 'someone';
        state = state.copyWith(
          collisionTarget: target,
          collisionHeldBy: heldBy,
        );
      }
    });

    _socket?.on('cursor_updated', (data) {
      // Trigger update of active collaborator list target positions
      if (data is Map) {
        final userId = data['user_id']?.toString() ?? '';
        final target = data['target']?.toString();
        
        final updatedList = state.collaborators.map((c) {
          if (c.userId == userId) {
            return Collaborator(userId: c.userId, displayName: c.displayName, target: target);
          }
          return c;
        }).toList();
        state = state.copyWith(collaborators: updatedList);
      }
    });
  }

  void _joinRoom() {
    _socket?.emit('join', {
      'resource_type': _resourceType,
      'resource_id': _resourceId,
    });
  }

  void acquireLease(String target) {
    _socket?.emit('lease_acquire', {
      'room_id': state.roomId,
      'target': target,
    });

    // Start auto-renew timer to hold onto the lease
    _leaseTimer?.cancel();
    _leaseTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (state.isConnected) {
        _socket?.emit('lease_acquire', {
          'room_id': state.roomId,
          'target': target,
        });
      }
    });
  }

  void releaseLease(String target) {
    _leaseTimer?.cancel();
    _socket?.emit('lease_release', {
      'room_id': state.roomId,
      'target': target,
    });
  }

  void updateCursor(String target) {
    _socket?.emit('cursor_move', {
      'room_id': state.roomId,
      'target': target,
    });
  }

  void clearCollision() {
    state = state.copyWith(
      collisionTarget: null,
      collisionHeldBy: null,
    );
  }

  @override
  void dispose() {
    _leaseTimer?.cancel();
    _socket?.emit('leave', {
      'resource_type': _resourceType,
      'resource_id': _resourceId,
    });
    _socket?.disconnect();
    super.dispose();
  }
}

# 02. Technical Architecture - Collaborative Editing

## System Architecture Overview

Collaborative editing requires real-time synchronization using WebSockets and Conflict-Free Replicated Data Types (CRDTs).

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                          │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Collaborative UI  │  │ Comment Widget   │  │ Version UI   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Domain Layer                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Comment Entity   │  │ Form Change      │  │ Version      │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Data Layer                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Collab Repo      │  │ Comment Repo     │  │ Version Repo │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Infrastructure Layer                         │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ WebSocket Service│  │ CRDT Engine     │  │ Diff Service │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Presence Service │  │ Conflict Resolver │  │ Notification │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### New Flutter Packages Required

```yaml
dependencies:
  # Real-time collaboration
  web_socket_channel: ^2.4.0
  
  # CRDT for conflict-free replication
  y_crdt: ^0.1.0
  
  # Diff visualization
  diffutil_dart: ^3.0.0
```

### Domain Services

```dart
class CollaborationService {
  Stream<CollaborationEvent> connectToForm(String formId, String userId) {
    // Establish WebSocket connection
    return _webSocketService.connect(formId, userId);
  }
  
  Future<void> broadcastChange(FormChange change) async {
    // Broadcast change to all collaborators
    await _webSocketService.broadcast(change);
  }
  
  Future<void> resolveConflict(Conflict conflict) async {
    // Use CRDT to resolve conflicts
    final resolved = await _crdtEngine.resolve(conflict);
    await _formRepository.updateForm(resolved);
  }
}

class CommentService {
  Future<Comment> addComment(Comment comment) async {
    final created = await _commentRepository.save(comment);
    await _notificationService.notifyMentions(comment);
    return created;
  }
  
  Future<void> resolveComment(String commentId) async {
    await _commentRepository.resolve(commentId);
  }
}

class VersionComparisonService {
  Future<VersionDiff> compareVersions({
    required String formId,
    required String version1,
    required String version2,
  }) async {
    final v1 = await _versionRepository.getVersion(formId, version1);
    final v2 = await _versionRepository.getVersion(formId, version2);
    
    return _diffService.compare(v1, v2);
  }
}
```

### WebSocket Integration

```dart
class FormWebSocketService {
  late WebSocketChannel _channel;
  final StreamController<CollaborationEvent> _eventController = 
      StreamController.broadcast();
  
  Stream<CollaborationEvent> connect(String formId, String userId) {
    final uri = Uri.parse('wss://api.example.com/collaboration/$formId?userId=$userId');
    _channel = WebSocketChannel.connect(uri);
    
    _channel.stream.listen((data) {
      final event = CollaborationEvent.fromJson(jsonDecode(data));
      _eventController.add(event);
    });
    
    return _eventController.stream;
  }
  
  Future<void> broadcast(CollaborationEvent event) async {
    _channel.sink.add(jsonEncode(event.toJson()));
  }
  
  void disconnect() {
    _channel.sink.close();
    _eventController.close();
  }
}
```

### CRDT Implementation

```dart
class CrdtEngine {
  Future<Form> resolveConflict(Conflict conflict) async {
    // Use Yjs CRDT for conflict resolution
    final yDoc = YDoc();
    final yForm = yDoc.getMap('form');
    
    // Merge conflicting changes
    yForm.set(conflict.key, conflict.mergedValue);
    
    return Form.fromYMap(yForm);
  }
}
```

## State Management

```dart
@riverpod
class CollaborationController extends _$CollaborationController {
  StreamSubscription? _subscription;
  
  @override
  Future<CollaborationState> build(String formId) async {
    final userId = ref.watch(currentUserProvider)!.id;
    final service = ref.watch(collaborationServiceProvider);
    
    _subscription = service.connectToForm(formId, userId).listen((event) {
      state = AsyncValue.data(state.value?.copyWith(
        collaborators: event.collaborators,
        pendingChanges: event.changes,
      ));
    });
    
    return CollaborationState(
      formId: formId,
      collaborators: [],
      pendingChanges: [],
    );
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

## Deployment Considerations

### Backend Requirements

1. **WebSocket Server**
   - Real-time bidirectional communication
   - Connection pooling
   - Automatic reconnection

2. **CRDT Backend**
   - Yjs or Automerge for conflict resolution
   - Persistence of CRDT documents
   - Garbage collection

3. **Presence Service**
   - Track active collaborators
   - Cursor position synchronization
   - User presence indicators

4. **Notification Service**
   - @mention notifications
   - Comment notifications
   - Real-time updates

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_models.dart';

class DashboardRefreshController extends StateNotifier<DashboardRefreshState> {
  DashboardRefreshController() : super(const DashboardRefreshState());

  Timer? _refreshTimer;
  DateTime? _lastRefreshTime;

  void startAutoRefresh({
    required String dashboardId,
    required RefreshMode mode,
    int? intervalSeconds,
    String? cronExpression,
  }) {
    _stopAutoRefresh();

    state = state.copyWith(
      dashboardId: dashboardId,
      mode: mode,
      intervalSeconds: intervalSeconds,
      cronExpression: cronExpression,
      isAutoRefreshEnabled: true,
      status: RefreshStatus.active,
    );

    _scheduleNextRefresh();
  }

  void stopAutoRefresh() {
    _stopAutoRefreshTimer();
    state = state.copyWith(
      isAutoRefreshEnabled: false,
      status: RefreshStatus.stopped,
    );
  }

  void _stopAutoRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void _scheduleNextRefresh() {
    if (!state.isAutoRefreshEnabled) return;

    final interval = state.intervalSeconds ?? 300; // Default 5 minutes
    _refreshTimer = Timer(Duration(seconds: interval), _performRefresh);
  }

  Future<void> _performRefresh() async {
    if (state.status == RefreshStatus.refreshing) return;

    state = state.copyWith(status: RefreshStatus.refreshing);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _lastRefreshTime = DateTime.now();
      
      state = state.copyWith(
        status: RefreshStatus.active,
        lastRefreshTime: _lastRefreshTime,
        refreshCount: state.refreshCount + 1,
      );

      _scheduleNextRefresh();
    } catch (e) {
      state = state.copyWith(
        status: RefreshStatus.error,
        errorMessage: e.toString(),
      );
      
      // Retry after 30 seconds on error
      _refreshTimer = Timer(const Duration(seconds: 30), _performRefresh);
    }
  }

  Future<void> triggerManualRefresh() async {
    if (state.status == RefreshStatus.refreshing) return;

    final previousStatus = state.status;
    state = state.copyWith(status: RefreshStatus.refreshing);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _lastRefreshTime = DateTime.now();
      
      state = state.copyWith(
        status: previousStatus,
        lastRefreshTime: _lastRefreshTime,
        refreshCount: state.refreshCount + 1,
        errorMessage: null,
      );

    } catch (e) {
      state = state.copyWith(
        status: RefreshStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void updateRefreshConfig({
    RefreshMode? mode,
    int? intervalSeconds,
    String? cronExpression,
  }) {
    state = state.copyWith(
      mode: mode ?? state.mode,
      intervalSeconds: intervalSeconds ?? state.intervalSeconds,
      cronExpression: cronExpression ?? state.cronExpression,
    );

    if (state.isAutoRefreshEnabled) {
    _stopAutoRefreshTimer();
      _scheduleNextRefresh();
    }
  }

  @override
  void dispose() {
    _stopAutoRefreshTimer();
    super.dispose();
  }
}

class DashboardRefreshState {
  final String? dashboardId;
  final RefreshMode mode;
  final int? intervalSeconds;
  final String? cronExpression;
  final bool isAutoRefreshEnabled;
  final RefreshStatus status;
  final DateTime? lastRefreshTime;
  final int refreshCount;
  final String? errorMessage;

  const DashboardRefreshState({
    this.dashboardId,
    this.mode = RefreshMode.manual,
    this.intervalSeconds,
    this.cronExpression,
    this.isAutoRefreshEnabled = false,
    this.status = RefreshStatus.idle,
    this.lastRefreshTime,
    this.refreshCount = 0,
    this.errorMessage,
  });

  DashboardRefreshState copyWith({
    String? dashboardId,
    RefreshMode? mode,
    int? intervalSeconds,
    String? cronExpression,
    bool? isAutoRefreshEnabled,
    RefreshStatus? status,
    DateTime? lastRefreshTime,
    int? refreshCount,
    String? errorMessage,
  }) {
    return DashboardRefreshState(
      dashboardId: dashboardId ?? this.dashboardId,
      mode: mode ?? this.mode,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      cronExpression: cronExpression ?? this.cronExpression,
      isAutoRefreshEnabled: isAutoRefreshEnabled ?? this.isAutoRefreshEnabled,
      status: status ?? this.status,
      lastRefreshTime: lastRefreshTime ?? this.lastRefreshTime,
      refreshCount: refreshCount ?? this.refreshCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum RefreshMode {
  manual,
  interval,
  cron,
  withAnalysis,
}

enum RefreshStatus {
  idle,
  active,
  refreshing,
  error,
  stopped,
}

// Provider for the dashboard refresh controller
final dashboardRefreshControllerProvider = StateNotifierProvider<DashboardRefreshController, DashboardRefreshState>((ref) {
  return DashboardRefreshController();
});

class RefreshSettingsDialog extends ConsumerStatefulWidget {
  final DashboardModel dashboard;
  final Function(DashboardModel)? onSettingsChanged;

  const RefreshSettingsDialog({
    Key? key,
    required this.dashboard,
    this.onSettingsChanged,
  }) : super(key: key);

  @override
  _RefreshSettingsDialogState createState() => _RefreshSettingsDialogState();
}

class _RefreshSettingsDialogState extends ConsumerState<RefreshSettingsDialog> {
  RefreshMode _selectedMode = RefreshMode.manual;
  int? _intervalSeconds;
  String? _cronExpression;
  bool _autoRefreshEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeFromDashboard();
  }

  void _initializeFromDashboard() {
    final settings = widget.dashboard.settings;
    _autoRefreshEnabled = settings.autoRefresh;
    
    if (settings.refreshIntervalSeconds != null) {
      _selectedMode = RefreshMode.interval;
      _intervalSeconds = settings.refreshIntervalSeconds;
    } else if (settings.refreshCronExpression != null) {
      _selectedMode = RefreshMode.cron;
      _cronExpression = settings.refreshCronExpression;
    }
  }

  void _saveSettings() {
    final updatedSettings = widget.dashboard.settings.copyWith(
      autoRefresh: _autoRefreshEnabled,
      refreshIntervalSeconds: _selectedMode == RefreshMode.interval ? _intervalSeconds : null,
      refreshCronExpression: _selectedMode == RefreshMode.cron ? _cronExpression : null,
    );

    final updatedDashboard = widget.dashboard.copyWith(settings: updatedSettings);
    widget.onSettingsChanged?.call(updatedDashboard);

    // Update the refresh controller
    if (_autoRefreshEnabled) {
      ref.read(dashboardRefreshControllerProvider.notifier).startAutoRefresh(
        dashboardId: widget.dashboard.id,
        mode: _selectedMode,
        intervalSeconds: _intervalSeconds,
        cronExpression: _cronExpression,
      );
    } else {
      ref.read(dashboardRefreshControllerProvider.notifier).stopAutoRefresh();
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Refresh Settings'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Auto Refresh Toggle
            SwitchListTile(
              title: const Text('Enable Auto Refresh'),
              subtitle: const Text('Automatically refresh dashboard data'),
              value: _autoRefreshEnabled,
              onChanged: (value) {
                setState(() {
                  _autoRefreshEnabled = value;
                });
              },
            ),
            
            if (_autoRefreshEnabled) ...[
              const SizedBox(height: 16),
              
              // Refresh Mode Selection
              Text(
                'Refresh Mode',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              ...RefreshMode.values.map((mode) => RadioListTile<RefreshMode>(
                title: Text(_getModeDisplayName(mode)),
                subtitle: Text(_getModeDescription(mode)),
                value: mode,
                groupValue: _selectedMode,
                onChanged: (value) {
                  setState(() {
                    _selectedMode = value!;
                  });
                },
              )),
              
              const SizedBox(height: 16),
              
              // Mode-specific settings
              _buildModeSpecificSettings(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveSettings,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildModeSpecificSettings() {
    switch (_selectedMode) {
      case RefreshMode.interval:
        return _buildIntervalSettings();
      case RefreshMode.cron:
        return _buildCronSettings();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIntervalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refresh Interval',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        DropdownButtonFormField<int?>(
          value: _intervalSeconds,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          hint: const Text('Select interval'),
          items: const [
            DropdownMenuItem(value: 60, child: Text('1 minute')),
            DropdownMenuItem(value: 300, child: Text('5 minutes')),
            DropdownMenuItem(value: 600, child: Text('10 minutes')),
            DropdownMenuItem(value: 1800, child: Text('30 minutes')),
            DropdownMenuItem(value: 3600, child: Text('1 hour')),
          ],
          onChanged: (value) {
            setState(() {
              _intervalSeconds = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCronSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cron Expression',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Cron Expression',
            hintText: 'e.g., 0 */5 * * *',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          initialValue: _cronExpression ?? '0 */5 * * *',
          onChanged: (value) {
            setState(() {
              _cronExpression = value.isEmpty ? null : value;
            });
          },
        ),
        
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Format: minute hour day month weekday\nExample: 0 */5 * * * (every 5 minutes)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  String _getModeDisplayName(RefreshMode mode) {
    switch (mode) {
      case RefreshMode.manual:
        return 'Manual Only';
      case RefreshMode.interval:
        return 'Fixed Interval';
      case RefreshMode.cron:
        return 'Cron Schedule';
      case RefreshMode.withAnalysis:
        return 'With Analysis Updates';
    }
  }

  String _getModeDescription(RefreshMode mode) {
    switch (mode) {
      case RefreshMode.manual:
        return 'Refresh only when manually triggered';
      case RefreshMode.interval:
        return 'Refresh at regular time intervals';
      case RefreshMode.cron:
        return 'Refresh based on cron schedule';
      case RefreshMode.withAnalysis:
        return 'Refresh when linked analyses update';
    }
  }
}

class RefreshStatusIndicator extends ConsumerWidget {
  const RefreshStatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshState = ref.watch(dashboardRefreshControllerProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getStatusColor(refreshState.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(refreshState.status),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(refreshState.status),
            size: 16,
            color: _getStatusColor(refreshState.status),
          ),
          const SizedBox(width: 6),
          Text(
            _getStatusText(refreshState),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStatusColor(refreshState.status),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RefreshStatus status) {
    switch (status) {
      case RefreshStatus.active:
        return Colors.green;
      case RefreshStatus.refreshing:
        return Colors.blue;
      case RefreshStatus.error:
        return Colors.red;
      case RefreshStatus.stopped:
        return Colors.orange;
      case RefreshStatus.idle:
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(RefreshStatus status) {
    switch (status) {
      case RefreshStatus.active:
        return Icons.check_circle;
      case RefreshStatus.refreshing:
        return Icons.refresh;
      case RefreshStatus.error:
        return Icons.error;
      case RefreshStatus.stopped:
        return Icons.stop_circle;
      case RefreshStatus.idle:
      default:
        return Icons.info;
    }
  }

  String _getStatusText(DashboardRefreshState state) {
    switch (state.status) {
      case RefreshStatus.active:
        if (state.lastRefreshTime != null) {
          final difference = DateTime.now().difference(state.lastRefreshTime!);
          if (difference.inSeconds < 60) {
            return 'Just now';
          } else if (difference.inMinutes < 60) {
            return '${difference.inMinutes}m ago';
          } else {
            return '${difference.inHours}h ago';
          }
        }
        return 'Active';
      case RefreshStatus.refreshing:
        return 'Refreshing...';
      case RefreshStatus.error:
        return 'Error';
      case RefreshStatus.stopped:
        return 'Stopped';
      case RefreshStatus.idle:
      default:
        return 'Idle';
    }
  }
}
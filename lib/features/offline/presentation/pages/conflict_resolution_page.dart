import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/offline/domain/entities/sync_conflict.dart';
import 'package:frontend/features/offline/data/repositories/conflict_repository_impl.dart';

/// Page for viewing and resolving sync conflicts
class ConflictResolutionPage extends ConsumerStatefulWidget {
  const ConflictResolutionPage({super.key});

  @override
  ConsumerState<ConflictResolutionPage> createState() =>
      _ConflictResolutionPageState();
}

class _ConflictResolutionPageState
    extends ConsumerState<ConflictResolutionPage> {
  bool _isLoading = false;
  List<SyncConflict> _conflicts = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConflicts();
  }

  Future<void> _loadConflicts() async {
    setState(() => _isLoading = true);
    try {
      final repo = ConflictRepositoryImpl();
      await repo.init();
      final conflicts = await repo.getPendingConflicts();
      setState(() {
        _conflicts = conflicts;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _resolveConflict(
    SyncConflict conflict,
    ConflictStatus resolution,
  ) async {
    setState(() => _isLoading = true);
    try {
      final repo = ConflictRepositoryImpl();
      await repo.init();
      await repo.resolveConflict(
        conflict.id,
        resolution,
        resolutionNote: 'Resolved by user',
      );

      // If keeping local, we might need to apply the local data
      // If keeping remote, we might need to fetch the remote data
      // This would be implemented based on the entity type

      await _loadConflicts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Conflict resolved: ${_getResolutionText(resolution)}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resolve conflict: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getResolutionText(ConflictStatus status) {
    switch (status) {
      case ConflictStatus.resolvedLocal:
        return 'Kept local changes';
      case ConflictStatus.resolvedRemote:
        return 'Kept remote changes';
      case ConflictStatus.resolvedMerge:
        return 'Merged changes';
      default:
        return 'Resolved';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Conflicts'),
        actions: [
          if (_conflicts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadConflicts,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading conflicts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadConflicts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_conflicts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No Conflicts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('All your changes are synced!'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadConflicts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _conflicts.length,
        itemBuilder: (context, index) {
          return ConflictCard(
            conflict: _conflicts[index],
            onResolve: (resolution) =>
                _resolveConflict(_conflicts[index], resolution),
          );
        },
      ),
    );
  }
}

/// Card widget for displaying a single conflict
class ConflictCard extends StatelessWidget {
  final SyncConflict conflict;
  final Function(ConflictStatus) onResolve;

  const ConflictCard({
    super.key,
    required this.conflict,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildConflictTypeIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getConflictTypeText(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conflict.entityType,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRetryBadge(),
              ],
            ),
            const Divider(height: 24),
            _buildTimestampInfo(),
            const SizedBox(height: 12),
            _buildDataPreview(context),
            const SizedBox(height: 16),
            _buildResolutionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictTypeIcon() {
    IconData icon;
    Color color;

    switch (conflict.type) {
      case ConflictType.concurrentModification:
        icon = Icons.compare_arrows;
        color = Colors.orange;
        break;
      case ConflictType.remoteDeletion:
        icon = Icons.delete_forever;
        color = Colors.red;
        break;
      case ConflictType.duplicateCreation:
        icon = Icons.content_copy;
        color = Colors.purple;
        break;
      case ConflictType.versionMismatch:
        icon = Icons.error_outline;
        color = Colors.amber;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildRetryBadge() {
    if (conflict.retryCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${conflict.retryCount} retries',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _getConflictTypeText() {
    switch (conflict.type) {
      case ConflictType.concurrentModification:
        return 'Concurrent Modification';
      case ConflictType.remoteDeletion:
        return 'Remote Deletion';
      case ConflictType.duplicateCreation:
        return 'Duplicate Creation';
      case ConflictType.versionMismatch:
        return 'Version Mismatch';
    }
  }

  Widget _buildTimestampInfo() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          'Local: ${_formatTimestamp(conflict.localTimestamp)}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(width: 16),
        Icon(Icons.cloud, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          'Remote: ${_formatTimestamp(conflict.remoteTimestamp)}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildDataPreview(BuildContext context) {
    return ExpansionTile(
      title: const Text('View Data'),
      children: [
        _buildDataSection('Local Data', conflict.localData, Colors.blue),
        _buildDataSection('Remote Data', conflict.remoteData, Colors.orange),
      ],
    );
  }

  Widget _buildDataSection(
    String title,
    Map<String, dynamic> data,
    MaterialColor color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color.shade700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          ...data.entries
              .take(5)
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (data.length > 5)
            Text(
              '... and ${data.length - 5} more fields',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResolutionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onResolve(ConflictStatus.resolvedLocal),
            icon: const Icon(Icons.phone_android, size: 18),
            label: const Text('Keep Local'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onResolve(ConflictStatus.resolvedRemote),
            icon: const Icon(Icons.cloud, size: 18),
            label: const Text('Keep Remote'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onResolve(ConflictStatus.resolvedMerge),
            icon: const Icon(Icons.merge_type, size: 18),
            label: const Text('Merge'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/services/connectivity_service.dart';
import 'package:frontend/features/offline/data/services/enhanced_sync_service.dart';

/// Widget that displays offline status and sync information
class OfflineStatusIndicator extends ConsumerWidget {
  const OfflineStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);
    final syncState = ref.watch(enhancedSyncServiceProvider);

    return syncState.when(
      data: (_) {
        final pendingCount = ref
            .read(enhancedSyncServiceProvider.notifier)
            .pendingCount;
        final conflictCountFuture = ref
            .read(enhancedSyncServiceProvider.notifier)
            .pendingConflictCount;

        return FutureBuilder<int>(
          future: conflictCountFuture,
          builder: (context, snapshot) {
            final conflictCount = snapshot.data ?? 0;
            final totalPending = pendingCount + conflictCount;

            if (totalPending == 0 &&
                connectivity == ConnectivityStatus.online) {
              return const SizedBox.shrink();
            }

            return _buildIndicator(
              context,
              connectivity,
              pendingCount,
              conflictCount,
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildIndicator(
    BuildContext context,
    ConnectivityStatus connectivity,
    int pendingCount,
    int conflictCount,
  ) {
    final isOffline = connectivity == ConnectivityStatus.offline;
    final theme = Theme.of(context);

    Color backgroundColor;
    Color borderColor;
    Color iconColor;
    IconData icon;
    String message;

    if (conflictCount > 0) {
      backgroundColor = Colors.red.withValues(alpha: 0.1);
      borderColor = Colors.red.withValues(alpha: 0.5);
      iconColor = Colors.red;
      icon = Icons.warning_amber_rounded;
      message =
          '$conflictCount conflict${conflictCount == 1 ? '' : 's'} need resolution';
    } else if (isOffline) {
      backgroundColor = Colors.orange.withValues(alpha: 0.1);
      borderColor = Colors.orange.withValues(alpha: 0.5);
      iconColor = Colors.orange;
      icon = Icons.cloud_off;
      message =
          'You are offline. $pendingCount item${pendingCount == 1 ? '' : 's'} will sync when connected.';
    } else {
      backgroundColor = Colors.blue.withValues(alpha: 0.1);
      borderColor = Colors.blue.withValues(alpha: 0.5);
      iconColor = Colors.blue;
      icon = Icons.sync;
      message = 'Syncing $pendingCount item${pendingCount == 1 ? '' : 's'}...';
    }

    return Tooltip(
      message: message,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(
              '${pendingCount + conflictCount}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width banner for offline mode
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);
    final syncState = ref.watch(enhancedSyncServiceProvider);

    if (connectivity == ConnectivityStatus.online) {
      return const SizedBox.shrink();
    }

    return syncState.when(
      data: (_) {
        final pendingCount = ref
            .read(enhancedSyncServiceProvider.notifier)
            .pendingCount;
        final conflictCountFuture = ref
            .read(enhancedSyncServiceProvider.notifier)
            .pendingConflictCount;

        return FutureBuilder<int>(
          future: conflictCountFuture,
          builder: (context, snapshot) {
            final conflictCount = snapshot.data ?? 0;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                border: const Border(
                  bottom: BorderSide(color: Colors.orange, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_off, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You are offline. Changes will be saved locally and synced when you reconnect.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                  if (pendingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$pendingCount pending',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Floating action button for manual sync trigger
class SyncFab extends ConsumerWidget {
  const SyncFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);
    final syncState = ref.watch(enhancedSyncServiceProvider);

    if (connectivity == ConnectivityStatus.offline) {
      return const SizedBox.shrink();
    }

    return syncState.when(
      data: (_) {
        final pendingCount = ref
            .read(enhancedSyncServiceProvider.notifier)
            .pendingCount;
        final conflictCountFuture = ref
            .read(enhancedSyncServiceProvider.notifier)
            .pendingConflictCount;

        return FutureBuilder<int>(
          future: conflictCountFuture,
          builder: (context, snapshot) {
            final conflictCount = snapshot.data ?? 0;
            final totalPending = pendingCount + conflictCount;

            if (totalPending == 0) {
              return const SizedBox.shrink();
            }

            return FloatingActionButton.extended(
              onPressed: () async {
                final result = await ref
                    .read(enhancedSyncServiceProvider.notifier)
                    .syncPendingSubmissions();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.errorMessage ??
                            'Synced ${result.syncedCount} item${result.syncedCount == 1 ? '' : 's'}',
                      ),
                      backgroundColor: result.success
                          ? Colors.green
                          : Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.sync),
              label: Text('Sync $totalPending'),
              backgroundColor: conflictCount > 0 ? Colors.red : Colors.blue,
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

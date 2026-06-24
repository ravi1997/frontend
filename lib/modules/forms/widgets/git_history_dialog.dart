import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'package:frontend/modules/forms/services/git_controller.dart';

class GitHistoryDialog extends ConsumerStatefulWidget {
  final String controllerKey;
  final String projectId;
  final String formId;

  const GitHistoryDialog({
    super.key,
    required this.controllerKey,
    required this.projectId,
    required this.formId,
  });

  @override
  ConsumerState<GitHistoryDialog> createState() => _GitHistoryDialogState();
}

class _GitHistoryDialogState extends ConsumerState<GitHistoryDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gitControllerProvider(widget.controllerKey).notifier).loadCommits(
            widget.projectId,
            widget.formId,
          );
    });
  }

  void _showSchemaPreview(String commitId, Map<String, dynamic> schema) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.code, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Schema at: ${commitId.substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 600,
          height: 450,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                const JsonEncoder.withIndent('  ').convert(schema),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.lightGreenAccent,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy to Clipboard'),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: const JsonEncoder.withIndent('  ').convert(schema)),
              );
              ref.read(snackbarServiceProvider).showSuccess('Copied to clipboard');
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatPath(String path) {
    if (path.isEmpty || path == '/') return 'Root';
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    final result = <String>[];
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      final index = int.tryParse(part);
      if (index != null) {
        final label = i > 0 ? '${result.last} #${index + 1}' : 'Item #${index + 1}';
        if (result.isNotEmpty) result.removeLast();
        result.add(label);
      } else {
        result.add(part[0].toUpperCase() + part.substring(1));
      }
    }
    return result.join(' ➔ ');
  }

  void _showCommitDiff(GitBranchCommit commit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.codeCompare, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Changes in Commit: ${commit.id.substring(0, 8)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    commit.message,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 650,
          height: 500,
          child: commit.patch.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey.shade400, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'No changes detected in this commit (Clean merge / initial version)',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: commit.patch.length,
                  itemBuilder: (context, index) {
                    final patchOp = commit.patch[index] as Map<String, dynamic>;
                    final op = patchOp['op'] ?? 'replace';
                    final rawPath = patchOp['path'] ?? '';
                    final pathLabel = _formatPath(rawPath);
                    final dynamic rawValue = patchOp['value'];
                    final valString = rawValue == null
                        ? '(empty)'
                        : rawValue is Map || rawValue is List
                            ? const JsonEncoder.withIndent('  ').convert(rawValue)
                            : rawValue.toString();

                    Color itemBgColor = Colors.grey.shade50;
                    Color itemBorderColor = Colors.grey.shade300;
                    IconData itemIcon = Icons.edit_note;
                    String opLabel = 'MODIFIED';
                    Color labelColor = Colors.blue.shade700;

                    if (op == 'add') {
                      itemBgColor = Colors.green.shade50.withValues(alpha: 0.5);
                      itemBorderColor = Colors.green.shade200;
                      itemIcon = Icons.add_circle_outline;
                      opLabel = 'ADDED';
                      labelColor = Colors.green.shade700;
                    } else if (op == 'remove') {
                      itemBgColor = Colors.red.shade50.withValues(alpha: 0.5);
                      itemBorderColor = Colors.red.shade200;
                      itemIcon = Icons.remove_circle_outline;
                      opLabel = 'DELETED';
                      labelColor = Colors.red.shade700;
                    } else if (op == 'replace') {
                      itemBgColor = Colors.amber.shade50.withValues(alpha: 0.3);
                      itemBorderColor = Colors.amber.shade200;
                      itemIcon = Icons.change_circle_outlined;
                      opLabel = 'REPLACED';
                      labelColor = Colors.amber.shade800;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: itemBgColor,
                        border: Border.all(color: itemBorderColor, width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(itemIcon, color: labelColor, size: 18),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: labelColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  opLabel,
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  pathLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (op != 'remove') ...[
                            const Text(
                              'Value:',
                              style: TextStyle(color: AppColors.textGrey, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                valString,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gitState = ref.watch(gitControllerProvider(widget.controllerKey));
    final commits = gitState.commits;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 24,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.58,
        height: MediaQuery.of(context).size.height * 0.78,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.clockRotateLeft, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Git Version Tree',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Active branch: ${gitState.activeBranch}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            // Commits History Tree List
            Expanded(
              child: gitState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : commits.isEmpty
                      ? Center(
                          child: Text(
                            'No commits on this branch yet.',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        )
                      : ListView.builder(
                          itemCount: commits.length,
                          itemBuilder: (context, index) {
                            final commit = commits[index];
                            final isFirst = index == 0;
                            final isLast = index == commits.length - 1;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Tree line connector sidebar
                                  Container(
                                    width: 32,
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    child: CustomPaint(
                                      painter: _TreeLinePainter(
                                        isFirst: isFirst,
                                        isLast: isLast,
                                        indicatorColor: AppColors.primary,
                                      ),
                                    ),
                                  ),

                                  // Commit Info Card
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey.shade200),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      commit.message,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.textDark,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey.shade200,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        commit.id.substring(0, 8),
                                                        style: TextStyle(
                                                          fontFamily: 'monospace',
                                                          fontSize: 11,
                                                          color: Colors.grey.shade700,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Author: ${commit.authorId} • ${commit.timestamp.toLocal().toString().substring(0, 16)}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.difference_outlined, color: AppColors.primary),
                                            tooltip: 'View Diff',
                                            onPressed: () {
                                              _showCommitDiff(commit);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.visibility_outlined),
                                            tooltip: 'Preview Schema',
                                            onPressed: () {
                                              _showSchemaPreview(commit.id, {
                                                "commit_id": commit.id,
                                                "message": commit.message,
                                                "timestamp": commit.timestamp.toIso8601String(),
                                                "patch_operations": commit.patch
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreeLinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color indicatorColor;

  _TreeLinePainter({
    required this.isFirst,
    required this.isLast,
    required this.indicatorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paintCircle = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw vertical connector lines
    if (!isFirst) {
      canvas.drawLine(Offset(centerX, 0), Offset(centerX, centerY), paintLine);
    }
    if (!isLast) {
      canvas.drawLine(Offset(centerX, centerY), Offset(centerX, size.height), paintLine);
    }

    // Draw node indicator dot
    canvas.drawCircle(Offset(centerX, centerY), 6.0, paintCircle);

    // Draw inner hole for design styling
    canvas.drawCircle(
      Offset(centerX, centerY),
      3.0,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

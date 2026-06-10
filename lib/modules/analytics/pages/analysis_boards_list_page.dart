import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';

class ProjectAnalysisBoardsListPage extends StatefulWidget {
  final String projectId;

  const ProjectAnalysisBoardsListPage({super.key, required this.projectId});

  @override
  State<ProjectAnalysisBoardsListPage> createState() =>
      _ProjectAnalysisBoardsListPageState();
}

class _ProjectAnalysisBoardsListPageState
    extends State<ProjectAnalysisBoardsListPage> {
  final List<Map<String, dynamic>> _mockBoards = [
    {
      'id': 'board-101',
      'title': 'Year-over-Year Health Metrics Board',
      'description':
          'Cross-reference and ratio aspects tracking responder ages and scoring variances across 2025/2026.',
      'nodesCount': 3,
      'createdAt': 'May 26, 2026',
    },
    {
      'id': 'board-102',
      'title': 'Operational Statistics Aggregator',
      'description': 'Real-time MIN/MAX peaks monitoring complete cohort answer metrics.',
      'nodesCount': 4,
      'createdAt': 'May 27, 2026',
    },
  ];

  void _showStubNotice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Analysis boards'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Responsive.pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroCard(
                    projectId: widget.projectId,
                    onCreateBoard: () => _showStubNotice(
                      'Board creation is not wired yet. This page is a stub list.',
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 760;

                      if (isCompact) {
                        return Column(
                          children: _mockBoards
                              .map(
                                (board) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: DesignTokens.spaceM,
                                  ),
                                  child: _BoardCard(
                                    board: board,
                                    onOpen: () => _showStubNotice(
                                      'Board editor route is not wired yet for ${board['id']}.',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }

                      return Column(
                        children: _mockBoards
                            .map(
                              (board) => Padding(
                                padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                                child: _BoardCard(
                                  board: board,
                                  onOpen: () => _showStubNotice(
                                    'Board editor route is not wired yet for ${board['id']}.',
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String projectId;
  final VoidCallback onCreateBoard;

  const _HeroCard({
    required this.projectId,
    required this.onCreateBoard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.darkBackground,
            DesignTokens.primaryDark.withValues(alpha: 0.96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              );

          final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.5,
              );

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Analysis boards', style: titleStyle),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                'Design, wire, and execute complex cross-form calculations visually.',
                style: bodyStyle,
              ),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                'Project ID: $projectId',
                style: bodyStyle,
              ),
              const SizedBox(height: DesignTokens.spaceL),
              Wrap(
                spacing: DesignTokens.spaceS,
                runSpacing: DesignTokens.spaceS,
                children: const [
                  _HeroTag(label: 'Status', value: 'Stub list'),
                  _HeroTag(label: 'Routing', value: 'Board editor not wired'),
                ],
              ),
              const SizedBox(height: DesignTokens.spaceL),
              FilledButton.icon(
                onPressed: onCreateBoard,
                icon: const Icon(Icons.add),
                label: const Text('Create board'),
              ),
            ],
          );

          if (compact) return content;
          return content;
        },
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  final String label;
  final String value;

  const _HeroTag({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _BoardCard extends StatelessWidget {
  final Map<String, dynamic> board;
  final VoidCallback onOpen;

  const _BoardCard({required this.board, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: DesignTokens.primarySoft,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: DesignTokens.primary,
                ),
              ),
              const SizedBox(width: DesignTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      board['title']?.toString() ?? 'Untitled board',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      board['description']?.toString() ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.45,
                            color: cs.onSurface.withValues(alpha: 0.65),
                          ),
                    ),
                    const SizedBox(height: DesignTokens.spaceM),
                    Wrap(
                      spacing: DesignTokens.spaceS,
                      runSpacing: DesignTokens.spaceS,
                      children: [
                        _MetaChip(
                          label: 'Nodes',
                          value: '${board['nodesCount'] ?? 0}',
                        ),
                        _MetaChip(
                          label: 'Created',
                          value: board['createdAt']?.toString() ?? 'Unknown',
                        ),
                        const _MetaChip(label: 'Stub', value: 'No editor route'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spaceS),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: cs.onSurface.withValues(alpha: 0.32),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetaChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceS,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withValues(alpha: 0.72),
            ),
      ),
    );
  }
}

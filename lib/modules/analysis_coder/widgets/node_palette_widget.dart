"""
lib/modules/analysis_coder/widgets/node_palette_widget.dart
Widget for displaying available node types that can be added to the graph.
"""

import 'package:flutter/material.dart';

import '../models/analysis_models.dart';
import '../theme/analysis_theme.dart';

class NodePaletteWidget extends StatelessWidget {
  final Function(NodeDefinition, Offset) onNodeSelected;
  final List<NodeDefinition> nodeDefinitions;

  const NodePaletteWidget({
    super.key,
    required this.onNodeSelected,
    required this.nodeDefinitions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AnalysisTheme.of(context);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: theme.paletteBackgroundColor,
        border: Border(
          right: BorderSide(color: theme.paletteBorderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.paletteHeaderColor,
              border: Border(
                bottom: BorderSide(color: theme.paletteBorderColor),
              ),
            ),
            child: Text(
              'Node Library',
              style: theme.paletteTitleStyle,
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search nodes...',
                hintStyle: theme.searchHintStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              style: theme.searchTextStyle,
            ),
          ),
          // Categories
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildCategorySection(
                  context: context,
                  title: 'Data Sources',
                  category: NodeCategory.dataSource,
                  nodeDefinitions: nodeDefinitions,
                  theme: theme,
                ),
                _buildCategorySection(
                  context: context,
                  title: 'Transforms',
                  category: NodeCategory.transform,
                  nodeDefinitions: nodeDefinitions,
                  theme: theme,
                ),
                _buildCategorySection(
                  context: context,
                  title: 'Aggregations',
                  category: NodeCategory.aggregation,
                  nodeDefinitions: nodeDefinitions,
                  theme: theme,
                ),
                _buildCategorySection(
                  context: context,
                  title: 'Outputs',
                  category: NodeCategory.output,
                  nodeDefinitions: nodeDefinitions,
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required BuildContext context,
    required String title,
    required NodeCategory category,
    required List<NodeDefinition> nodeDefinitions,
    required AnalysisThemeData theme,
  }) {
    final categoryNodes = nodeDefinitions
        .where((node) => node.category == category)
        .toList();

    if (categoryNodes.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      title: Text(
        title,
        style: theme.categoryTitleStyle,
      ),
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: categoryNodes.map((node) => _buildNodeTile(
        context: context,
        node: node,
        theme: theme,
      )).toList(),
    );
  }

  Widget _buildNodeTile({
    required BuildContext context,
    required NodeDefinition node,
    required AnalysisThemeData theme,
  }) {
    Color nodeColor;
    switch (node.category) {
      case NodeCategory.dataSource:
        nodeColor = theme.dataSourceColor;
        break;
      case NodeCategory.transform:
        nodeColor = theme.transformColor;
        break;
      case NodeCategory.aggregation:
        nodeColor = theme.aggregationColor;
        break;
      case NodeCategory.output:
        nodeColor = theme.outputColor;
        break;
    }

    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: nodeColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          node.icon,
          color: Colors.white,
          size: 18,
        ),
      ),
      title: Text(
        node.name,
        style: theme.nodeNameStyle,
      ),
      subtitle: Text(
        node.description,
        style: theme.nodeDescriptionStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // Show node at center of graph
        final mediaQuery = MediaQuery.of(context);
        final centerPosition = Offset(
          mediaQuery.size.width / 2,
          mediaQuery.size.height / 2,
        );
        onNodeSelected(node, centerPosition);
      },
    );
  }
}
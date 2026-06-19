"""
lib/modules/dashboard_builder/widgets/natural_language_query_widget.dart
Natural language query interface for dashboard filters and data exploration.
"""

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/natural_language_query_provider.dart';

class NaturalLanguageQueryWidget extends ConsumerStatefulWidget {
  final String dashboardId;
  final List<AnalysisModel> availableAnalyses;
  final Function(Map<String, dynamic>) onFiltersGenerated;

  const NaturalLanguageQueryWidget({
    super.key,
    required this.dashboardId,
    required this.availableAnalyses,
    required this.onFiltersGenerated,
  });

  @override
  ConsumerState<NaturalLanguageQueryWidget> createState() => _NaturalLanguageQueryWidgetState();
}

class _NaturalLanguageQueryWidgetState extends ConsumerState<NaturalLanguageQueryWidget> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submitQuery() {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    ref.read(naturalLanguageQueryProvider(widget.dashboardId).notifier).processQuery(
      query: query,
      availableAnalyses: widget.availableAnalyses,
    );
  }

  @override
  Widget build(BuildContext context) {
    final queryState = ref.watch(naturalLanguageQueryProvider(widget.dashboardId));
    final isProcessing = queryState.isProcessing;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Natural Language Query',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Ask questions about your data in plain English',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close query interface',
                ),
              ],
            ),
          ),

          // Query history and results
          Expanded(
            child: _buildQueryContent(queryState),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                // Example queries
                _buildExampleQueries(),
                const SizedBox(height: 12),
                
                // Query input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryController,
                        decoration: InputDecoration(
                          hintText: 'Ask about your data... (e.g., "Show me responses from last month")',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: isProcessing ? null : _submitQuery,
                          ),
                        ),
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: (_) => _submitQuery(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueryContent(NaturalLanguageQueryState queryState) {
    if (queryState.queries.isEmpty) {
      return _buildWelcomeMessage();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: queryState.queries.length,
      itemBuilder: (context, index) {
        final query = queryState.queries[index];
        return _buildQueryResult(query);
      },
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.search,
                color: Colors.blue[600],
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ask Questions About Your Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'I can help you explore your dashboard data using natural language.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestionChip('Show me last 30 days'),
                _buildSuggestionChip('Compare this month to last month'),
                _buildSuggestionChip('Top performing regions'),
                _buildSuggestionChip('Filter by completed responses'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _queryController.text = text;
      },
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(color: Colors.blue[700]),
    );
  }

  Widget _buildQueryResult(NaturalLanguageQuery query) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User query
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    query.query,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // AI response
          if (query.response != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.smart_toy, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        query.response!.explanation,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  
                  if (query.response!.filters.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Generated Filters:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...query.response!.filters.map((filter) => _buildFilterChip(filter)),
                  ],
                  
                  if (query.response!.suggestedVisualizations.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Suggested Visualizations:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: query.response!.suggestedVisualizations.map((viz) {
                        return ActionChip(
                          label: Text(viz),
                          onPressed: () {
                            // Create suggested visualization
                          },
                          backgroundColor: Colors.green[50],
                          labelStyle: TextStyle(color: Colors.green[700]),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

          // Error message
          if (query.error != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      query.error!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(NaturalLanguageFilter filter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Chip(
        label: Text('${filter.field} ${filter.operator} ${filter.value}'),
        backgroundColor: Colors.blue[50],
        labelStyle: TextStyle(color: Colors.blue[700]),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          // Remove filter
        },
      ),
    );
  }

  Widget _buildExampleQueries() {
    return Wrap(
      spacing: 8,
      children: [
        _buildExampleChip('Time-based', 'Show data from last week'),
        _buildExampleChip('Comparison', 'Compare Q1 to Q2'),
        _buildExampleChip('Filtering', 'Show only completed items'),
        _buildExampleChip('Aggregation', 'Summarize by category'),
      ],
    );
  }

  Widget _buildExampleChip(String category, String example) {
    return InputChip(
      label: Text(category),
      onPressed: () {
        _queryController.text = example;
      },
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: Colors.grey[700]),
      tooltip: example,
    );
  }
}
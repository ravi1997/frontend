"""
lib/modules/admin/pages/llm_usage_dashboard_page.dart
LLM Usage Dashboard for monitoring AI usage and costs.
"""

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/llm_config_models.dart';
import '../../providers/llm_config_provider.dart';

class LLMUsageDashboardPage extends ConsumerStatefulWidget {
  const LLMUsageDashboardPage({super.key});

  @override
  ConsumerState<LLMUsageDashboardPage> createState() => _LLMUsageDashboardPageState();
}

class _LLMUsageDashboardPageState extends ConsumerState<LLMUsageDashboardPage> {
  String _selectedTimeRange = '7d';
  String _selectedView = 'overview';

  @override
  Widget build(BuildContext context) {
    final configState = ref.watch(llmConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LLM Usage Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '1d', child: Text('Last 24 Hours')),
              const PopupMenuItem(value: '7d', child: Text('Last 7 Days')),
              const PopupMenuItem(value: '30d', child: Text('Last 30 Days')),
              const PopupMenuItem(value: '90d', child: Text('Last 90 Days')),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedView = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'overview', child: Text('Overview')),
              const PopupMenuItem(value: 'detailed', child: Text('Detailed')),
              const PopupMenuItem(value: 'costs', child: Text('Cost Analysis')),
            ],
          ),
        ],
      ),
      body: configState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading usage data',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(llmConfigProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (config) => _buildDashboardContent(config),
      ),
    );
  }

  Widget _buildDashboardContent(LLMConfiguration config) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time range selector
          _buildTimeRangeSelector(),
          const SizedBox(height: 24),

          // Main metrics
          _buildMainMetrics(config.usage),
          const SizedBox(height: 24),

          // View-specific content
          if (_selectedView == 'overview')
            _buildOverviewView(config)
          else if (_selectedView == 'detailed')
            _buildDetailedView(config)
          else if (_selectedView == 'costs')
            _buildCostAnalysisView(config),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.date_range, size: 20),
          const SizedBox(width: 8),
          Text(
            'Time Range: $_selectedTimeRange',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              // Refresh data
              ref.refresh(llmConfigProvider);
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMetrics(LLMUsageStats usage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard(
              'Total Tokens',
              NumberFormat.compact().format(usage.totalTokens),
              Icons.token,
              Colors.blue,
            ),
            _buildMetricCard(
              'Total Cost',
              '\$${usage.totalCost.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.green,
            ),
            _buildMetricCard(
              'Requests Today',
              NumberFormat.compact().format(usage.requestsToday),
              Icons.today,
              Colors.orange,
            ),
            _buildMetricCard(
              'Quota Usage',
              '${(usage.quotaUsagePercentage * 100).toStringAsFixed(1)}%',
              Icons.data_usage,
              usage.quotaUsagePercentage > 0.8 ? Colors.red : Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewView(LLMConfiguration config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Usage chart
        _buildUsageChart(config.usage),
        const SizedBox(height: 24),

        // Model usage breakdown
        _buildModelUsageBreakdown(config.models),
        const SizedBox(height: 24),

        // Provider distribution
        _buildProviderDistribution(config.providers),
      ],
    );
  }

  Widget _buildUsageChart(LLMUsageStats usage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Usage chart would be displayed here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelUsageBreakdown(List<LLMModel> models) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Usage Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...models.map((model) => _buildModelUsageRow(model)),
          ],
        ),
      ),
    );
  }

  Widget _buildModelUsageRow(LLMModel model) {
    // Mock usage data for each model
    final mockUsage = {
      'tokens': (model.maxTokens * 0.1).toInt(),
      'cost': model.costPer1kTokens * 10,
      'requests': 50 + (model.maxTokens % 100),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  model.provider,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${NumberFormat.compact().format(mockUsage['tokens'])} tokens',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              '\$${mockUsage['cost']?.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              '${mockUsage['requests']} requests',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderDistribution(List<LLMProvider> providers) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provider Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: providers.map((provider) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getProviderColor(provider.type),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                provider.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Provider distribution chart'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedView(LLMConfiguration config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request timeline
        _buildRequestTimeline(),
        const SizedBox(height: 24),

        // Error analysis
        _buildErrorAnalysis(),
        const SizedBox(height: 24),

        // Performance metrics
        _buildPerformanceMetrics(),
      ],
    );
  }

  Widget _buildRequestTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Timeline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Request timeline would be displayed here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error Analysis',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Error analysis chart would be displayed here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2,
              children: [
                _buildPerformanceCard(
                  'Avg Response Time',
                  '1.2s',
                  Icons.speed,
                  Colors.blue,
                ),
                _buildPerformanceCard(
                  'Success Rate',
                  '98.5%',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildPerformanceCard(
                  'Timeout Rate',
                  '0.3%',
                  Icons.timer_off,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostAnalysisView(LLMConfiguration config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cost breakdown
        _buildCostBreakdown(config.models),
        const SizedBox(height: 24),

        // Cost projection
        _buildCostProjection(),
        const SizedBox(height: 24),

        // Cost optimization suggestions
        _buildCostOptimizationSuggestions(),
      ],
    );
  }

  Widget _buildCostBreakdown(List<LLMModel> models) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Breakdown by Model',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...models.map((model) {
              final mockCost = model.costPer1kTokens * 100; // Mock cost
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        model.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '\$${mockCost.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${model.costPer1kTokens.toStringAsFixed(4)}/1K',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCostProjection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Cost Projection',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Cost projection chart would be displayed here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostOptimizationSuggestions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Optimization Suggestions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...[
              _buildSuggestionCard(
                'Use GPT-3.5 for simple tasks',
                'Switch to GPT-3.5 for basic text generation to save 90% on costs.',
                Icons.lightbulb,
                Colors.yellow,
              ),
              _buildSuggestionCard(
                'Implement response caching',
                'Cache common responses to reduce API calls by up to 40%.',
                Icons.cache,
                Colors.blue,
              ),
              _buildSuggestionCard(
                'Set spending limits',
                'Configure monthly spending limits to prevent unexpected costs.',
                Icons.account_balance_wallet,
                Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getProviderColor(String providerType) {
    switch (providerType.toLowerCase()) {
      case 'openai':
        return Colors.green;
      case 'anthropic':
        return Colors.purple;
      case 'ollama':
        return Colors.orange;
      case 'google':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
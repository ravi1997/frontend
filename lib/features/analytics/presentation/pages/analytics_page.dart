import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/submission_trend_chart.dart';
import '../widgets/response_distribution_chart.dart';
import '../../domain/entities/form_analytics.dart';

class AnalyticsPage extends ConsumerWidget {
  final String formId;

  const AnalyticsPage({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsControllerProvider(formId));

    return Scaffold(
      backgroundColor: AppColors.builderBackground,
      appBar: AppBar(
        title: const Text('Form Analytics'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(analyticsControllerProvider(formId).notifier)
                .refresh(),
          ),
        ],
      ),
      body: analyticsState.when(
        data: (analytics) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryGrid(context, analytics),
              const SizedBox(height: 32),
              _buildSectionTitle('Submission Trends'),
              const SizedBox(height: 16),
              _buildChartCard(
                child: SubmissionTrendChart(trends: analytics.trends),
                height: 300,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Field Distributions'),
              const SizedBox(height: 16),
              ...analytics.fieldDistributions.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildChartCard(
                        child: ResponseDistributionChart(
                          distribution: entry.value,
                        ),
                        height: 250,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context, FormAnalytics analytics) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          'Total Submissions',
          analytics.totalSubmissions.toString(),
          Icons.description_outlined,
          AppColors.primary,
        ),
        _buildSummaryCard(
          'Completion Rate',
          '${(analytics.completionRate * 100).toInt()}%',
          Icons.assignment_turned_in_outlined,
          Colors.teal,
        ),
        _buildSummaryCard(
          'Avg. Time',
          '2m 14s',
          Icons.timer_outlined,
          Colors.amber,
        ),
        _buildSummaryCard(
          'Active Since',
          'Jan 15',
          Icons.calendar_today_outlined,
          Colors.indigo,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required Widget child, required double height}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/analytics_repository.dart';
import 'package:frontend/features/analytics/domain/entities/form_analytics.dart';
import '../widgets/submission_trend_chart.dart';
import '../widgets/response_distribution_chart.dart';

final analyticsProvider = FutureProvider.family<FormAnalytics, String>((
  ref,
  formId,
) async {
  return ref.read(analyticsRepositoryProvider).getAnalytics(formId);
});

class AnalyticsPage extends ConsumerWidget {
  final String formId;

  const AnalyticsPage({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider(formId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Form Analytics'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: analyticsAsync.when(
        data: (data) => _buildContent(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FormAnalytics data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(data),
          const SizedBox(height: 32),
          _buildChartSection(
            title: 'Submission Trends (Last 7 Days)',
            child: SubmissionTrendChart(trends: data.trends),
          ),
          const SizedBox(height: 32),
          Text(
            'Field-specific Insights',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...data.fieldDistributions.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildChartSection(
                title: entry.key,
                child: ResponseDistributionChart(distribution: entry.value),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(FormAnalytics data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            _buildStatCard(
              'Total Submissions',
              data.totalSubmissions.toString(),
              Icons.people_outline,
            ),
            _buildStatCard(
              'Completion Rate',
              '${data.completionRate}%',
              Icons.check_circle_outline,
            ),
            _buildStatCard('Avg. Time', '2m 30s', Icons.timer_outlined),
            _buildStatCard('Drafts', '12', Icons.edit_note_outlined),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 250, child: child),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../analytics_controller.dart';
import '../analytics_summary.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  final String formId;
  final String projectId;

  const AnalyticsPage({
    super.key,
    required this.formId,
    required this.projectId,
  });

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    // Schedule the initial load after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsControllerProvider(widget.formId).notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(
      analyticsControllerProvider(widget.formId),
    );

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
                .read(analyticsControllerProvider(widget.formId).notifier)
                .refresh(),
          ),
        ],
      ),
      body: _buildBody(context, analyticsState),
    );
  }

  Widget _buildBody(BuildContext context, AnalyticsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 60),
            const SizedBox(height: 16),
            Text(
              'Error loading analytics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.error ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref
                  .read(analyticsControllerProvider(widget.formId).notifier)
                  .refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final summary = state.summary;

    if (summary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryGrid(context, summary),
          const SizedBox(height: 32),
          _buildSectionTitle('Overview'),
          const SizedBox(height: 16),
          const Text(
            'The analytics page now focuses on summary metrics only. '
            'Trend and distribution charts were removed to keep the codebase lean.',
            style: TextStyle(color: AppColors.textGrey, height: 1.4),
          ),
        ],
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

  Widget _buildSummaryGrid(BuildContext context, AnalyticsSummary summary) {
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
          summary.totalSubmissions.toString(),
          Icons.description_outlined,
          AppColors.primary,
        ),
        _buildSummaryCard(
          'Completion Rate',
          '${(summary.completionRate * 100).toInt()}%',
          Icons.assignment_turned_in_outlined,
          Colors.teal,
        ),
        _buildSummaryCard(
          'Avg. Time',
          summary.averageCompletionTime != null
              ? '${(summary.averageCompletionTime! / 60).toInt()}m ${(summary.averageCompletionTime! % 60).toInt()}s'
              : 'N/A',
          Icons.timer_outlined,
          Colors.amber,
        ),
        _buildSummaryCard(
          'Unique Responders',
          summary.uniqueResponders?.toString() ?? 'N/A',
          Icons.people_outline,
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
}

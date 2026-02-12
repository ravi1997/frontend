import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/submission_trend_chart.dart';
import '../../domain/entities/form_analytics.dart';

class AdvancedAnalyticsPage extends ConsumerWidget {
  const AdvancedAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Advanced Analytics'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildMetricsSummary(),
            const SizedBox(height: 32),
            _buildMainCharts(),
            const SizedBox(height: 32),
            _buildTopFormsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Performance',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Deep dive into your organization\'s data capture efficiency.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMetricsSummary() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.8,
      children: [
        _buildMetricCard('Total Submissions', '42,891', '+12.5%', true),
        _buildMetricCard('Avg. Completion Rate', '78.4%', '-2.1%', false),
        _buildMetricCard('Active Users', '1,204', '+5.4%', true),
        _buildMetricCard('Data Integrity Score', '94.2', '+0.8%', true),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String trend,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: isPositive
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainCharts() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildChartContainer(
            'Submission Volume (Last 7 Days)',
            SizedBox(
              height: 300,
              child: SubmissionTrendChart(
                trends: [
                  TimeSeriesData(
                    date: DateTime.now().subtract(const Duration(days: 6)),
                    value: 120,
                  ),
                  TimeSeriesData(
                    date: DateTime.now().subtract(const Duration(days: 5)),
                    value: 150,
                  ),
                  TimeSeriesData(
                    date: DateTime.now().subtract(const Duration(days: 4)),
                    value: 130,
                  ),
                  TimeSeriesData(
                    date: DateTime.now().subtract(const Duration(days: 3)),
                    value: 170,
                  ),
                  TimeSeriesData(
                    date: DateTime.now().subtract(const Duration(days: 2)),
                    value: 160,
                  ),
                  TimeSeriesData(
                    date: DateTime.now().subtract(const Duration(days: 1)),
                    value: 210,
                  ),
                  TimeSeriesData(date: DateTime.now(), value: 420),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildChartContainer(
            'Channel Distribution',
            const SizedBox(
              height: 300,
              child: Center(child: Text('Pie Chart Placeholder')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          chart,
        ],
      ),
    );
  }

  Widget _buildTopFormsTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Performing Forms',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          DataTable(
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('Form Name')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Submissions')),
              DataColumn(label: Text('Avg. Time')),
              DataColumn(label: Text('Status')),
            ],
            rows: [
              _buildDataRow(
                'Customer Feedback 2024',
                'Marketing',
                '1,240',
                '2m 15s',
                'Active',
              ),
              _buildDataRow(
                'Employee Engagement',
                'HR',
                '856',
                '5m 30s',
                'Active',
              ),
              _buildDataRow(
                'Incident Report',
                'Safety',
                '423',
                '1m 20s',
                'Active',
              ),
              _buildDataRow(
                'Product Survey v2',
                'Research',
                '312',
                '4m 05s',
                'Paused',
              ),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(
    String name,
    String category,
    String subs,
    String time,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        DataCell(Text(category)),
        DataCell(Text(subs)),
        DataCell(Text(time)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (status == 'Active' ? Colors.blue : Colors.grey)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Active'
                    ? Colors.blue.shade700
                    : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

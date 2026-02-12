import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class IntegrationsPage extends StatelessWidget {
  const IntegrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Integrations & Apps'),
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
            _buildCategories(),
            const SizedBox(height: 32),
            _buildIntegrationsGrid(),
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
          'Connect Your Workflow',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Automate data flow by connecting your forms to your favorite apps.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = [
      'All',
      'Most Popular',
      'Automation',
      'CRM',
      'Storage',
      'Communication',
      'Developers',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isFirst = cat == 'All';
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(cat),
              selected: isFirst,
              onSelected: (_) {},
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isFirst ? Colors.white : AppColors.textGrey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIntegrationsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 2.2,
      children: [
        _buildIntegrationCard(
          'Webhook',
          'Send real-time data to any URL.',
          Icons.webhook,
          Colors.orange,
          true,
        ),
        _buildIntegrationCard(
          'Zapier',
          'Connect with 5,000+ apps.',
          Icons.flash_on,
          Colors.deepOrange,
          false,
        ),
        _buildIntegrationCard(
          'Slack',
          'Get notifications for new responses.',
          Icons.chat_bubble_outline,
          Colors.purple,
          true,
        ),
        _buildIntegrationCard(
          'Google Sheets',
          'Sync responses to a spreadsheet.',
          Icons.table_chart_outlined,
          Colors.green,
          false,
        ),
        _buildIntegrationCard(
          'Salesforce',
          'Create leads from form submissions.',
          Icons.cloud_queue,
          Colors.blue,
          false,
        ),
        _buildIntegrationCard(
          'Discord',
          'Post updates to your server.',
          Icons.discord,
          Colors.indigo,
          false,
        ),
      ],
    );
  }

  Widget _buildIntegrationCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool isConnected,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected ? AppColors.primary : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    if (isConnected)
                      const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Connected',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'Not configured',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(isConnected ? 'Configure' : 'Connect'),
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
}

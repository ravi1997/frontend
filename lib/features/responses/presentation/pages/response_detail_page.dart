import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/responses/presentation/controllers/responses_controller.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/responses/presentation/controllers/ai_controller.dart';

class ResponseDetailPage extends ConsumerWidget {
  final String responseId;

  const ResponseDetailPage({super.key, required this.responseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseAsync = ref.watch(responseDetailProvider(responseId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Response Detail',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: responseAsync.when(
        data: (response) => _buildDetailContent(context, ref, response),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    WidgetRef ref,
    FormResponse response,
  ) {
    final formAsync = ref.watch(formBuilderControllerProvider(response.formId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(response),
          const SizedBox(height: 24),
          _buildAIInsightsSection(context, ref, response),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              'Answers',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          formAsync.when(
            data: (formState) {
              final questions = formState.form.sections
                  .expand((s) => s.questions)
                  .toList();
              return _buildAnswersList(questions, response.answers);
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => _buildAnswersListFromMap(response.answers),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(FormResponse response) {
    final dateStr = DateFormat(
      'MMMM dd, yyyy HH:mm:ss',
    ).format(response.submittedAt);
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submission ID',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        response.id,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(
              color: AppColors.textSecondary,
              height: 1,
              thickness: 0.1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Text(
                  'Submitted on $dateStr',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswersList(
    List<FormQuestion> questions,
    Map<String, dynamic> answers,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        final answer = answers[question.id] ?? 'Not answered';

        return _buildAnswerItem(question.label.toString(), answer.toString());
      },
    );
  }

  Widget _buildAnswersListFromMap(Map<String, dynamic> answers) {
    final entries = answers.entries.toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildAnswerItem(
          'Question ${entry.key}',
          entry.value.toString(),
        );
      },
    );
  }

  Widget _buildAIInsightsSection(
    BuildContext context,
    WidgetRef ref,
    FormResponse response,
  ) {
    final aiResults = response.aiResults;
    final sentiment = aiResults['sentiment'];
    final moderation = aiResults['moderation'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text(
              'AI Insights',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await ref
                      .read(aIControllerProvider.notifier)
                      .analyzeResponse(response.formId, response.id);
                  ref.invalidate(responseDetailProvider(response.id));
                } catch (e) {
                  // Error handled by interceptor
                }
              },
              icon: const Icon(Icons.psychology, size: 18),
              label: const Text('Analyze'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (sentiment != null || moderation != null)
          Row(
            children: [
              if (sentiment != null)
                Expanded(
                  child: _buildInsightCard(
                    title: 'Sentiment',
                    value: sentiment['label'].toString().toUpperCase(),
                    subtitle: 'Score: ${sentiment['score']}',
                    color: _getSentimentColor(sentiment['label']),
                  ),
                ),
              if (sentiment != null && moderation != null)
                const SizedBox(width: 12),
              if (moderation != null)
                Expanded(
                  child: _buildInsightCard(
                    title: 'Safety',
                    value: moderation['is_safe'] == true ? 'SAFE' : 'RISK',
                    subtitle: '${moderation['flags']?.length ?? 0} flags',
                    color: moderation['is_safe'] == true
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
            ],
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
            child: const Center(
              child: Text(
                'No AI analysis performed yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
      ],
    );
  }

  Color _getSentimentColor(dynamic label) {
    switch (label.toString().toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      case 'neutral':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInsightCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerItem(String label, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

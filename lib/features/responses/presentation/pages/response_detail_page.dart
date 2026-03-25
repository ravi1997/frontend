import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/features/responses/presentation/controllers/responses_controller.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/features/responses/presentation/controllers/ai_controller.dart';
import 'package:frontend/features/responses/domain/entities/response_history.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';

class ResponseDetailPage extends ConsumerWidget {
  final String formId;
  final String responseId;

  const ResponseDetailPage({
    super.key,
    required this.formId,
    required this.responseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseAsync = ref.watch(responseDetailProvider(formId, responseId));
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: authState.when(
        data: (user) => responseAsync.when(
          data: (response) =>
              _ResponseDetailView(formId: formId, response: response),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _ErrorSection(error: err.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ResponseDetailView extends ConsumerWidget {
  final String formId;
  final FormResponse response;

  const _ResponseDetailView({required this.formId, required this.response});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _TopBar(formId: formId, responseId: response.id),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: TabBar(
                  isScrollable: true,
                  labelColor: const Color(0xFF2563EB),
                  unselectedLabelColor: const Color(0xFF6B7280),
                  indicatorColor: const Color(0xFF2563EB),
                  indicatorWeight: 3,
                  labelStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'Response Answers'),
                    Tab(text: 'Action History'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _AnswersTab(formId: formId, response: response),
                _HistoryTab(formId: formId, responseId: response.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswersTab extends StatelessWidget {
  final String formId;
  final FormResponse response;

  const _AnswersTab({required this.formId, required this.response});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubmissionHeader(response: response),
              const SizedBox(height: 32),
              _AIInsightsSection(response: response),
              const SizedBox(height: 32),
              Text(
                'Submitted Data',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              _AnswersList(formId: formId, answers: response.answers),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String formId;
  final String responseId;
  const _TopBar({required this.formId, required this.responseId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: const Color(0xFF374151),
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'MahaSamgrah Setu / Form Responses / $responseId',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionHeader extends StatelessWidget {
  final FormResponse response;
  const _SubmissionHeader({required this.response});

  @override
  Widget build(BuildContext context) {
    final dateStr = response.submittedAt != null
        ? DateFormat('MMMM dd, yyyy • HH:mm:ss').format(response.submittedAt!)
        : 'Unknown Date';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submission Detail',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  response.id,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Received on $dateStr',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(status: response.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'completed':
        color = const Color(0xFF059669);
        bgColor = const Color(0xFFECFDF5);
        break;
      case 'pending':
        color = const Color(0xFFD97706);
        bgColor = const Color(0xFFFFFBEB);
        break;
      case 'rejected':
        color = const Color(0xFFDC2626);
        bgColor = const Color(0xFFFEF2F2);
        break;
      default:
        color = const Color(0xFF2563EB);
        bgColor = const Color(0xFFEFF6FF);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _AIInsightsSection extends ConsumerWidget {
  final FormResponse response;
  const _AIInsightsSection({required this.response});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiResults = response.aiResults;
    final sentiment = aiResults['sentiment'];
    final moderation = aiResults['moderation'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.wandMagicSparkles,
                color: Color(0xFF2563EB),
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                'AI Analysis Hub',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  await ref
                      .read(aIControllerProvider.notifier)
                      .analyzeResponse(response.formId, response.id);
                  ref.invalidate(
                    responseDetailProvider(response.formId, response.id),
                  );
                },
                icon: const Icon(Icons.psychology_outlined, size: 18),
                label: const Text('Run Analysis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF374151),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (sentiment != null || moderation != null)
            Row(
              children: [
                if (sentiment != null)
                  Expanded(
                    child: _InsightCard(
                      title: 'Sentiment',
                      value: sentiment['label'].toString().toUpperCase(),
                      subtitle:
                          'Confidence: ${(sentiment['score'] * 100).toStringAsFixed(1)}%',
                      icon: Icons.face_outlined,
                      color: _getSentimentColor(sentiment['label']),
                    ),
                  ),
                const SizedBox(width: 16),
                if (moderation != null)
                  Expanded(
                    child: _InsightCard(
                      title: 'Safety Check',
                      value: moderation['is_safe'] == true
                          ? 'PASSED'
                          : 'FLAGGED',
                      subtitle:
                          '${moderation['flags']?.length ?? 0} security issues',
                      icon: Icons.security_outlined,
                      color: moderation['is_safe'] == true
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
              ],
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No intelligence data synchronized for this transmission.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
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
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswersList extends ConsumerWidget {
  final String formId;
  final Map<String, dynamic> answers;

  const _AnswersList({required this.formId, required this.answers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAsync = ref.watch(formBuilderControllerProvider(formId));

    return formAsync.when(
      data: (formState) {
        final questions = formState.form.sections
            .expand((s) => s.questions)
            .toList();
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questions.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
            itemBuilder: (context, index) {
              final question = questions[index];
              final answer = answers[question.id] ?? '—';
              return _AnswerEntry(
                label: question.label.toString(),
                value: answer.toString(),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => _AnswersFallback(answers: answers),
    );
  }
}

class _AnswerEntry extends StatelessWidget {
  final String label;
  final String value;
  const _AnswerEntry({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswersFallback extends StatelessWidget {
  final Map<String, dynamic> answers;
  const _AnswersFallback({required this.answers});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: answers.entries
            .map(
              (e) => _AnswerEntry(
                label: 'Question ${e.key}',
                value: e.value.toString(),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  final String formId;
  final String responseId;
  const _HistoryTab({required this.formId, required this.responseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(responseHistoryProvider(formId, responseId));

    return historyAsync.when(
      data: (historyList) => historyList.isEmpty
          ? _EmptyHistory()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: historyList.asMap().entries.map((e) {
                      return _HistoryItem(
                        entry: e.value,
                        isLast: e.key == historyList.length - 1,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => _ErrorSection(error: err.toString()),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final ResponseHistory entry;
  final bool isLast;
  const _HistoryItem({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: const Color(0xFFE5E7EB)),
                ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          entry.changeType.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy • HH:mm',
                        ).format(entry.changedAt),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Modified by ${entry.changedBy}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 48, color: Color(0xFFD1D5DB)),
          const SizedBox(height: 16),
          Text(
            'No historical synchronization records found.',
            style: GoogleFonts.inter(color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  final String error;
  const _ErrorSection({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'System Synchronization Error: $error',
            style: GoogleFonts.inter(color: const Color(0xFF374151)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/shared/models/form_models.dart';

class LogicRuleDialog extends StatelessWidget {
  final FormQuestion question;
  final List<FormSection> sections;
  final Map<String, dynamic>? initialRule;
  final String locale;

  const LogicRuleDialog({
    super.key,
    required this.question,
    required this.sections,
    this.initialRule,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Logic Rules',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  'Logic rules configuration for: ${question.label}',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

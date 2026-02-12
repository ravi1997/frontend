import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/form_builder_controller.dart'; // Assuming this controller handles AI interactions

class AiAssistantDialog extends ConsumerStatefulWidget {
  final String formId; // Needed to interact with the form builder controller

  const AiAssistantDialog({super.key, required this.formId});

  @override
  ConsumerState<AiAssistantDialog> createState() => _AiAssistantDialogState();
}

class _AiAssistantDialogState extends ConsumerState<AiAssistantDialog> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.brandBlue),
          const SizedBox(width: 10),
          Text(
            'AI Assistant',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Describe the fields or sections you want to generate for your form:',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'e.g., "Generate fields for a customer feedback survey: name, rating, comments, contact info."',
                hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor: AppColors.fieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isGenerating)
              const Center(child: CircularProgressIndicator())
            else
              Text(
                'Example: "Create an event registration form with attendee name, email, number of tickets, and dietary restrictions."',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(color: AppColors.textGrey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isGenerating
              ? null
              : () async {
                  setState(() {
                    _isGenerating = true;
                  });
                  final prompt = _promptController.text;
                  if (prompt.isNotEmpty) {
                    await ref
                        .read(formBuilderControllerProvider(widget.formId).notifier)
                        .generateFieldsWithAI(prompt); // Assuming this method exists
                    if (context.mounted) {
                      Navigator.of(context).pop(); // Close dialog on completion
                    }
                  }
                  setState(() {
                    _isGenerating = false;
                  });
                },
          child: Text(
            'Generate',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

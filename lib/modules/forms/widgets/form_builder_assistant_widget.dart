import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormBuilderAssistantWidget extends ConsumerStatefulWidget {
  final String formId;
  final String projectId;

  const FormBuilderAssistantWidget({
    super.key,
    required this.formId,
    required this.projectId,
  });

  @override
  ConsumerState<FormBuilderAssistantWidget> createState() =>
      _FormBuilderAssistantWidgetState();
}

class _FormBuilderAssistantWidgetState
    extends ConsumerState<FormBuilderAssistantWidget> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

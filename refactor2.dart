import 'dart:io';

void main() {
  final file = File('lib/features/form_builder/presentation/pages/form_submit_page.dart');
  String content = file.readAsStringSync();

  final startIndex = content.indexOf('class _SubmitFieldWidgetState extends ConsumerState<_SubmitFieldWidget> {');
  if (startIndex == -1) return;

  String stateContent = content.substring(startIndex);

  stateContent = stateContent.replaceAll('q.isRequired', 'widget.isRequired');

  content = content.replaceRange(startIndex, content.length, stateContent);
  file.writeAsStringSync(content);
}
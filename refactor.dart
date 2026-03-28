import 'dart:io';

void main() {
  final file = File('lib/features/form_builder/presentation/pages/form_submit_page.dart');
  String content = file.readAsStringSync();

  final startIndex = content.indexOf('class _SubmitFieldWidgetState extends ConsumerState<_SubmitFieldWidget> {');
  if (startIndex == -1) return;

  String stateContent = content.substring(startIndex);

  stateContent = stateContent.replaceAll('formData[q.id]', 'formData[_fieldId]');
  stateContent = stateContent.replaceAll('{...s, q.id:', '{...s, _fieldId:');
  stateContent = stateContent.replaceAll('dynamicOptions[q.id]', 'dynamicOptions[_fieldId]');

  content = content.replaceRange(startIndex, content.length, stateContent);
  file.writeAsStringSync(content);
}
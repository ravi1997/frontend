// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/answer_value.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:expressions/expressions.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/services/form_logic_evaluator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class JsonUiEngine extends StatelessWidget {
  final Map<String, dynamic> schema;
  final Map<String, AnswerValue> answers;
  final Function(String key, AnswerValue value) onAnswerChanged;

  const JsonUiEngine({
    super.key,
    required this.schema,
    required this.answers,
    required this.onAnswerChanged,
  });

  FormQuestion _toFormQuestion(Map<String, dynamic> node) {
    return FormQuestion(
      id: node['id']?.toString() ?? '',
      label: node['label']?.toString() ?? '',
      fieldType: node['type']?.toString() ?? 'short_text',
      isHidden: node['isHidden'] as bool? ?? false,
      isRequired: node['isRequired'] as bool? ?? false,
      metadata: {
        'conditional_logic': node['conditionalLogic'] ?? node['conditional_logic'],
      },
    );
  }

  dynamic _evaluateExpression(String expression, Map<String, dynamic> flatData) {
    if (expression.isEmpty) return null;
    try {
      const evaluator = ExpressionEvaluator();
      final Map<String, dynamic> context = {};
      var processedExpr = expression;

      final matches = RegExp(r'\{([a-zA-Z0-9_-]+)\}').allMatches(expression);
      for (final m in matches) {
        final fullMatch = m.group(0)!;
        final fieldId = m.group(1)!;

        final varName = fieldId.replaceAll('-', '_');
        processedExpr = processedExpr.replaceAll(fullMatch, varName);

        var val = flatData[fieldId] ?? 0;
        if (val is String) {
          val = double.tryParse(val) ?? val;
        }
        context[varName] = val;
      }

      final parsedExpr = Expression.parse(processedExpr);
      return evaluator.eval(parsedExpr, context);
    } catch (e) {
      return null;
    }
  }

  Widget _buildWidget(BuildContext context, Map<String, dynamic> node) {
    final type = node['type']?.toString().toLowerCase() ?? 'container';
    final children = node['children'] as List? ?? const [];
    final id = node['id']?.toString() ?? '';

    // Convert to FormQuestion to evaluate dynamic visibility and validation
    final question = _toFormQuestion(node);
    final flatData = answers.map((key, val) => MapEntry(key, val.value));

    // 1. Dynamic Visibility Check
    final isVisible = FormLogicEvaluator.shouldShowQuestion(question, flatData);
    if (!isVisible && id.isNotEmpty) {
      return const SizedBox.shrink();
    }

    // 2. Dynamic Required Check
    final isRequired = FormLogicEvaluator.isQuestionRequired(question, flatData);
    // 3. Dynamic Validation Check
    final errorText = FormLogicEvaluator.validateQuestion(question, flatData);

    final displayLabel = question.label + (isRequired ? ' *' : '');

    switch (type) {
      case 'row':
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children
              .map((child) => Expanded(
                    child: _buildWidget(context, Map<String, dynamic>.from(child)),
                  ))
              .toList(),
        );

      case 'column':
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children
              .map((child) => _buildWidget(context, Map<String, dynamic>.from(child)))
              .toList(),
        );

      case 'text':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            node['text']?.toString() ?? '',
            style: TextStyle(
              fontSize: (node['fontSize'] as num?)?.toDouble() ?? 14.0,
              fontWeight: node['fontWeight'] == 'bold' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );

      case 'text_field':
      case 'short_text':
      case 'password':
      case 'number':
      case 'email':
      case 'phone_number':
      case 'mobile':
      case 'url':
      case 'website_url':
        final hint = node['placeholder']?.toString() ?? '';
        final isMultiline = type == 'paragraph';
        final isObscured = type == 'password';
        
        TextInputType keyboardType = TextInputType.text;
        if (type == 'number') {
          keyboardType = TextInputType.number;
        } else if (type == 'email') {
          keyboardType = TextInputType.emailAddress;
        } else if (type == 'phone_number' || type == 'mobile') {
          keyboardType = TextInputType.phone;
        } else if (type == 'url' || type == 'website_url') {
          keyboardType = TextInputType.url;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            key: ValueKey(answers[id]?.value),
            initialValue: answers[id]?.value?.toString() ?? '',
            maxLines: isMultiline ? 4 : 1,
            obscureText: isObscured,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: displayLabel,
              hintText: hint,
              errorText: errorText,
              border: const OutlineInputBorder(),
            ),
            onChanged: (val) {
              onAnswerChanged(
                id,
                AnswerValue(value: val, displayValue: val),
              );
            },
          ),
        );

      case 'dropdown':
      case 'select':
        final options = node['options'] as List? ?? [];
        final currentVal = answers[id]?.value?.toString();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownButtonFormField<String>(
            initialValue: options.map((o) => o.toString()).contains(currentVal) ? currentVal : null,
            decoration: InputDecoration(
              labelText: displayLabel,
              errorText: errorText,
              border: const OutlineInputBorder(),
            ),
            items: options.map((option) {
              final optStr = option.toString();
              return DropdownMenuItem<String>(
                value: optStr,
                child: Text(optStr),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                onAnswerChanged(
                  id,
                  AnswerValue(value: val, displayValue: val),
                );
              }
            },
          ),
        );

      case 'multiple_choice':
      case 'radio':
        final options = node['options'] as List? ?? [];
        final currentVal = answers[id]?.value?.toString();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (errorText != null)
                Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ...options.map((option) {
                final optStr = option.toString();
                final isSelected = currentVal == optStr;
                return InkWell(
                  onTap: () {
                    onAnswerChanged(
                      id,
                      AnswerValue(value: optStr, displayValue: optStr),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(optStr)),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );

      case 'checkboxes':
      case 'multi_checkbox':
        final options = node['options'] as List? ?? [];
        final List<String> currentVals = List<String>.from(answers[id]?.value as List? ?? []);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (errorText != null)
                Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ...options.map((option) {
                final optStr = option.toString();
                final isChecked = currentVals.contains(optStr);
                return CheckboxListTile(
                  title: Text(optStr),
                  value: isChecked,
                  onChanged: (val) {
                    final updated = List<String>.from(currentVals);
                    if (val == true) {
                      updated.add(optStr);
                    } else {
                      updated.remove(optStr);
                    }
                    onAnswerChanged(
                      id,
                      AnswerValue(value: updated, displayValue: updated.join(', ')),
                    );
                  },
                );
              }),
            ],
          ),
        );

      case 'number_stepper':
        final currentVal = (answers[id]?.value as num?)?.toInt() ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      onAnswerChanged(
                        id,
                        AnswerValue(value: currentVal - 1, displayValue: (currentVal - 1).toString()),
                      );
                    },
                  ),
                  Text('$currentVal', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      onAnswerChanged(
                        id,
                        AnswerValue(value: currentVal + 1, displayValue: (currentVal + 1).toString()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );

      case 'toggle':
      case 'switch':
      case 'checkbox':
      case 'boolean':
        final currentVal = answers[id]?.value as bool? ?? false;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SwitchListTile(
            title: Text(displayLabel),
            value: currentVal,
            onChanged: (val) {
              onAnswerChanged(
                id,
                AnswerValue(value: val, displayValue: val ? 'Yes' : 'No'),
              );
            },
          ),
        );

      case 'slider':
      case 'slider_input':
        final minVal = (node['min'] as num?)?.toDouble() ?? 0.0;
        final maxVal = (node['max'] as num?)?.toDouble() ?? 100.0;
        final divisions = (node['divisions'] as num?)?.toInt();
        final currentVal = (answers[id]?.value as num?)?.toDouble() ?? minVal;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$displayLabel: ${currentVal.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: currentVal.clamp(minVal, maxVal),
                min: minVal,
                max: maxVal,
                divisions: divisions,
                label: currentVal.toStringAsFixed(1),
                onChanged: (val) {
                  onAnswerChanged(
                    id,
                    AnswerValue(value: val, displayValue: val.toStringAsFixed(1)),
                  );
                },
              ),
            ],
          ),
        );

      case 'date':
      case 'date_picker':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            key: ValueKey(currentVal),
            initialValue: currentVal,
            readOnly: true,
            decoration: InputDecoration(
              labelText: displayLabel,
              errorText: errorText,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () async {
              final initialDate = DateTime.tryParse(currentVal) ?? DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1950),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                final formatted = DateFormat('yyyy-MM-dd').format(picked);
                onAnswerChanged(
                  id,
                  AnswerValue(value: formatted, displayValue: formatted),
                );
              }
            },
          ),
        );

      case 'time':
      case 'time_picker':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            key: ValueKey(currentVal),
            initialValue: currentVal,
            readOnly: true,
            decoration: InputDecoration(
              labelText: displayLabel,
              errorText: errorText,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.access_time),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null && context.mounted) {
                final formatted = picked.format(context);
                onAnswerChanged(
                  id,
                  AnswerValue(value: formatted, displayValue: formatted),
                );
              }
            },
          ),
        );

      case 'rating':
        final currentVal = (answers[id]?.value as num?)?.toInt() ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= currentVal ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      onAnswerChanged(
                        id,
                        AnswerValue(value: starIndex, displayValue: '$starIndex Stars'),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );

      case 'file_upload':
      case 'file':
      case 'file_picker':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        currentVal.isEmpty ? 'No file selected' : currentVal,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null && result.files.isNotEmpty) {
                        final filename = result.files.first.name;
                        onAnswerChanged(
                          id,
                          AnswerValue(value: filename, displayValue: filename),
                        );
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Select'),
                  ),
                ],
              ),
            ],
          ),
        );

      case 'location_picker':
      case 'map_location':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey(currentVal),
                      initialValue: currentVal,
                      decoration: InputDecoration(
                        hintText: 'Latitude, Longitude (e.g. 12.9716, 77.5946)',
                        errorText: errorText,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.location_on_outlined),
                      ),
                      onChanged: (val) {
                        onAnswerChanged(
                          id,
                          AnswerValue(value: val, displayValue: val),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: () {
                      const mockCoords = '12.9716, 77.5946';
                      onAnswerChanged(
                        id,
                        AnswerValue(value: mockCoords, displayValue: mockCoords),
                      );
                    },
                    icon: const Icon(Icons.gps_fixed),
                    tooltip: 'Fetch GPS Location',
                  )
                ],
              ),
            ],
          ),
        );

      case 'barcode_scanner':
      case 'qr_code_scan':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey(currentVal),
                      initialValue: currentVal,
                      decoration: InputDecoration(
                        hintText: 'Scanned code value',
                        errorText: errorText,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.qr_code_scanner),
                      ),
                      onChanged: (val) {
                        onAnswerChanged(
                          id,
                          AnswerValue(value: val, displayValue: val),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Scan Barcode / QR Code'),
                          content: SizedBox(
                            width: 300,
                            height: 300,
                            child: MobileScanner(
                              onDetect: (capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                if (barcodes.isNotEmpty) {
                                  final code = barcodes.first.rawValue ?? '';
                                  onAnswerChanged(
                                    id,
                                    AnswerValue(value: code, displayValue: code),
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: 'Scan using Camera',
                  )
                ],
              ),
            ],
          ),
        );

      case 'calculated_field':
      case 'calculate':
        final expression = node['expression']?.toString() ?? node['formula']?.toString() ?? '';
        final calculatedVal = _evaluateExpression(expression, flatData) ?? 0;

        final currentVal = answers[id]?.value;
        if (currentVal != calculatedVal) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onAnswerChanged(
              id,
              AnswerValue(value: calculatedVal, displayValue: calculatedVal.toString()),
            );
          });
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  calculatedVal.toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );

      case 'color_picker':
        final currentVal = answers[id]?.value?.toString() ?? '#000000';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _parseColor(currentVal),
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: currentVal,
                      decoration: InputDecoration(
                        hintText: '#RRGGBB',
                        errorText: errorText,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        if (_isValidColor(val)) {
                          onAnswerChanged(
                            id,
                            AnswerValue(value: val, displayValue: val),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 'datetime_picker':
      case 'datetime':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            key: ValueKey(currentVal),
            initialValue: currentVal,
            readOnly: true,
            decoration: InputDecoration(
              labelText: displayLabel,
              errorText: errorText,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.event),
            ),
            onTap: () async {
              final initialDate = DateTime.tryParse(currentVal) ?? DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1950),
                lastDate: DateTime(2100),
              );
              if (picked != null && context.mounted) {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(initialDate),
                );
                if (pickedTime != null) {
                  final finalDateTime = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  final formatted = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
                  onAnswerChanged(
                    id,
                    AnswerValue(value: formatted, displayValue: formatted),
                  );
                }
              }
            },
          ),
        );

      case 'date_range_picker':
      case 'date_range':
        final currentVal = answers[id]?.value as List? ?? [];
        final List<String> range = List<String>.from(currentVal);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'From',
                        hintText: range.isNotEmpty ? range[0] : 'Start date',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          final formatted = DateFormat('yyyy-MM-dd').format(picked);
                          final updatedRange = range.isNotEmpty ? [formatted, range[1]] : [formatted, ''];
                          onAnswerChanged(
                            id,
                            AnswerValue(value: updatedRange, displayValue: updatedRange.join(' to ')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'To',
                        hintText: range.length > 1 ? range[1] : 'End date',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          final formatted = DateFormat('yyyy-MM-dd').format(picked);
                          final updatedRange = range.isNotEmpty ? [range[0], formatted] : ['', formatted];
                          onAnswerChanged(
                            id,
                            AnswerValue(value: updatedRange, displayValue: updatedRange.join(' to ')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 'image_capture':
      case 'image_picker':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (currentVal.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.network(currentVal, fit: BoxFit.cover),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          // In a real app, you would upload this to a server
                          // For now, we'll just store the path
                          onAnswerChanged(
                            id,
                            AnswerValue(value: image.path, displayValue: image.name),
                          );
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          onAnswerChanged(
                            id,
                            AnswerValue(value: image.path, displayValue: image.name),
                          );
                        }
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 'signature':
      case 'signature_pad':
        final SignatureController controller = SignatureController(
          penStrokeWidth: 2,
          penColor: Colors.black,
          exportBackgroundColor: Colors.white,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Signature(
                  controller: controller,
                  height: 150,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clear();
                      },
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final signature = await controller.toPngBytes();
                        if (signature != null) {
                          // In a real app, you would upload this to a server
                          // For now, we'll store a placeholder
                          onAnswerChanged(
                            id,
                            AnswerValue(value: 'signature_${DateTime.now().millisecondsSinceEpoch}.png', displayValue: 'Signature captured'),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 'audio_record':
      case 'voice_recorder':
        final currentVal = answers[id]?.value?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (currentVal.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.audio_file),
                      const SizedBox(width: 8),
                      Expanded(child: Text(currentVal)),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // In a real app, you would implement audio recording
                      // For now, we'll store a placeholder
                      onAnswerChanged(
                        id,
                        AnswerValue(value: 'audio_${DateTime.now().millisecondsSinceEpoch}.mp3', displayValue: 'Audio recorded'),
                      );
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text('Record'),
                  ),
                  const SizedBox(width: 8),
                  if (currentVal.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Play audio - placeholder implementation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Audio playback would start here')),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                    ),
                ],
              ),
            ],
          ),
        );

      case 'heading':
      case 'title':
        final level = (node['level'] as num?)?.toInt() ?? 1;
        final fontSize = 24.0 - (level - 1) * 4.0;
        final fontWeight = level == 1 ? FontWeight.bold : FontWeight.w600;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            node['text']?.toString() ?? displayLabel,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        );

      case 'paragraph':
      case 'description':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            node['text']?.toString() ?? '',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey.shade700,
            ),
          ),
        );

      case 'divider':
      case 'separator':
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        );

      case 'image_display':
      case 'image':
        final imageUrl = node['url']?.toString() ?? node['src']?.toString() ?? '';
        if (imageUrl.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();

      case 'video_display':
      case 'video':
        final videoUrl = node['url']?.toString() ?? node['src']?.toString() ?? '';
        if (videoUrl.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.shade200,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_outline, size: 48),
                    SizedBox(height: 8),
                    Text('Video Player'),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();

      case 'button_group':
      case 'segmented_button':
        final options = node['options'] as List? ?? [];
        final currentVal = answers[id]?.value?.toString();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: options.map((option) {
                  final optStr = option.toString();
                  final isSelected = currentVal == optStr;
                  return ChoiceChip(
                    label: Text(optStr),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        onAnswerChanged(
                          id,
                          AnswerValue(value: optStr, displayValue: optStr),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );

      default:
        return Container(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children
                .map((child) => _buildWidget(context, Map<String, dynamic>.from(child)))
                .toList(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context, schema);
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.black;
    }
  }

  bool _isValidColor(String colorString) {
    final colorRegex = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
    return colorRegex.hasMatch(colorString);
  }
}

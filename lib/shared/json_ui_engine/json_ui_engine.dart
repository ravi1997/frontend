import 'package:flutter/material.dart';
import '../models/answer_value.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:expressions/expressions.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/services/form_logic_evaluator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

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
      case 'paragraph':
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
            value: options.map((o) => o.toString()).contains(currentVal) ? currentVal : null,
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
                return RadioListTile<String>(
                  title: Text(optStr),
                  value: optStr,
                  groupValue: currentVal,
                  onChanged: (val) {
                    if (val != null) {
                      onAnswerChanged(
                        id,
                        AnswerValue(value: val, displayValue: val),
                      );
                    }
                  },
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
}

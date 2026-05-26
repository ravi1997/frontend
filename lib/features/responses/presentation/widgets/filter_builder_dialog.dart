import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../form_builder/domain/entities/form_question.dart';
import '../../../form_builder/domain/entities/question_type.dart';

// ─────────────────────────────────────────────
// Internal model for a single filter rule
// ─────────────────────────────────────────────

/// The simplified field type used by the filter engine.
enum _FilterFieldType { string, number, date, boolean }

class _FilterField {
  final String id;
  final String label;
  final _FilterFieldType fieldType;
  final bool isMeta;

  const _FilterField({
    required this.id,
    required this.label,
    required this.fieldType,
    this.isMeta = false,
  });
}

class _FilterRule {
  _FilterField? field;
  String? operator;
  dynamic value; // String | List<String> (for between) | bool
  dynamic value2; // second value for "between"

  _FilterRule({this.field, this.operator, this.value, this.value2});
}

// ─────────────────────────────────────────────
// Operator definitions per field type
// ─────────────────────────────────────────────
const _stringOperators = [
  ('equals', 'Equals'),
  ('not_equals', 'Not equals'),
  ('contains', 'Contains'),
  ('starts_with', 'Starts with'),
  ('ends_with', 'Ends with'),
  ('is_empty', 'Is empty'),
  ('is_not_empty', 'Is not empty'),
];

const _numberOperators = [
  ('equals', 'Equals'),
  ('greater_than', 'Greater than'),
  ('less_than', 'Less than'),
  ('between', 'Between'),
];

const _dateOperators = [
  ('before', 'Before'),
  ('after', 'After'),
  ('between', 'Between'),
];

const _boolOperators = [
  ('is_true', 'Is true'),
  ('is_false', 'Is false'),
];

List<(String, String)> _operatorsFor(_FilterFieldType t) {
  switch (t) {
    case _FilterFieldType.string:
      return _stringOperators;
    case _FilterFieldType.number:
      return _numberOperators;
    case _FilterFieldType.date:
      return _dateOperators;
    case _FilterFieldType.boolean:
      return _boolOperators;
  }
}

bool _requiresNoValue(String op) =>
    op == 'is_empty' || op == 'is_not_empty' || op == 'is_true' || op == 'is_false';

bool _isBetween(String op) => op == 'between';

// ─────────────────────────────────────────────
// Helper – map QuestionType → _FilterFieldType
// ─────────────────────────────────────────────
_FilterFieldType _mapQuestionType(QuestionType qt) {
  switch (qt) {
    case QuestionType.number:
    case QuestionType.slider:
    case QuestionType.rating:
    case QuestionType.stepper:
    case QuestionType.price:
    case QuestionType.age:
    case QuestionType.range:
    case QuestionType.calculate:
    case QuestionType.calculated:
      return _FilterFieldType.number;
    case QuestionType.date:
    case QuestionType.dateRange:
      return _FilterFieldType.date;
    case QuestionType.booleanValue:
    case QuestionType.toggle:
      return _FilterFieldType.boolean;
    default:
      return _FilterFieldType.string;
  }
}

// ─────────────────────────────────────────────
// Public dialog
// ─────────────────────────────────────────────

/// Returns `List<Map<String, dynamic>>` matching the backend filter format,
/// or `null` if cancelled.
Future<List<Map<String, dynamic>>?> showFilterBuilderDialog({
  required BuildContext context,
  required List<FormQuestion> questions,
  List<Map<String, dynamic>>? initialFilters,
}) {
  return showDialog<List<Map<String, dynamic>>>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (_) => FilterBuilderDialog(
      questions: questions,
      initialFilters: initialFilters,
    ),
  );
}

class FilterBuilderDialog extends StatefulWidget {
  final List<FormQuestion> questions;
  final List<Map<String, dynamic>>? initialFilters;

  const FilterBuilderDialog({
    super.key,
    required this.questions,
    this.initialFilters,
  });

  @override
  State<FilterBuilderDialog> createState() => _FilterBuilderDialogState();
}

class _FilterBuilderDialogState extends State<FilterBuilderDialog>
    with TickerProviderStateMixin {
  static const _accent = Color(0xFF6366F1);
  static const _accentLight = Color(0xFFEEF2FF);
  static const _cardBg = Color(0xFF1E1B4B);
  static const _dialogBg = Color(0xFF0F0C29);
  static const _borderColor = Color(0xFF3730A3);

  late List<_FilterField> _availableFields;
  final List<_FilterRule> _rules = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _dialogFadeCtrl;
  late Animation<double> _dialogFade;

  @override
  void initState() {
    super.initState();

    // Build available fields list
    _availableFields = [
      // Meta field: submission date
      const _FilterField(
        id: 'submitted_at',
        label: 'Submission Date',
        fieldType: _FilterFieldType.date,
        isMeta: true,
      ),
      // Fields from form questions
      ...widget.questions
          .where((q) =>
              q.label != null &&
              q.label.toString().isNotEmpty &&
              q.type != QuestionType.divider &&
              q.type != QuestionType.spacer &&
              q.type != QuestionType.signature &&
              q.type != QuestionType.fileUpload &&
              q.type != QuestionType.multiFileUpload &&
              q.type != QuestionType.filePicker &&
              q.type != QuestionType.image &&
              q.type != QuestionType.imageGallery)
          .map((q) => _FilterField(
                id: q.id,
                label: q.label.toString(),
                fieldType: _mapQuestionType(q.type),
              )),
    ];

    // Dialog fade-in
    _dialogFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _dialogFade = CurvedAnimation(
      parent: _dialogFadeCtrl,
      curve: Curves.easeOut,
    );
    _dialogFadeCtrl.forward();

    // Restore initial filters if provided
    if (widget.initialFilters != null && widget.initialFilters!.isNotEmpty) {
      for (final f in widget.initialFilters!) {
        final fieldId = f['field'] as String?;
        final op = f['operator'] as String?;
        final val = f['value'];
        final field = _availableFields.where((af) => af.id == fieldId).firstOrNull;
        if (field != null) {
          _rules.add(_FilterRule(
            field: field,
            operator: op,
            value: _isBetween(op ?? '') && val is List ? val[0] : val,
            value2: _isBetween(op ?? '') && val is List ? val[1] : null,
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    _dialogFadeCtrl.dispose();
    super.dispose();
  }

  void _addRule() {
    final rule = _FilterRule();
    _rules.add(rule);
    _listKey.currentState?.insertItem(_rules.length - 1,
        duration: const Duration(milliseconds: 320));
  }

  void _removeRule(int index) {
    final rule = _rules.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedRow(rule, index, animation),
      duration: const Duration(milliseconds: 260),
    );
  }

  void _applyFilters() {
    final filters = <Map<String, dynamic>>[];
    for (final rule in _rules) {
      if (rule.field == null || rule.operator == null) continue;
      final op = rule.operator!;
      final field = rule.field!;

      dynamic value;
      if (_requiresNoValue(op)) {
        value = null;
      } else if (_isBetween(op)) {
        value = [rule.value?.toString() ?? '', rule.value2?.toString() ?? ''];
      } else {
        if (field.fieldType == _FilterFieldType.boolean) {
          value = rule.value ?? false;
        } else {
          value = rule.value?.toString() ?? '';
        }
      }

      filters.add({
        'field': field.id,
        'operator': op,
        if (value != null) 'value': value,
        'field_type': field.fieldType.name,
        if (field.isMeta) 'is_meta': true,
      });
    }
    Navigator.of(context).pop(filters);
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final dialogW = screenW > 800 ? 720.0 : screenW * 0.95;

    return FadeTransition(
      opacity: _dialogFade,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Container(
          width: dialogW,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: _dialogBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.25),
                blurRadius: 48,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const Divider(height: 1, color: _borderColor),
                Flexible(
                  child: _rules.isEmpty
                      ? _buildEmptyState()
                      : AnimatedList(
                          key: _listKey,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          initialItemCount: _rules.length,
                          itemBuilder: (context, index, animation) {
                            return _buildAnimatedRow(
                                _rules[index], index, animation);
                          },
                        ),
                ),
                const Divider(height: 1, color: _borderColor),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accent.withValues(alpha: 0.18),
            _cardBg.withValues(alpha: 0.0),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.filter_list_rounded,
                color: _accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Advanced Filters',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Build compound filter rules for your responses',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white54),
            onPressed: () => Navigator.of(context).pop(null),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.filter_alt_outlined,
                color: _accent, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'No filter rules yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Click "Add Rule" below to start filtering.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedRow(
      _FilterRule rule, int index, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: _FilterRuleRow(
          key: ObjectKey(rule),
          rule: rule,
          index: index,
          availableFields: _availableFields,
          onRemove: () => _removeRule(index),
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Row(
        children: [
          // Add Rule
          OutlinedButton.icon(
            onPressed: _addRule,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              'Add Rule',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _accent,
              side: const BorderSide(color: _accent, width: 1.2),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const Spacer(),
          // Clear All
          if (_rules.isNotEmpty)
            TextButton(
              onPressed: () {
                final count = _rules.length;
                for (int i = count - 1; i >= 0; i--) {
                  final rule = _rules.removeAt(i);
                  _listKey.currentState?.removeItem(
                    i,
                    (context, animation) =>
                        _buildAnimatedRow(rule, i, animation),
                    duration: const Duration(milliseconds: 200),
                  );
                }
                setState(() {});
              },
              child: Text(
                'Clear All',
                style: GoogleFonts.inter(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(width: 8),
          // Apply Filters
          ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Apply Filters',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Individual rule row widget
// ─────────────────────────────────────────────

class _FilterRuleRow extends StatefulWidget {
  final _FilterRule rule;
  final int index;
  final List<_FilterField> availableFields;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _FilterRuleRow({
    super.key,
    required this.rule,
    required this.index,
    required this.availableFields,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_FilterRuleRow> createState() => _FilterRuleRowState();
}

class _FilterRuleRowState extends State<_FilterRuleRow> {
  static const _accent = Color(0xFF6366F1);
  static const _cardBg = Color(0xFF1A1744);
  static const _borderColor = Color(0xFF312E81);
  static const _inputFill = Color(0xFF0F0C29);

  late TextEditingController _valueCtrl;
  late TextEditingController _value2Ctrl;

  @override
  void initState() {
    super.initState();
    _valueCtrl = TextEditingController(
        text: widget.rule.value?.toString() ?? '');
    _value2Ctrl = TextEditingController(
        text: widget.rule.value2?.toString() ?? '');
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    _value2Ctrl.dispose();
    super.dispose();
  }

  List<(String, String)> get _operators {
    final field = widget.rule.field;
    if (field == null) return [];
    return _operatorsFor(field.fieldType);
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        color: Colors.white24,
        fontSize: 13,
      ),
      filled: true,
      fillColor: _inputFill,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _accent, width: 1.5),
      ),
    );
  }

  DropdownButtonFormField<T> _styledDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      dropdownColor: const Color(0xFF1A1744),
      iconEnabledColor: Colors.white38,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
      decoration: _inputDeco(hint),
      hint: Text(
        hint,
        style: GoogleFonts.inter(color: Colors.white24, fontSize: 13),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildValueInput() {
    final rule = widget.rule;
    final field = rule.field;
    final op = rule.operator;
    if (field == null || op == null) return const SizedBox.shrink();
    if (_requiresNoValue(op)) return const SizedBox.shrink();

    switch (field.fieldType) {
      case _FilterFieldType.boolean:
        return SwitchListTile(
          title: Text(
            rule.value == true ? 'True' : 'False',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
          value: rule.value as bool? ?? false,
          activeColor: _accent,
          contentPadding: EdgeInsets.zero,
          onChanged: (v) {
            rule.value = v;
            widget.onChanged();
          },
        );

      case _FilterFieldType.date:
        if (_isBetween(op)) {
          return Row(
            children: [
              Expanded(
                child: _DatePickerInput(
                  label: 'From date',
                  value: rule.value?.toString(),
                  accent: _accent,
                  inputFill: _inputFill,
                  borderColor: _borderColor,
                  onChanged: (d) {
                    rule.value = d;
                    widget.onChanged();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DatePickerInput(
                  label: 'To date',
                  value: rule.value2?.toString(),
                  accent: _accent,
                  inputFill: _inputFill,
                  borderColor: _borderColor,
                  onChanged: (d) {
                    rule.value2 = d;
                    widget.onChanged();
                  },
                ),
              ),
            ],
          );
        }
        return _DatePickerInput(
          label: 'Select date',
          value: rule.value?.toString(),
          accent: _accent,
          inputFill: _inputFill,
          borderColor: _borderColor,
          onChanged: (d) {
            rule.value = d;
            widget.onChanged();
          },
        );

      case _FilterFieldType.number:
        if (_isBetween(op)) {
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _valueCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 13),
                  decoration: _inputDeco('Min value'),
                  onChanged: (v) {
                    rule.value = v;
                    widget.onChanged();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _value2Ctrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 13),
                  decoration: _inputDeco('Max value'),
                  onChanged: (v) {
                    rule.value2 = v;
                    widget.onChanged();
                  },
                ),
              ),
            ],
          );
        }
        return TextField(
          controller: _valueCtrl,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: _inputDeco('Enter value'),
          onChanged: (v) {
            rule.value = v;
            widget.onChanged();
          },
        );

      case _FilterFieldType.string:
      default:
        return TextField(
          controller: _valueCtrl,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: _inputDeco('Enter value'),
          onChanged: (v) {
            rule.value = v;
            widget.onChanged();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rule = widget.rule;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rule header with index badge + remove button
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.index + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _accent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Filter Rule',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Field selector
          _styledDropdown<_FilterField>(
            value: rule.field,
            hint: 'Select field',
            items: widget.availableFields.map((f) {
              return DropdownMenuItem<_FilterField>(
                value: f,
                child: Row(
                  children: [
                    _fieldTypeIcon(f.fieldType, isMeta: f.isMeta),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f.label,
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (f) {
              setState(() {
                rule.field = f;
                rule.operator = null;
                rule.value = null;
                rule.value2 = null;
                _valueCtrl.clear();
                _value2Ctrl.clear();
              });
              widget.onChanged();
            },
          ),
          if (rule.field != null) ...[
            const SizedBox(height: 10),
            // Operator selector
            _styledDropdown<String>(
              value: rule.operator,
              hint: 'Select operator',
              items: _operators.map((op) {
                return DropdownMenuItem<String>(
                  value: op.$1,
                  child: Text(
                    op.$2,
                    style: GoogleFonts.inter(
                        color: Colors.white, fontSize: 13),
                  ),
                );
              }).toList(),
              onChanged: (op) {
                setState(() {
                  rule.operator = op;
                  rule.value = null;
                  rule.value2 = null;
                  _valueCtrl.clear();
                  _value2Ctrl.clear();
                });
                widget.onChanged();
              },
            ),
            if (rule.operator != null && !_requiresNoValue(rule.operator!)) ...[
              const SizedBox(height: 10),
              _buildValueInput(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _fieldTypeIcon(_FilterFieldType ft, {bool isMeta = false}) {
    if (isMeta) {
      return const Icon(Icons.schedule_rounded, size: 14, color: _accent);
    }
    switch (ft) {
      case _FilterFieldType.number:
        return const Icon(Icons.tag_rounded, size: 14, color: Color(0xFF10B981));
      case _FilterFieldType.date:
        return const Icon(Icons.calendar_today_rounded,
            size: 14, color: Color(0xFFF59E0B));
      case _FilterFieldType.boolean:
        return const Icon(Icons.toggle_on_rounded,
            size: 14, color: Color(0xFF8B5CF6));
      case _FilterFieldType.string:
      default:
        return const Icon(Icons.text_fields_rounded,
            size: 14, color: Color(0xFF60A5FA));
    }
  }
}

// ─────────────────────────────────────────────
// Date picker input widget
// ─────────────────────────────────────────────
class _DatePickerInput extends StatelessWidget {
  final String label;
  final String? value;
  final Color accent;
  final Color inputFill;
  final Color borderColor;
  final void Function(String?) onChanged;

  const _DatePickerInput({
    required this.label,
    required this.value,
    required this.accent,
    required this.inputFill,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final initial = value != null
            ? DateTime.tryParse(value!) ?? now
            : now;
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: accent,
                  onPrimary: Colors.white,
                  surface: const Color(0xFF1A1744),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onChanged(DateFormat('yyyy-MM-dd').format(picked));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: inputFill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 14, color: accent.withValues(alpha: 0.7)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value ?? label,
                style: GoogleFonts.inter(
                  color: value != null ? Colors.white : Colors.white24,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

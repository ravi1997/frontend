import 'dart:convert';

class QuickResponseApplyResult {
  final Map<String, dynamic> mergedValues;
  final List<String> conflictingFields;

  const QuickResponseApplyResult({
    required this.mergedValues,
    required this.conflictingFields,
  });

  bool get hasConflicts => conflictingFields.isNotEmpty;
}

String _valueKey(dynamic value) {
  if (value == null) return '__null__';
  try {
    return jsonEncode(value);
  } catch (_) {
    return value.toString();
  }
}

bool _isBlank(dynamic value) {
  if (value == null) return true;
  if (value is String) return value.trim().isEmpty;
  if (value is Iterable) return value.isEmpty;
  if (value is Map) return value.isEmpty;
  return false;
}

Map<String, dynamic> _fieldValues(Map<String, dynamic> response) {
  final raw = response['field_values'] ?? response['fieldValues'] ?? const {};
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return const {};
}

QuickResponseApplyResult mergeQuickResponses({
  required List<Map<String, dynamic>> quickResponses,
  required Map<String, dynamic> currentValues,
}) {
  final groupedValues = <String, Set<String>>{};
  final representativeValue = <String, dynamic>{};

  for (final response in quickResponses) {
    for (final entry in _fieldValues(response).entries) {
      final key = entry.key.toString().trim();
      if (key.isEmpty || _isBlank(entry.value)) continue;
      groupedValues.putIfAbsent(key, () => <String>{}).add(_valueKey(entry.value));
      representativeValue.putIfAbsent(key, () => entry.value);
    }
  }

  final conflicts = <String>[];
  final merged = Map<String, dynamic>.from(currentValues);

  for (final entry in groupedValues.entries) {
    final key = entry.key;
    if (entry.value.length > 1) {
      conflicts.add(key);
      continue;
    }
    if (_isBlank(merged[key])) {
      merged[key] = representativeValue[key];
    }
  }

  conflicts.sort();
  return QuickResponseApplyResult(
    mergedValues: merged,
    conflictingFields: conflicts,
  );
}

class ResponseMapper {
  /// Transforms flat answers into a nested structure for repeatable sections
  /// and prunes hidden fields based on the visibility map.
  static Map<String, dynamic> toBackendPayload(
    Map<String, dynamic> flatAnswers,
    Map<String, bool> visibilityMap, {
    Map<String, int>? repeatInstances,
  }) {
    final Map<String, dynamic> nested = {};

    flatAnswers.forEach((key, value) {
      // 1. Skip if value is null (optional fields)
      if (value == null) return;

      // 2. Determine if it's a repeatable section field: sectionId[index].fieldId
      if (key.contains('[') && key.contains('].')) {
        final parts = key.split('[');
        final sectionId = parts[0];

        // Skip if the entire section is hidden
        if (visibilityMap[sectionId] == false) return;

        final rest = parts[1].split('].');
        final index = int.parse(rest[0]);
        final fieldId = rest[1];

        // Prune deleted repeat instances
        if (repeatInstances != null) {
          final maxInstances = repeatInstances[sectionId] ?? 1;
          if (index >= maxInstances) {
            return; // Discard data for removed instances
          }
        }

        // Skip if the specific field is hidden
        // Note: Logic engine currently uses fieldId for visibility,
        // regardless of which repeat instance it is in.
        if (visibilityMap[fieldId] == false) return;

        if (!nested.containsKey(sectionId)) {
          nested[sectionId] = <Map<String, dynamic>>[];
        }

        final list = nested[sectionId] as List<Map<String, dynamic>>;
        while (list.length <= index) {
          list.add(<String, dynamic>{});
        }
        if (fieldId.contains('[') && fieldId.endsWith(']')) {
          final questionParts = fieldId.split('[');
          final questionId = questionParts[0];
          final questionIndex = int.tryParse(
            questionParts[1].replaceAll(']', ''),
          );
          if (questionIndex == null) return;

          if (visibilityMap[questionId] == false) {
            return;
          }
          if (!list[index].containsKey(questionId)) {
            list[index][questionId] = <dynamic>[];
          }

          final repeatedValues = list[index][questionId] as List<dynamic>;
          while (repeatedValues.length <= questionIndex) {
            repeatedValues.add(null);
          }
          repeatedValues[questionIndex] = value;
        } else {
          list[index][fieldId] = value;
        }
      } else if (key.contains('[') && key.endsWith(']')) {
        final parts = key.split('[');
        final fieldId = parts[0];
        final index = int.tryParse(parts[1].replaceAll(']', ''));
        if (index == null) return;

        if (visibilityMap[fieldId] == false) return;

        if (repeatInstances != null) {
          final maxInstances = repeatInstances[fieldId] ?? 1;
          if (index >= maxInstances) return;
        }

        if (!nested.containsKey(fieldId)) {
          nested[fieldId] = <dynamic>[];
        }

        final list = nested[fieldId] as List<dynamic>;
        while (list.length <= index) {
          list.add(null);
        }
        list[index] = value;
      } else {
        // 3. Regular field
        // Skip if hidden
        if (visibilityMap[key] == false) return;

        nested[key] = value;
      }
    });

    // Cleanup empty repeat instances (if any) or empty sections
    final result = <String, dynamic>{};
    nested.forEach((key, value) {
      if (value is List) {
        // Only keep if the list has data
        final nonEmptyInstances = value
            .where((inst) => inst.isNotEmpty)
            .toList();
        if (nonEmptyInstances.isNotEmpty) {
          result[key] = nonEmptyInstances;
        }
      } else {
        result[key] = value;
      }
    });

    return result;
  }
}

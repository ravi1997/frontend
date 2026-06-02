class ResponseMapper {
  static Map<String, dynamic> toBackendPayload(
    Map<String, dynamic> response,
    Map<String, bool> visibilityMap, {
    Map<String, int>? repeatInstances,
  }) {
    final pruned = _pruneVisibleValues(response, visibilityMap);
    return toApiJson(pruned);
  }

  static Map<String, dynamic> toApiJson(Map<String, dynamic> response) {
    return {
      'id': response['id'],
      'form_id': response['form_id'],
      'project_id': response['project_id'],
      'user_id': response['user_id'],
      'responses': response['responses'],
      'submitted_at': response['submitted_at'],
      'status': response['status'] ?? 'submitted',
      'metadata': response['metadata'] ?? {},
    };
  }

  static Map<String, dynamic> fromApiJson(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'form_id': json['form_id'],
      'project_id': json['project_id'],
      'user_id': json['user_id'],
      'responses': json['responses'] ?? {},
      'submitted_at': json['submitted_at'],
      'status': json['status'] ?? 'submitted',
      'metadata': json['metadata'] ?? {},
    };
  }

  static Map<String, dynamic> _pruneVisibleValues(
    Map<String, dynamic> response,
    Map<String, bool> visibilityMap,
  ) {
    final pruned = <String, dynamic>{};

    for (final entry in response.entries) {
      final key = entry.key;
      final value = entry.value;

      if (visibilityMap.containsKey(key) && visibilityMap[key] == false) {
        continue;
      }

      if (value is Map<String, dynamic>) {
        pruned[key] = _pruneVisibleValues(value, visibilityMap);
        continue;
      }

      if (value is List) {
        pruned[key] = value.map((item) {
          if (item is Map<String, dynamic>) {
            return _pruneVisibleValues(item, visibilityMap);
          }
          if (item is Map) {
            return _pruneVisibleValues(Map<String, dynamic>.from(item), visibilityMap);
          }
          return item;
        }).toList();
        continue;
      }

      pruned[key] = value;
    }

    return pruned;
  }
}

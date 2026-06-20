import 'package:flutter_riverpod/legacy.dart';

class FilterStateNotifier extends StateNotifier<Map<String, dynamic>> {
  FilterStateNotifier() : super({});

  void setFilter(String filterWidgetId, dynamic value) {
    state = {
      ...state,
      filterWidgetId: value,
    };
  }

  void clearFilter(String filterWidgetId) {
    final newState = Map<String, dynamic>.from(state);
    newState.remove(filterWidgetId);
    state = newState;
  }

  void clearAll() {
    state = {};
  }
}

final filterStateProvider = StateNotifierProvider<FilterStateNotifier, Map<String, dynamic>>((ref) {
  return FilterStateNotifier();
});

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/custom_field_template.dart';

final customFieldsProvider = Provider<CustomFieldsController>(
  (ref) => CustomFieldsController(),
);

class CustomFieldsController extends ChangeNotifier {
  List<CustomFieldTemplate> _state = [];

  List<CustomFieldTemplate> get state => _state;

  void addField(CustomFieldTemplate field) {
    _state = [..._state, field];
    notifyListeners();
  }

  void removeField(String fieldId) {
    _state = _state.where((field) => field.id != fieldId).toList();
    notifyListeners();
  }

  void updateField(CustomFieldTemplate updatedField) {
    _state = _state
        .map((field) => field.id == updatedField.id ? updatedField : field)
        .toList();
    notifyListeners();
  }

  void saveAsTemplate(String name, String category, FormQuestion question) {
    addField(
      CustomFieldTemplate(
        id: question.id,
        name: name,
        category: category,
        data: question.toJson(),
      ),
    );
  }
}

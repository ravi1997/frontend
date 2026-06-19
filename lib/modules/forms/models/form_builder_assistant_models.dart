"""
lib/modules/forms/models/form_builder_assistant_models.dart
Models for the Form Builder Assistant.
"""

import 'package:json_annotation/json_annotation.dart';

part 'form_builder_assistant_models.g.dart';

@JsonSerializable()
class FormBuilderAssistantMessage {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final List<FormBuilderAssistantAction> actions;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  FormBuilderAssistantMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.actions,
    this.metadata,
    required this.createdAt,
  });

  factory FormBuilderAssistantMessage.fromJson(Map<String, dynamic> json) =>
      _$FormBuilderAssistantMessageFromJson(json);
  Map<String, dynamic> toJson() => _$FormBuilderAssistantMessageToJson(this);
}

@JsonSerializable()
class FormBuilderAssistantAction {
  final String id;
  final String type;
  final String label;
  final Map<String, dynamic> parameters;
  final String? description;

  FormBuilderAssistantAction({
    required this.id,
    required this.type,
    required this.label,
    required this.parameters,
    this.description,
  });

  factory FormBuilderAssistantAction.fromJson(Map<String, dynamic> json) =>
      _$FormBuilderAssistantActionFromJson(json);
  Map<String, dynamic> toJson() => _$FormBuilderAssistantActionToJson(this);
}

@JsonSerializable()
class FormBuilderAssistantSession {
  final String id;
  final String formId;
  final String userId;
  final List<FormBuilderAssistantMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  FormBuilderAssistantSession({
    required this.id,
    required this.formId,
    required this.userId,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory FormBuilderAssistantSession.fromJson(Map<String, dynamic> json) =>
      _$FormBuilderAssistantSessionFromJson(json);
  Map<String, dynamic> toJson() => _$FormBuilderAssistantSessionToJson(this);
}

@JsonSerializable()
class FormBuilderAssistantState {
  final String sessionId;
  final List<FormBuilderAssistantMessage> messages;
  final bool isProcessing;
  final String? error;
  final Map<String, dynamic>? context;

  FormBuilderAssistantState({
    required this.sessionId,
    required this.messages,
    required this.isProcessing,
    this.error,
    this.context,
  });

  factory FormBuilderAssistantState.fromJson(Map<String, dynamic> json) =>
      _$FormBuilderAssistantStateFromJson(json);
  Map<String, dynamic> toJson() => _$FormBuilderAssistantStateToJson(this);
}

// Action types
class FormBuilderAssistantActionTypes {
  static const String addField = 'add_field';
  static const String modifyField = 'modify_field';
  static const String removeField = 'remove_field';
  static const String addSection = 'add_section';
  static const String modifySection = 'modify_section';
  static const String removeSection = 'remove_section';
  static const String setTheme = 'set_theme';
  static const String configureLogic = 'configure_logic';
  static const String setValidation = 'set_validation';
  static const String arrangeLayout = 'arrange_layout';
  static const String addTranslation = 'add_translation';
  static const String setAccessibility = 'set_accessibility';
}
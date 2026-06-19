class FormBuilderAssistantMessage {
  final String id;
  final String role;
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

  factory FormBuilderAssistantMessage.fromJson(Map<String, dynamic> json) {
    return FormBuilderAssistantMessage(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'assistant',
      content: json['content']?.toString() ?? '',
      actions: const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.now(),
    );
  }
}

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'label': label,
        'parameters': parameters,
        'description': description,
      };
}

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

  factory FormBuilderAssistantSession.fromJson(Map<String, dynamic> json) {
    return FormBuilderAssistantSession(
      id: json['id']?.toString() ?? '',
      formId: json['formId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      messages: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );
  }
}

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

  FormBuilderAssistantState copyWith({
    String? sessionId,
    List<FormBuilderAssistantMessage>? messages,
    bool? isProcessing,
    String? error,
    Map<String, dynamic>? context,
  }) {
    return FormBuilderAssistantState(
      sessionId: sessionId ?? this.sessionId,
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error ?? this.error,
      context: context ?? this.context,
    );
  }
}

class FormBuilderAssistantActionTypes {
  static const String addField = 'add_field';
}

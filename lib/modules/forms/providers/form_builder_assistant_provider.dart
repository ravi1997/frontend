"""
lib/modules/forms/providers/form_builder_assistant_provider.dart
Provider for Form Builder Assistant state management.
"""

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../models/form_builder_assistant_models.dart';
import '../../core/services/api_service.dart';

class FormBuilderAssistantNotifier extends StateNotifier<FormBuilderAssistantState> {
  final String formId;
  final ApiService _apiService;

  FormBuilderAssistantNotifier({
    required this.formId,
    required ApiService apiService,
  })  : _apiService = apiService,
        super(FormBuilderAssistantState(
          sessionId: '',
          messages: [],
          isProcessing: false,
        ));

  Future<void> initialize() async {
    try {
      final response = await _apiService.post(
        '/api/internal/v1/forms/$formId/assistant/start',
        data: {},
      );

      final session = FormBuilderAssistantSession.fromJson(response.data);
      
      state = state.copyWith(
        sessionId: session.id,
        messages: session.messages,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendMessage(String message) async {
    if (state.isProcessing) return;

    // Add user message immediately
    final userMessage = FormBuilderAssistantMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: message,
      actions: [],
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isProcessing: true,
      error: null,
    );

    try {
      final response = await _apiService.post(
        '/api/internal/v1/forms/$formId/assistant/chat',
        data: {
          'session_id': state.sessionId,
          'message': message,
          'context': state.context,
        },
      );

      final assistantMessage = FormBuilderAssistantMessage.fromJson(response.data['message']);
      
      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isProcessing: false,
        context: response.data['context'],
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  Future<void> executeAction(FormBuilderAssistantAction action) async {
    try {
      await _apiService.post(
        '/api/internal/v1/forms/$formId/assistant/execute',
        data: {
          'session_id': state.sessionId,
          'action': action.toJson(),
        },
      );

      // Add confirmation message
      final confirmationMessage = FormBuilderAssistantMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: '✅ ${action.label} completed successfully!',
        actions: [],
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, confirmationMessage],
      );
    } catch (e) {
      // Add error message
      final errorMessage = FormBuilderAssistantMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: '❌ Failed to execute ${action.label}: ${e.toString()}',
        actions: [],
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        error: e.toString(),
      );
    }
  }

  Future<void> clearSession() async {
    try {
      await _apiService.delete(
        '/api/internal/v1/forms/$formId/assistant/session/${state.sessionId}',
      );

      state = FormBuilderAssistantState(
        sessionId: '',
        messages: [],
        isProcessing: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final formBuilderAssistantProvider = StateNotifierProviderFamily<
  FormBuilderAssistantNotifier,
  FormBuilderAssistantState,
  String
>((ref, formId) {
  final apiService = ref.read(apiServiceProvider);
  return FormBuilderAssistantNotifier(
    formId: formId,
    apiService: apiService,
  )..initialize();
});

// Extension to make copyWith available
extension FormBuilderAssistantStateExtension on FormBuilderAssistantState {
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
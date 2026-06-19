"""
lib/modules/core/providers/llm_config_provider.dart
Provider for LLM configuration state management.
"""

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../models/llm_config_models.dart';
import '../../core/services/api_service.dart';

class LLMConfigNotifier extends StateNotifier<AsyncValue<LLMConfiguration>> {
  final ApiService _apiService;

  LLMConfigNotifier({
    required ApiService apiService,
  })  : _apiService = apiService,
        super(const AsyncValue.loading()) {
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    try {
      final response = await _apiService.get('/api/internal/v1/llm/config');
      final config = LLMConfiguration.fromJson(response.data);
      state = AsyncValue.data(config);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addProvider(LLMProvider provider) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _apiService.post(
        '/api/internal/v1/llm/providers',
        data: provider.toJson(),
      );
      
      final newProvider = LLMProvider.fromJson(response.data);
      final currentConfig = state.value!;
      final updatedConfig = currentConfig.copyWith(
        providers: [...currentConfig.providers, newProvider],
      );
      
      state = AsyncValue.data(updatedConfig);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProvider(LLMProvider provider) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _apiService.put(
        '/api/internal/v1/llm/providers/${provider.id}',
        data: provider.toJson(),
      );
      
      final updatedProvider = LLMProvider.fromJson(response.data);
      final currentConfig = state.value!;
      final updatedProviders = currentConfig.providers.map((p) {
        return p.id == provider.id ? updatedProvider : p;
      }).toList();
      
      final updatedConfig = currentConfig.copyWith(providers: updatedProviders);
      state = AsyncValue.data(updatedConfig);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteProvider(String providerId) async {
    state = const AsyncValue.loading();
    
    try {
      await _apiService.delete('/api/internal/v1/llm/providers/$providerId');
      
      final currentConfig = state.value!;
      final updatedProviders = currentConfig.providers
          .where((p) => p.id != providerId)
          .toList();
      
      final updatedConfig = currentConfig.copyWith(providers: updatedProviders);
      state = AsyncValue.data(updatedConfig);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addModel(LLMModel model) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _apiService.post(
        '/api/internal/v1/llm/models',
        data: model.toJson(),
      );
      
      final newModel = LLMModel.fromJson(response.data);
      final currentConfig = state.value!;
      final updatedConfig = currentConfig.copyWith(
        models: [...currentConfig.models, newModel],
      );
      
      state = AsyncValue.data(updatedConfig);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateModel(LLMModel model) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _apiService.put(
        '/api/internal/v1/llm/models/${model.id}',
        data: model.toJson(),
      );
      
      final updatedModel = LLMModel.fromJson(response.data);
      final currentConfig = state.value!;
      final updatedModels = currentConfig.models.map((m) {
        return m.id == model.id ? updatedModel : m;
      }).toList();
      
      final updatedConfig = currentConfig.copyWith(models: updatedModels);
      state = AsyncValue.data(updatedConfig);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteModel(String modelId) async {
    state = const AsyncValue.loading();
    
    try {
      await _apiService.delete('/api/internal/v1/llm/models/$modelId');
      
      final currentConfig = state.value!;
      final updatedModels = currentConfig.models
          .where((m) => m.id != modelId)
          .toList();
      
      final updatedConfig = currentConfig.copyWith(models: updatedModels);
      state = AsyncValue.data(updatedConfig);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSettings(LLMGlobalSettings settings) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _apiService.put(
        '/api/internal/v1/llm/settings',
        data: settings.toJson(),
      );
      
      final updatedSettings = LLMGlobalSettings.fromJson(response.data);
      final currentConfig = state.value!;
      final updatedConfig = currentConfig.copyWith(settings: updatedSettings);
      
      state = AsyncValue.data(updatedConfig);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadConfiguration();
  }
}

final llmConfigProvider = StateNotifierProvider<LLMConfigNotifier, AsyncValue<LLMConfiguration>>(
  (ref) {
    final apiService = ref.read(apiServiceProvider);
    return LLMConfigNotifier(apiService: apiService);
  },
);

// Extension to make copyWith available for LLMConfiguration
extension LLMConfigurationExtension on LLMConfiguration {
  LLMConfiguration copyWith({
    List<LLMProvider>? providers,
    List<LLMModel>? models,
    LLMUsageStats? usage,
    LLMGlobalSettings? settings,
  }) {
    return LLMConfiguration(
      providers: providers ?? this.providers,
      models: models ?? this.models,
      usage: usage ?? this.usage,
      settings: settings ?? this.settings,
    );
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/llm_config_models.dart';

class LLMConfigNotifier {
  LLMConfigNotifier();
  final state = AsyncValue.data(
    LLMConfiguration(
      providers: const [],
      models: const [],
      usage: LLMUsageStats(
        totalTokens: 0,
        totalCost: 0,
        requestsToday: 0,
        requestsThisMonth: 0,
        quotaUsagePercentage: 0,
      ),
      settings: LLMGlobalSettings(
        defaultProvider: '',
        defaultModel: '',
        maxTokensPerRequest: 0,
        defaultTemperature: 0,
        costAlertThreshold: 0,
        enableUsageTracking: false,
        enableCostAlerts: false,
      ),
    ),
  );
  Future<void> refresh() async {}
  Future<void> addProvider(LLMProvider provider) async {}
  Future<void> updateProvider(LLMProvider provider) async {}
  Future<void> deleteProvider(String providerId) async {}
  Future<void> addModel(LLMModel model) async {}
  Future<void> updateModel(LLMModel model) async {}
  Future<void> deleteModel(String modelId) async {}
  Future<void> updateSettings(LLMGlobalSettings settings) async {}
}

final llmConfigProvider = Provider<LLMConfigNotifier>((ref) {
  return LLMConfigNotifier();
});

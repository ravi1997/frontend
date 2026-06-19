"""
lib/modules/core/models/llm_config_models.dart
Models for LLM configuration and management.
"""

import 'package:json_annotation/json_annotation.dart';

part 'llm_config_models.g.dart';

@JsonSerializable()
class LLMConfiguration {
  final List<LLMProvider> providers;
  final List<LLMModel> models;
  final LLMUsageStats usage;
  final LLMGlobalSettings settings;

  LLMConfiguration({
    required this.providers,
    required this.models,
    required this.usage,
    required this.settings,
  });

  factory LLMConfiguration.fromJson(Map<String, dynamic> json) =>
      _$LLMConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$LLMConfigurationToJson(this);
}

@JsonSerializable()
class LLMProvider {
  final String id;
  final String name;
  final String type;
  final String? apiKey;
  final String? baseUrl;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  LLMProvider({
    required this.id,
    required this.name,
    required this.type,
    this.apiKey,
    this.baseUrl,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LLMProvider.fromJson(Map<String, dynamic> json) =>
      _$LLMProviderFromJson(json);
  Map<String, dynamic> toJson() => _$LLMProviderToJson(this);
}

@JsonSerializable()
class LLMModel {
  final String id;
  final String name;
  final String provider;
  final int maxTokens;
  final bool supportsStreaming;
  final double costPer1kTokens;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  LLMModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.maxTokens,
    required this.supportsStreaming,
    required this.costPer1kTokens,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LLMModel.fromJson(Map<String, dynamic> json) =>
      _$LLMModelFromJson(json);
  Map<String, dynamic> toJson() => _$LLMModelToJson(this);
}

@JsonSerializable()
class LLMUsageStats {
  final int totalTokens;
  final double totalCost;
  final int requestsToday;
  final int requestsThisMonth;
  final double quotaUsagePercentage;

  LLMUsageStats({
    required this.totalTokens,
    required this.totalCost,
    required this.requestsToday,
    required this.requestsThisMonth,
    required this.quotaUsagePercentage,
  });

  factory LLMUsageStats.fromJson(Map<String, dynamic> json) =>
      _$LLMUsageStatsFromJson(json);
  Map<String, dynamic> toJson() => _$LLMUsageStatsToJson(this);
}

@JsonSerializable()
class LLMGlobalSettings {
  final String defaultProvider;
  final String defaultModel;
  final int maxTokensPerRequest;
  final double defaultTemperature;
  final double costAlertThreshold;
  final bool enableUsageTracking;
  final bool enableCostAlerts;

  LLMGlobalSettings({
    required this.defaultProvider,
    required this.defaultModel,
    required this.maxTokensPerRequest,
    required this.defaultTemperature,
    required this.costAlertThreshold,
    required this.enableUsageTracking,
    required this.enableCostAlerts,
  });

  factory LLMGlobalSettings.fromJson(Map<String, dynamic> json) =>
      _$LLMGlobalSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$LLMGlobalSettingsToJson(this);
}

// Extension methods for copyWith
extension LLMProviderExtension on LLMProvider {
  LLMProvider copyWith({
    String? id,
    String? name,
    String? type,
    String? apiKey,
    String? baseUrl,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LLMProvider(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

extension LLMModelExtension on LLMModel {
  LLMModel copyWith({
    String? id,
    String? name,
    String? provider,
    int? maxTokens,
    bool? supportsStreaming,
    double? costPer1kTokens,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LLMModel(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      maxTokens: maxTokens ?? this.maxTokens,
      supportsStreaming: supportsStreaming ?? this.supportsStreaming,
      costPer1kTokens: costPer1kTokens ?? this.costPer1kTokens,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

extension LLMUsageStatsExtension on LLMUsageStats {
  LLMUsageStats copyWith({
    int? totalTokens,
    double? totalCost,
    int? requestsToday,
    int? requestsThisMonth,
    double? quotaUsagePercentage,
  }) {
    return LLMUsageStats(
      totalTokens: totalTokens ?? this.totalTokens,
      totalCost: totalCost ?? this.totalCost,
      requestsToday: requestsToday ?? this.requestsToday,
      requestsThisMonth: requestsThisMonth ?? this.requestsThisMonth,
      quotaUsagePercentage: quotaUsagePercentage ?? this.quotaUsagePercentage,
    );
  }
}

extension LLMGlobalSettingsExtension on LLMGlobalSettings {
  LLMGlobalSettings copyWith({
    String? defaultProvider,
    String? defaultModel,
    int? maxTokensPerRequest,
    double? defaultTemperature,
    double? costAlertThreshold,
    bool? enableUsageTracking,
    bool? enableCostAlerts,
  }) {
    return LLMGlobalSettings(
      defaultProvider: defaultProvider ?? this.defaultProvider,
      defaultModel: defaultModel ?? this.defaultModel,
      maxTokensPerRequest: maxTokensPerRequest ?? this.maxTokensPerRequest,
      defaultTemperature: defaultTemperature ?? this.defaultTemperature,
      costAlertThreshold: costAlertThreshold ?? this.costAlertThreshold,
      enableUsageTracking: enableUsageTracking ?? this.enableUsageTracking,
      enableCostAlerts: enableCostAlerts ?? this.enableCostAlerts,
    );
  }
}
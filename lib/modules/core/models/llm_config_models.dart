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

  factory LLMConfiguration.fromJson(Map<String, dynamic> json) {
    return LLMConfiguration(
      providers: (json['providers'] as List? ?? const [])
          .map((e) => LLMProvider.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      models: (json['models'] as List? ?? const [])
          .map((e) => LLMModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      usage: LLMUsageStats.fromJson(Map<String, dynamic>.from(json['usage'] ?? {})),
      settings: LLMGlobalSettings.fromJson(
        Map<String, dynamic>.from(json['settings'] ?? {}),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'providers': providers.map((e) => e.toJson()).toList(),
        'models': models.map((e) => e.toJson()).toList(),
        'usage': usage.toJson(),
        'settings': settings.toJson(),
      };
}

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

  factory LLMProvider.fromJson(Map<String, dynamic> json) {
    return LLMProvider(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      apiKey: json['apiKey']?.toString() ?? json['api_key']?.toString(),
      baseUrl: json['baseUrl']?.toString() ?? json['base_url']?.toString(),
      isEnabled: json['isEnabled'] as bool? ?? json['is_enabled'] as bool? ?? true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'apiKey': apiKey,
        'baseUrl': baseUrl,
        'isEnabled': isEnabled,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

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

  factory LLMModel.fromJson(Map<String, dynamic> json) {
    return LLMModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      maxTokens: json['maxTokens'] as int? ?? json['max_tokens'] as int? ?? 0,
      supportsStreaming:
          json['supportsStreaming'] as bool? ?? json['supports_streaming'] as bool? ?? false,
      costPer1kTokens: (json['costPer1kTokens'] ?? json['cost_per_1k_tokens'] ?? 0).toDouble(),
      isEnabled: json['isEnabled'] as bool? ?? json['is_enabled'] as bool? ?? true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'provider': provider,
        'maxTokens': maxTokens,
        'supportsStreaming': supportsStreaming,
        'costPer1kTokens': costPer1kTokens,
        'isEnabled': isEnabled,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

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

  factory LLMUsageStats.fromJson(Map<String, dynamic> json) {
    return LLMUsageStats(
      totalTokens: json['totalTokens'] as int? ?? json['total_tokens'] as int? ?? 0,
      totalCost: (json['totalCost'] ?? json['total_cost'] ?? 0).toDouble(),
      requestsToday: json['requestsToday'] as int? ?? json['requests_today'] as int? ?? 0,
      requestsThisMonth:
          json['requestsThisMonth'] as int? ?? json['requests_this_month'] as int? ?? 0,
      quotaUsagePercentage: (json['quotaUsagePercentage'] ??
              json['quota_usage_percentage'] ??
              0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalTokens': totalTokens,
        'totalCost': totalCost,
        'requestsToday': requestsToday,
        'requestsThisMonth': requestsThisMonth,
        'quotaUsagePercentage': quotaUsagePercentage,
      };
}

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

  factory LLMGlobalSettings.fromJson(Map<String, dynamic> json) {
    return LLMGlobalSettings(
      defaultProvider: json['defaultProvider']?.toString() ?? '',
      defaultModel: json['defaultModel']?.toString() ?? '',
      maxTokensPerRequest:
          json['maxTokensPerRequest'] as int? ?? json['max_tokens_per_request'] as int? ?? 0,
      defaultTemperature:
          (json['defaultTemperature'] ?? json['default_temperature'] ?? 0).toDouble(),
      costAlertThreshold:
          (json['costAlertThreshold'] ?? json['cost_alert_threshold'] ?? 0).toDouble(),
      enableUsageTracking:
          json['enableUsageTracking'] as bool? ?? json['enable_usage_tracking'] as bool? ?? false,
      enableCostAlerts:
          json['enableCostAlerts'] as bool? ?? json['enable_cost_alerts'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'defaultProvider': defaultProvider,
        'defaultModel': defaultModel,
        'maxTokensPerRequest': maxTokensPerRequest,
        'defaultTemperature': defaultTemperature,
        'costAlertThreshold': costAlertThreshold,
        'enableUsageTracking': enableUsageTracking,
        'enableCostAlerts': enableCostAlerts,
      };
}

extension LLMConfigurationCopy on LLMConfiguration {
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

extension LLMProviderCopy on LLMProvider {
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

extension LLMModelCopy on LLMModel {
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

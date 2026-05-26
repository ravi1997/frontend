// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_settings_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemSettingsSchema _$SystemSettingsSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'SystemSettingsSchema',
  json,
  ($checkedConvert) {
    final val = SystemSettingsSchema(
      id: $checkedConvert('_id', (v) => v),
      accountLockDurationHours: $checkedConvert(
        'account_lock_duration_hours',
        (v) => (v as num?)?.toInt(),
      ),
      allowedUploadExtensions: $checkedConvert(
        'allowed_upload_extensions',
        (v) => v as String? ?? 'pdf,docx,xlsx,jpg,jpeg,png,gif,svg,mp4,mp3',
      ),
      cacheApiResponseTtlSeconds: $checkedConvert(
        'cache_api_response_ttl_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      cacheDashboardWidgetTtlSeconds: $checkedConvert(
        'cache_dashboard_widget_ttl_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      cacheDefaultTtlSeconds: $checkedConvert(
        'cache_default_ttl_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      cacheEnabled: $checkedConvert('cache_enabled', (v) => v as bool? ?? true),
      cacheFormSchemaTtlSeconds: $checkedConvert(
        'cache_form_schema_ttl_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      cacheQueryResultTtlSeconds: $checkedConvert(
        'cache_query_result_ttl_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      cacheUserSessionTtlSeconds: $checkedConvert(
        'cache_user_session_ttl_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      corsEnabled: $checkedConvert('cors_enabled', (v) => v as bool? ?? true),
      createdAt: $checkedConvert('created_at', (v) => v),
      debugMode: $checkedConvert('debug_mode', (v) => v as bool? ?? false),
      envKey: $checkedConvert('env_key', (v) => v as String? ?? 'default'),
      jwtAccessTokenExpiresMinutes: $checkedConvert(
        'jwt_access_token_expires_minutes',
        (v) => (v as num?)?.toInt(),
      ),
      jwtRefreshTokenExpiresDays: $checkedConvert(
        'jwt_refresh_token_expires_days',
        (v) => (v as num?)?.toInt(),
      ),
      llmApiUrl: $checkedConvert(
        'llm_api_url',
        (v) => v as String? ?? 'http://ollama:11434/v1',
      ),
      llmModel: $checkedConvert('llm_model', (v) => v as String? ?? 'llama3'),
      llmProvider: $checkedConvert(
        'llm_provider',
        (v) => v as String? ?? 'ollama',
      ),
      maxFailedLoginAttempts: $checkedConvert(
        'max_failed_login_attempts',
        (v) => (v as num?)?.toInt(),
      ),
      maxOtpResends: $checkedConvert(
        'max_otp_resends',
        (v) => (v as num?)?.toInt(),
      ),
      maxUploadSizeMb: $checkedConvert(
        'max_upload_size_mb',
        (v) => (v as num?)?.toInt(),
      ),
      ollamaApiUrl: $checkedConvert(
        'ollama_api_url',
        (v) => v as String? ?? 'http://localhost:11434',
      ),
      ollamaConnectionTimeoutSeconds: $checkedConvert(
        'ollama_connection_timeout_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      ollamaEmbeddingModel: $checkedConvert(
        'ollama_embedding_model',
        (v) => v as String? ?? 'nomic-embed-text',
      ),
      ollamaPoolSize: $checkedConvert(
        'ollama_pool_size',
        (v) => (v as num?)?.toInt(),
      ),
      ollamaPoolTimeoutSeconds: $checkedConvert(
        'ollama_pool_timeout_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      otpExpirationMinutes: $checkedConvert(
        'otp_expiration_minutes',
        (v) => (v as num?)?.toInt(),
      ),
      passwordExpirationDays: $checkedConvert(
        'password_expiration_days',
        (v) => (v as num?)?.toInt(),
      ),
      rateLimitEnabled: $checkedConvert(
        'rate_limit_enabled',
        (v) => v as bool? ?? true,
      ),
      rateLimitRequestsPerMinute: $checkedConvert(
        'rate_limit_requests_per_minute',
        (v) => (v as num?)?.toInt(),
      ),
      redisDb: $checkedConvert('redis_db', (v) => (v as num?)?.toInt()),
      redisHost: $checkedConvert(
        'redis_host',
        (v) => v as String? ?? 'localhost',
      ),
      redisMaxConnections: $checkedConvert(
        'redis_max_connections',
        (v) => (v as num?)?.toInt(),
      ),
      redisPort: $checkedConvert('redis_port', (v) => (v as num?)?.toInt()),
      redisSocketTimeoutSeconds: $checkedConvert(
        'redis_socket_timeout_seconds',
        (v) => (v as num?)?.toInt(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      updatedBy: $checkedConvert('updated_by', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'accountLockDurationHours': 'account_lock_duration_hours',
    'allowedUploadExtensions': 'allowed_upload_extensions',
    'cacheApiResponseTtlSeconds': 'cache_api_response_ttl_seconds',
    'cacheDashboardWidgetTtlSeconds': 'cache_dashboard_widget_ttl_seconds',
    'cacheDefaultTtlSeconds': 'cache_default_ttl_seconds',
    'cacheEnabled': 'cache_enabled',
    'cacheFormSchemaTtlSeconds': 'cache_form_schema_ttl_seconds',
    'cacheQueryResultTtlSeconds': 'cache_query_result_ttl_seconds',
    'cacheUserSessionTtlSeconds': 'cache_user_session_ttl_seconds',
    'corsEnabled': 'cors_enabled',
    'createdAt': 'created_at',
    'debugMode': 'debug_mode',
    'envKey': 'env_key',
    'jwtAccessTokenExpiresMinutes': 'jwt_access_token_expires_minutes',
    'jwtRefreshTokenExpiresDays': 'jwt_refresh_token_expires_days',
    'llmApiUrl': 'llm_api_url',
    'llmModel': 'llm_model',
    'llmProvider': 'llm_provider',
    'maxFailedLoginAttempts': 'max_failed_login_attempts',
    'maxOtpResends': 'max_otp_resends',
    'maxUploadSizeMb': 'max_upload_size_mb',
    'ollamaApiUrl': 'ollama_api_url',
    'ollamaConnectionTimeoutSeconds': 'ollama_connection_timeout_seconds',
    'ollamaEmbeddingModel': 'ollama_embedding_model',
    'ollamaPoolSize': 'ollama_pool_size',
    'ollamaPoolTimeoutSeconds': 'ollama_pool_timeout_seconds',
    'otpExpirationMinutes': 'otp_expiration_minutes',
    'passwordExpirationDays': 'password_expiration_days',
    'rateLimitEnabled': 'rate_limit_enabled',
    'rateLimitRequestsPerMinute': 'rate_limit_requests_per_minute',
    'redisDb': 'redis_db',
    'redisHost': 'redis_host',
    'redisMaxConnections': 'redis_max_connections',
    'redisPort': 'redis_port',
    'redisSocketTimeoutSeconds': 'redis_socket_timeout_seconds',
    'updatedAt': 'updated_at',
    'updatedBy': 'updated_by',
  },
);

Map<String, dynamic> _$SystemSettingsSchemaToJson(
  SystemSettingsSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'account_lock_duration_hours': ?instance.accountLockDurationHours,
  'allowed_upload_extensions': ?instance.allowedUploadExtensions,
  'cache_api_response_ttl_seconds': ?instance.cacheApiResponseTtlSeconds,
  'cache_dashboard_widget_ttl_seconds':
      ?instance.cacheDashboardWidgetTtlSeconds,
  'cache_default_ttl_seconds': ?instance.cacheDefaultTtlSeconds,
  'cache_enabled': ?instance.cacheEnabled,
  'cache_form_schema_ttl_seconds': ?instance.cacheFormSchemaTtlSeconds,
  'cache_query_result_ttl_seconds': ?instance.cacheQueryResultTtlSeconds,
  'cache_user_session_ttl_seconds': ?instance.cacheUserSessionTtlSeconds,
  'cors_enabled': ?instance.corsEnabled,
  'created_at': ?instance.createdAt,
  'debug_mode': ?instance.debugMode,
  'env_key': ?instance.envKey,
  'jwt_access_token_expires_minutes': ?instance.jwtAccessTokenExpiresMinutes,
  'jwt_refresh_token_expires_days': ?instance.jwtRefreshTokenExpiresDays,
  'llm_api_url': ?instance.llmApiUrl,
  'llm_model': ?instance.llmModel,
  'llm_provider': ?instance.llmProvider,
  'max_failed_login_attempts': ?instance.maxFailedLoginAttempts,
  'max_otp_resends': ?instance.maxOtpResends,
  'max_upload_size_mb': ?instance.maxUploadSizeMb,
  'ollama_api_url': ?instance.ollamaApiUrl,
  'ollama_connection_timeout_seconds': ?instance.ollamaConnectionTimeoutSeconds,
  'ollama_embedding_model': ?instance.ollamaEmbeddingModel,
  'ollama_pool_size': ?instance.ollamaPoolSize,
  'ollama_pool_timeout_seconds': ?instance.ollamaPoolTimeoutSeconds,
  'otp_expiration_minutes': ?instance.otpExpirationMinutes,
  'password_expiration_days': ?instance.passwordExpirationDays,
  'rate_limit_enabled': ?instance.rateLimitEnabled,
  'rate_limit_requests_per_minute': ?instance.rateLimitRequestsPerMinute,
  'redis_db': ?instance.redisDb,
  'redis_host': ?instance.redisHost,
  'redis_max_connections': ?instance.redisMaxConnections,
  'redis_port': ?instance.redisPort,
  'redis_socket_timeout_seconds': ?instance.redisSocketTimeoutSeconds,
  'updated_at': ?instance.updatedAt,
  'updated_by': ?instance.updatedBy,
};

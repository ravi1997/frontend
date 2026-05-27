//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'system_settings_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SystemSettingsSchema {
  /// Returns a new [SystemSettingsSchema] instance.
  SystemSettingsSchema({

     this.id,

     this.accountLockDurationHours,

     this.allowedUploadExtensions = 'pdf,docx,xlsx,jpg,jpeg,png,gif,svg,mp4,mp3',

     this.cacheApiResponseTtlSeconds,

     this.cacheDashboardWidgetTtlSeconds,

     this.cacheDefaultTtlSeconds,

     this.cacheEnabled = true,

     this.cacheFormSchemaTtlSeconds,

     this.cacheQueryResultTtlSeconds,

     this.cacheUserSessionTtlSeconds,

     this.corsEnabled = true,

     this.createdAt,

     this.debugMode = false,

     this.envKey = 'default',

     this.jwtAccessTokenExpiresMinutes,

     this.jwtRefreshTokenExpiresDays,

     this.llmApiUrl = 'http://ollama:11434/v1',

     this.llmModel = 'llama3',

     this.llmProvider = 'ollama',

     this.maxFailedLoginAttempts,

     this.maxOtpResends,

     this.maxUploadSizeMb,

     this.ollamaApiUrl = 'http://localhost:11434',

     this.ollamaConnectionTimeoutSeconds,

     this.ollamaEmbeddingModel = 'nomic-embed-text',

     this.ollamaPoolSize,

     this.ollamaPoolTimeoutSeconds,

     this.otpExpirationMinutes,

     this.passwordExpirationDays,

     this.rateLimitEnabled = true,

     this.rateLimitRequestsPerMinute,

     this.redisDb,

     this.redisHost = 'localhost',

     this.redisMaxConnections,

     this.redisPort,

     this.redisSocketTimeoutSeconds,

     this.updatedAt,

     this.updatedBy,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false,
  )


  final Object? id;



  @JsonKey(
    
    name: r'account_lock_duration_hours',
    required: false,
    includeIfNull: false,
  )


  final int? accountLockDurationHours;



  @JsonKey(
    defaultValue: 'pdf,docx,xlsx,jpg,jpeg,png,gif,svg,mp4,mp3',
    name: r'allowed_upload_extensions',
    required: false,
    includeIfNull: false,
  )


  final String? allowedUploadExtensions;



  @JsonKey(
    
    name: r'cache_api_response_ttl_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? cacheApiResponseTtlSeconds;



  @JsonKey(
    
    name: r'cache_dashboard_widget_ttl_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? cacheDashboardWidgetTtlSeconds;



  @JsonKey(
    
    name: r'cache_default_ttl_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? cacheDefaultTtlSeconds;



  @JsonKey(
    defaultValue: true,
    name: r'cache_enabled',
    required: false,
    includeIfNull: false,
  )


  final bool? cacheEnabled;



  @JsonKey(
    
    name: r'cache_form_schema_ttl_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? cacheFormSchemaTtlSeconds;



  @JsonKey(
    
    name: r'cache_query_result_ttl_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? cacheQueryResultTtlSeconds;



  @JsonKey(
    
    name: r'cache_user_session_ttl_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? cacheUserSessionTtlSeconds;



  @JsonKey(
    defaultValue: true,
    name: r'cors_enabled',
    required: false,
    includeIfNull: false,
  )


  final bool? corsEnabled;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



  @JsonKey(
    defaultValue: false,
    name: r'debug_mode',
    required: false,
    includeIfNull: false,
  )


  final bool? debugMode;



  @JsonKey(
    defaultValue: 'default',
    name: r'env_key',
    required: false,
    includeIfNull: false,
  )


  final String? envKey;



  @JsonKey(
    
    name: r'jwt_access_token_expires_minutes',
    required: false,
    includeIfNull: false,
  )


  final int? jwtAccessTokenExpiresMinutes;



  @JsonKey(
    
    name: r'jwt_refresh_token_expires_days',
    required: false,
    includeIfNull: false,
  )


  final int? jwtRefreshTokenExpiresDays;



  @JsonKey(
    defaultValue: 'http://ollama:11434/v1',
    name: r'llm_api_url',
    required: false,
    includeIfNull: false,
  )


  final String? llmApiUrl;



  @JsonKey(
    defaultValue: 'llama3',
    name: r'llm_model',
    required: false,
    includeIfNull: false,
  )


  final String? llmModel;



  @JsonKey(
    defaultValue: 'ollama',
    name: r'llm_provider',
    required: false,
    includeIfNull: false,
  )


  final String? llmProvider;



  @JsonKey(
    
    name: r'max_failed_login_attempts',
    required: false,
    includeIfNull: false,
  )


  final int? maxFailedLoginAttempts;



  @JsonKey(
    
    name: r'max_otp_resends',
    required: false,
    includeIfNull: false,
  )


  final int? maxOtpResends;



  @JsonKey(
    
    name: r'max_upload_size_mb',
    required: false,
    includeIfNull: false,
  )


  final int? maxUploadSizeMb;



  @JsonKey(
    defaultValue: 'http://localhost:11434',
    name: r'ollama_api_url',
    required: false,
    includeIfNull: false,
  )


  final String? ollamaApiUrl;



  @JsonKey(
    
    name: r'ollama_connection_timeout_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? ollamaConnectionTimeoutSeconds;



  @JsonKey(
    defaultValue: 'nomic-embed-text',
    name: r'ollama_embedding_model',
    required: false,
    includeIfNull: false,
  )


  final String? ollamaEmbeddingModel;



  @JsonKey(
    
    name: r'ollama_pool_size',
    required: false,
    includeIfNull: false,
  )


  final int? ollamaPoolSize;



  @JsonKey(
    
    name: r'ollama_pool_timeout_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? ollamaPoolTimeoutSeconds;



  @JsonKey(
    
    name: r'otp_expiration_minutes',
    required: false,
    includeIfNull: false,
  )


  final int? otpExpirationMinutes;



  @JsonKey(
    
    name: r'password_expiration_days',
    required: false,
    includeIfNull: false,
  )


  final int? passwordExpirationDays;



  @JsonKey(
    defaultValue: true,
    name: r'rate_limit_enabled',
    required: false,
    includeIfNull: false,
  )


  final bool? rateLimitEnabled;



  @JsonKey(
    
    name: r'rate_limit_requests_per_minute',
    required: false,
    includeIfNull: false,
  )


  final int? rateLimitRequestsPerMinute;



  @JsonKey(
    
    name: r'redis_db',
    required: false,
    includeIfNull: false,
  )


  final int? redisDb;



  @JsonKey(
    defaultValue: 'localhost',
    name: r'redis_host',
    required: false,
    includeIfNull: false,
  )


  final String? redisHost;



  @JsonKey(
    
    name: r'redis_max_connections',
    required: false,
    includeIfNull: false,
  )


  final int? redisMaxConnections;



  @JsonKey(
    
    name: r'redis_port',
    required: false,
    includeIfNull: false,
  )


  final int? redisPort;



  @JsonKey(
    
    name: r'redis_socket_timeout_seconds',
    required: false,
    includeIfNull: false,
  )


  final int? redisSocketTimeoutSeconds;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'updated_by',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedBy;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SystemSettingsSchema &&
      other.id == id &&
      other.accountLockDurationHours == accountLockDurationHours &&
      other.allowedUploadExtensions == allowedUploadExtensions &&
      other.cacheApiResponseTtlSeconds == cacheApiResponseTtlSeconds &&
      other.cacheDashboardWidgetTtlSeconds == cacheDashboardWidgetTtlSeconds &&
      other.cacheDefaultTtlSeconds == cacheDefaultTtlSeconds &&
      other.cacheEnabled == cacheEnabled &&
      other.cacheFormSchemaTtlSeconds == cacheFormSchemaTtlSeconds &&
      other.cacheQueryResultTtlSeconds == cacheQueryResultTtlSeconds &&
      other.cacheUserSessionTtlSeconds == cacheUserSessionTtlSeconds &&
      other.corsEnabled == corsEnabled &&
      other.createdAt == createdAt &&
      other.debugMode == debugMode &&
      other.envKey == envKey &&
      other.jwtAccessTokenExpiresMinutes == jwtAccessTokenExpiresMinutes &&
      other.jwtRefreshTokenExpiresDays == jwtRefreshTokenExpiresDays &&
      other.llmApiUrl == llmApiUrl &&
      other.llmModel == llmModel &&
      other.llmProvider == llmProvider &&
      other.maxFailedLoginAttempts == maxFailedLoginAttempts &&
      other.maxOtpResends == maxOtpResends &&
      other.maxUploadSizeMb == maxUploadSizeMb &&
      other.ollamaApiUrl == ollamaApiUrl &&
      other.ollamaConnectionTimeoutSeconds == ollamaConnectionTimeoutSeconds &&
      other.ollamaEmbeddingModel == ollamaEmbeddingModel &&
      other.ollamaPoolSize == ollamaPoolSize &&
      other.ollamaPoolTimeoutSeconds == ollamaPoolTimeoutSeconds &&
      other.otpExpirationMinutes == otpExpirationMinutes &&
      other.passwordExpirationDays == passwordExpirationDays &&
      other.rateLimitEnabled == rateLimitEnabled &&
      other.rateLimitRequestsPerMinute == rateLimitRequestsPerMinute &&
      other.redisDb == redisDb &&
      other.redisHost == redisHost &&
      other.redisMaxConnections == redisMaxConnections &&
      other.redisPort == redisPort &&
      other.redisSocketTimeoutSeconds == redisSocketTimeoutSeconds &&
      other.updatedAt == updatedAt &&
      other.updatedBy == updatedBy;

    @override
    int get hashCode =>
        id.hashCode +
        accountLockDurationHours.hashCode +
        allowedUploadExtensions.hashCode +
        cacheApiResponseTtlSeconds.hashCode +
        cacheDashboardWidgetTtlSeconds.hashCode +
        cacheDefaultTtlSeconds.hashCode +
        cacheEnabled.hashCode +
        cacheFormSchemaTtlSeconds.hashCode +
        cacheQueryResultTtlSeconds.hashCode +
        cacheUserSessionTtlSeconds.hashCode +
        corsEnabled.hashCode +
        createdAt.hashCode +
        debugMode.hashCode +
        envKey.hashCode +
        jwtAccessTokenExpiresMinutes.hashCode +
        jwtRefreshTokenExpiresDays.hashCode +
        llmApiUrl.hashCode +
        llmModel.hashCode +
        llmProvider.hashCode +
        maxFailedLoginAttempts.hashCode +
        maxOtpResends.hashCode +
        maxUploadSizeMb.hashCode +
        ollamaApiUrl.hashCode +
        ollamaConnectionTimeoutSeconds.hashCode +
        ollamaEmbeddingModel.hashCode +
        ollamaPoolSize.hashCode +
        ollamaPoolTimeoutSeconds.hashCode +
        otpExpirationMinutes.hashCode +
        passwordExpirationDays.hashCode +
        rateLimitEnabled.hashCode +
        rateLimitRequestsPerMinute.hashCode +
        redisDb.hashCode +
        redisHost.hashCode +
        redisMaxConnections.hashCode +
        redisPort.hashCode +
        redisSocketTimeoutSeconds.hashCode +
        updatedAt.hashCode +
        updatedBy.hashCode;

  factory SystemSettingsSchema.fromJson(Map<String, dynamic> json) => _$SystemSettingsSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$SystemSettingsSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


# ridp_api.model.SystemSettingsSchema

## Load the model package
```dart
import 'package:ridp_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **Object** |  | [optional] 
**accountLockDurationHours** | **int** |  | [optional] 
**allowedUploadExtensions** | **String** |  | [optional] [default to 'pdf,docx,xlsx,jpg,jpeg,png,gif,svg,mp4,mp3']
**cacheApiResponseTtlSeconds** | **int** |  | [optional] 
**cacheDashboardWidgetTtlSeconds** | **int** |  | [optional] 
**cacheDefaultTtlSeconds** | **int** |  | [optional] 
**cacheEnabled** | **bool** |  | [optional] [default to true]
**cacheFormSchemaTtlSeconds** | **int** |  | [optional] 
**cacheQueryResultTtlSeconds** | **int** |  | [optional] 
**cacheUserSessionTtlSeconds** | **int** |  | [optional] 
**corsEnabled** | **bool** |  | [optional] [default to true]
**createdAt** | **Object** |  | [optional] 
**debugMode** | **bool** |  | [optional] [default to false]
**envKey** | **String** |  | [optional] [default to 'default']
**jwtAccessTokenExpiresMinutes** | **int** |  | [optional] 
**jwtRefreshTokenExpiresDays** | **int** |  | [optional] 
**llmApiUrl** | **String** |  | [optional] [default to 'http://ollama:11434/v1']
**llmModel** | **String** |  | [optional] [default to 'llama3']
**llmProvider** | **String** |  | [optional] [default to 'ollama']
**maxFailedLoginAttempts** | **int** |  | [optional] 
**maxOtpResends** | **int** |  | [optional] 
**maxUploadSizeMb** | **int** |  | [optional] 
**ollamaApiUrl** | **String** |  | [optional] [default to 'http://localhost:11434']
**ollamaConnectionTimeoutSeconds** | **int** |  | [optional] 
**ollamaEmbeddingModel** | **String** |  | [optional] [default to 'nomic-embed-text']
**ollamaPoolSize** | **int** |  | [optional] 
**ollamaPoolTimeoutSeconds** | **int** |  | [optional] 
**otpExpirationMinutes** | **int** |  | [optional] 
**passwordExpirationDays** | **int** |  | [optional] 
**rateLimitEnabled** | **bool** |  | [optional] [default to true]
**rateLimitRequestsPerMinute** | **int** |  | [optional] 
**redisDb** | **int** |  | [optional] 
**redisHost** | **String** |  | [optional] [default to 'localhost']
**redisMaxConnections** | **int** |  | [optional] 
**redisPort** | **int** |  | [optional] 
**redisSocketTimeoutSeconds** | **int** |  | [optional] 
**updatedAt** | **Object** |  | [optional] 
**updatedBy** | **Object** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



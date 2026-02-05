# 02. Technical Architecture - AI Form Intelligence

## System Architecture Overview

The AI Form Intelligence Epic integrates AI/ML capabilities throughout the form lifecycle, from creation to response analysis.

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                          │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ AI Form Builder  │  │ Auto-Fill UI     │  │ Analysis UI   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Domain Layer                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ AI Generated Form│  │ Sentiment        │  │ Topic        │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ PII Detection   │  │ Quality Score    │  │ Prediction   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Data Layer                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ AI Service Repo  │  │ NLP Repo        │  │ ML Model Repo │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Infrastructure Layer                         │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ ML Model Service │  │ NLP Service      │  │ Document     │ │
│  │                 │  │                  │  │ Parser       │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Model Cache      │  │ Batch Processor  │  │ Feature      │ │
│  │                 │  │                  │  │ Extractor    │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### Presentation Layer

#### New Flutter Packages Required

```yaml
dependencies:
  # NLP and ML
  google_ml_kit: ^0.18.0
  tflite_flutter: ^0.10.4
  
  # Document parsing
  pdf: ^3.10.0
  document_scanner: ^1.0.0
  
  # Auto-fill
  flutter_secure_storage: ^9.0.0
  
  # Existing packages
  flutter_riverpod: ^3.1.0  # Existing, extend usage
```

#### New Presentation Components

```dart
// lib/features/ai/presentation/pages/
lib/features/ai/presentation/pages/
  ├── ai_form_generator_page.dart
  ├── document_import_page.dart
  ├── sentiment_analysis_page.dart
  ├── topic_extraction_page.dart
  └── pii_detection_page.dart

// Widgets
lib/features/ai/presentation/widgets/
  ├── ai_prompt_input_widget.dart
  ├── generated_form_preview_widget.dart
  ├── auto_fill_suggestion_chip.dart
  ├── sentiment_indicator_widget.dart
  └── pii_redaction_widget.dart
```

### Domain Layer

#### New Domain Entities

```dart
// lib/features/ai/domain/entities/

class AiGeneratedForm {
  final String id;
  final String formId;
  final String prompt;
  final List<GeneratedSection> sections;
  final double confidenceScore;
  final DateTime createdAt;
}

class GeneratedSection {
  final String id;
  final String title;
  final String description;
  final List<GeneratedQuestion> questions;
}

class GeneratedQuestion {
  final String id;
  final String label;
  final QuestionType type;
  final List<String> options;
  final ValidationRule validation;
  final double confidenceScore;
}

class SentimentAnalysis {
  final String id;
  final String responseId;
  final SentimentLabel sentiment;
  final double score;
  final Map<String, double> emotions;
  final DateTime analyzedAt;
}

enum SentimentLabel { positive, negative, neutral }

class TopicExtraction {
  final String id;
  final String responseId;
  final List<Topic> topics;
  final DateTime extractedAt;
}

class Topic {
  final String label;
  final double confidence;
  final List<String> keywords;
}

class PiiDetection {
  final String id;
  final String responseId;
  final List<PiiInstance> detectedPii;
  final DateTime detectedAt;
}

class PiiInstance {
  final PiiType type;
  final String value;
  final int startIndex;
  final int endIndex;
  final double confidence;
}

enum PiiType { email, phone, ssn, creditCard, address, name }

class ResponseQualityScore {
  final String id;
  final String responseId;
  final double overallScore;
  final Map<String, double> criteriaScores;
  final DateTime scoredAt;
}
```

#### New Domain Services

```dart
// lib/features/ai/domain/services/

class AiFormGenerationService {
  Future<AiGeneratedForm> generateForm({
    required String prompt,
    String? formType,
    List<String>? requiredFields,
  }) async {
    // Generate form structure using ML model
    final model = await _modelService.getModel('form_generator');
    final result = await model.predict({
      'prompt': prompt,
      'formType': formType,
      'requiredFields': requiredFields,
    });
    
    // Parse result into form structure
    final sections = _parseGeneratedSections(result['sections']);
    
    return AiGeneratedForm(
      id: uuid.v4(),
      formId: '', // Will be set when form is created
      prompt: prompt,
      sections: sections,
      confidenceScore: result['confidence'],
      createdAt: DateTime.now(),
    );
  }
  
  List<GeneratedSection> _parseGeneratedSections(dynamic sections) {
    return (sections as List).map((section) {
      return GeneratedSection(
        id: uuid.v4(),
        title: section['title'],
        description: section['description'],
        questions: _parseGeneratedQuestions(section['questions']),
      );
    }).toList();
  }
}

class DocumentImportService {
  Future<AiGeneratedForm> importFromDocument({
    required File document,
    DocumentType type,
  }) async {
    // Parse document
    final text = await _parseDocument(document, type);
    
    // Extract form structure using NLP
    final structure = await _nlpService.extractFormStructure(text);
    
    // Generate form from structure
    final form = await _generateFormFromStructure(structure);
    
    return form;
  }
  
  Future<String> _parseDocument(File document, DocumentType type) async {
    switch (type) {
      case DocumentType.pdf:
        return await _pdfParser.parse(document);
      case DocumentType.word:
        return await _wordParser.parse(document);
    }
  }
}

class AutoFillService {
  Future<Map<String, dynamic>> getSuggestions({
    required String formId,
    required String userId,
    required List<FormQuestion> questions,
  }) async {
    final suggestions = <String, dynamic>{};
    
    // Get user profile
    final profile = await _userRepository.getProfile(userId);
    
    // Get historical responses
    final history = await _responseRepository.getHistory(userId);
    
    for (final question in questions) {
      final suggestion = await _generateSuggestion(
        question,
        profile,
        history,
      );
      if (suggestion != null) {
        suggestions[question.id] = suggestion;
      }
    }
    
    return suggestions;
  }
  
  Future<dynamic> _generateSuggestion(
    FormQuestion question,
    UserProfile profile,
    List<FormResponse> history,
  ) async {
    // Check profile first
    final profileValue = _extractFromProfile(question, profile);
    if (profileValue != null) return profileValue;
    
    // Check historical responses
    final historicalValue = _extractFromHistory(question, history);
    if (historicalValue != null) return historicalValue;
    
    // Use ML model for prediction
    return await _predictValue(question, profile, history);
  }
}

class SentimentAnalysisService {
  Future<SentimentAnalysis> analyzeSentiment({
    required String responseId,
    required Map<String, dynamic> responseData,
  }) async {
    // Extract text fields
    final textFields = _extractTextFields(responseData);
    
    // Analyze sentiment using NLP model
    final model = await _modelService.getModel('sentiment');
    final results = await Future.wait(
      textFields.map((field) => model.predict({
        'text': field.value,
      })),
    );
    
    // Aggregate results
    final aggregated = _aggregateSentiment(results);
    
    return SentimentAnalysis(
      id: uuid.v4(),
      responseId: responseId,
      sentiment: aggregated['label'],
      score: aggregated['score'],
      emotions: aggregated['emotions'],
      analyzedAt: DateTime.now(),
    );
  }
}

class PiiDetectionService {
  Future<PiiDetection> detectPii({
    required String responseId,
    required Map<String, dynamic> responseData,
  }) async {
    final detectedPii = <PiiInstance>[];
    
    // Check each field for PII
    for (final entry in responseData.entries) {
      final value = entry.value.toString();
      final pii = await _detectPiiInText(value);
      detectedPii.addAll(pii);
    }
    
    return PiiDetection(
      id: uuid.v4(),
      responseId: responseId,
      detectedPii: detectedPii,
      detectedAt: DateTime.now(),
    );
  }
  
  Future<List<PiiInstance>> _detectPiiInText(String text) async {
    final detected = <PiiInstance>[];
    
    // Use regex patterns for common PII
    detected.addAll(_detectEmail(text));
    detected.addAll(_detectPhone(text));
    detected.addAll(_detectSsn(text));
    detected.addAll(_detectCreditCard(text));
    
    // Use ML model for more complex PII
    final model = await _modelService.getModel('pii_detector');
    final mlDetected = await model.predict({'text': text});
    detected.addAll(_parseMlPii(mlDetected));
    
    return detected;
  }
}

class QualityScoringService {
  Future<ResponseQualityScore> scoreResponse({
    required String responseId,
    required Map<String, dynamic> responseData,
    required FormMetadata formMetadata,
  }) async {
    final criteriaScores = <String, double>{};
    
    // Completeness score
    criteriaScores['completeness'] = _calculateCompleteness(
      responseData,
      formMetadata,
    );
    
    // Consistency score
    criteriaScores['consistency'] = await _calculateConsistency(
      responseData,
      formMetadata,
    );
    
    // Time score
    criteriaScores['time'] = await _calculateTimeScore(responseId);
    
    // Overall score
    final overallScore = criteriaScores.values.reduce((a, b) => a + b) / 
                        criteriaScores.length;
    
    return ResponseQualityScore(
      id: uuid.v4(),
      responseId: responseId,
      overallScore: overallScore,
      criteriaScores: criteriaScores,
      scoredAt: DateTime.now(),
    );
  }
}
```

### Data Layer

#### New Repository Interfaces

```dart
// lib/features/ai/domain/repositories/

abstract class AiServiceRepository {
  Future<AiGeneratedForm> generateForm(String prompt);
  Future<AiGeneratedForm> importFromDocument(File document);
  Future<Map<String, dynamic>> getAutoFillSuggestions({
    required String formId,
    required String userId,
  });
}

abstract class NlpRepository {
  Future<SentimentAnalysis> analyzeSentiment({
    required String responseId,
    required Map<String, dynamic> responseData,
  });
  Future<TopicExtraction> extractTopics({
    required String responseId,
    required Map<String, dynamic> responseData,
  });
  Future<PiiDetection> detectPii({
    required String responseId,
    required Map<String, dynamic> responseData,
  });
}

abstract class MlModelRepository {
  Future<MlModel> getModel(String modelName);
  Future<dynamic> predict(String modelName, Map<String, dynamic> input);
  Future<void> trainModel(String modelName, TrainingData data);
}
```

#### Repository Implementation

```dart
// lib/features/ai/data/repositories/

class AiServiceRepositoryImpl implements AiServiceRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;
  
  @override
  Future<AiGeneratedForm> generateForm(String prompt) async {
    final response = await _apiClient.post(
      '/api/ai/generate-form',
      data: {'prompt': prompt},
    );
    return AiGeneratedForm.fromJson(response.data);
  }
  
  @override
  Future<AiGeneratedForm> importFromDocument(File document) async {
    final formData = await FormData.fromMap({
      'document': await MultipartFile.fromFile(document.path),
    });
    
    final response = await _apiClient.post(
      '/api/ai/import-document',
      data: formData,
    );
    return AiGeneratedForm.fromJson(response.data);
  }
  
  @override
  Future<Map<String, dynamic>> getAutoFillSuggestions({
    required String formId,
    required String userId,
  }) async {
    final response = await _apiClient.get(
      '/api/ai/autofill-suggestions',
      queryParameters: {'formId': formId, 'userId': userId},
    );
    return response.data;
  }
}

class NlpRepositoryImpl implements NlpRepository {
  final ApiClient _apiClient;
  final GoogleMlKit _mlKit;
  
  @override
  Future<SentimentAnalysis> analyzeSentiment({
    required String responseId,
    required Map<String, dynamic> responseData,
  }) async {
    // Use on-device ML Kit for privacy
    final textFields = _extractTextFields(responseData);
    final sentimentDetector = _mlKit.sentimentDetector();
    
    final results = await Future.wait(
      textFields.map((field) async {
        final result = await sentimentDetector.analyzeText(field.value);
        return {
          'fieldId': field.id,
          'sentiment': result.sentiment,
          'score': result.score,
        };
      }),
    );
    
    // Aggregate results
    final aggregated = _aggregateSentimentResults(results);
    
    return SentimentAnalysis(
      id: uuid.v4(),
      responseId: responseId,
      sentiment: aggregated['label'],
      score: aggregated['score'],
      emotions: {},
      analyzedAt: DateTime.now(),
    );
  }
  
  @override
  Future<PiiDetection> detectPii({
    required String responseId,
    required Map<String, dynamic> responseData,
  }) async {
    final response = await _apiClient.post(
      '/api/ai/detect-pii',
      data: {'responseId': responseId, 'data': responseData},
    );
    return PiiDetection.fromJson(response.data);
  }
}
```

## ML Model Architecture

### Model Types

```dart
// lib/features/ai/domain/models/

abstract class MlModel {
  Future<dynamic> predict(Map<String, dynamic> input);
  Future<void> train(TrainingData data);
  Future<double> evaluate(TestData data);
}

class FormGeneratorModel implements MlModel {
  final TfliteModel _model;
  
  @override
  Future<dynamic> predict(Map<String, dynamic> input) async {
    final output = await _model.run(input);
    return _parseOutput(output);
  }
}

class SentimentModel implements MlModel {
  final GoogleMlSentiment _mlKit;
  
  @override
  Future<dynamic> predict(Map<String, dynamic> input) async {
    final result = await _mlKit.analyzeText(input['text']);
    return {
      'label': result.sentiment,
      'score': result.score,
      'emotions': result.emotions,
    };
  }
}

class PiiDetectionModel implements MlModel {
  final TfliteModel _model;
  final List<RegexPattern> _patterns;
  
  @override
  Future<dynamic> predict(Map<String, dynamic> input) async {
    final text = input['text'];
    
    // Use regex patterns first
    final regexMatches = _detectWithRegex(text);
    
    // Use ML model for complex cases
    final mlMatches = await _model.run({'text': text});
    
    return {
      'regex': regexMatches,
      'ml': mlMatches,
    };
  }
}
```

## API Integration

### New API Endpoints

```dart
// lib/features/ai/data/datasources/

class AiRemoteDataSource {
  final Dio dio;
  
  Future<AiGeneratedFormDto> generateForm(String prompt) async {
    final response = await dio.post(
      '/api/ai/generate-form',
      data: {'prompt': prompt},
    );
    return AiGeneratedFormDto.fromJson(response.data);
  }
  
  Future<AiGeneratedFormDto> importDocument(File document) async {
    final formData = await FormData.fromMap({
      'document': await MultipartFile.fromFile(document.path),
    });
    
    final response = await dio.post(
      '/api/ai/import-document',
      data: formData,
    );
    return AiGeneratedFormDto.fromJson(response.data);
  }
  
  Future<Map<String, dynamic>> getAutoFillSuggestions({
    required String formId,
    required String userId,
  }) async {
    final response = await dio.get(
      '/api/ai/autofill-suggestions',
      queryParameters: {'formId': formId, 'userId': userId},
    );
    return response.data;
  }
  
  Future<SentimentAnalysisDto> analyzeSentiment({
    required String responseId,
  }) async {
    final response = await dio.post(
      '/api/ai/analyze-sentiment',
      data: {'responseId': responseId},
    );
    return SentimentAnalysisDto.fromJson(response.data);
  }
  
  Future<PiiDetectionDto> detectPii({
    required String responseId,
  }) async {
    final response = await dio.post(
      '/api/ai/detect-pii',
      data: {'responseId': responseId},
    );
    return PiiDetectionDto.fromJson(response.data);
  }
}
```

## State Management

### New Riverpod Providers

```dart
// lib/features/ai/presentation/providers/

@riverpod
class AiFormGeneratorController extends _$AiFormGeneratorController {
  @override
  Future<AiGeneratedForm?> build() => null;
  
  Future<void> generateForm(String prompt) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(aiServiceRepositoryProvider);
      return repository.generateForm(prompt);
    });
  }
}

@riverpod
class AutoFillController extends _$AutoFillController {
  @override
  Future<Map<String, dynamic>> build(String formId) => {};
  
  Future<void> loadSuggestions({
    required String formId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(aiServiceRepositoryProvider);
      return repository.getAutoFillSuggestions(
        formId: formId,
        userId: userId,
      );
    });
  }
}

@riverpod
class SentimentAnalysisController extends _$SentimentAnalysisController {
  @override
  Future<SentimentAnalysis?> build(String responseId) => null;
  
  Future<void> analyzeSentiment(String responseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(nlpRepositoryProvider);
      return repository.analyzeSentiment(
        responseId: responseId,
        responseData: await _getResponseData(responseId),
      );
    });
  }
}
```

## Privacy and Security

### Data Anonymization

```dart
// lib/features/ai/domain/services/

class DataAnonymizationService {
  Future<Map<String, dynamic>> anonymizeData({
    required Map<String, dynamic> data,
    required AnonymizationLevel level,
  }) async {
    final anonymized = <String, dynamic>{};
    
    for (final entry in data.entries) {
      final value = entry.value;
      
      if (value is String) {
        anonymized[entry.key] = await _anonymizeText(value, level);
      } else if (value is Map) {
        anonymized[entry.key] = await anonymizeData(
          data: value,
          level: level,
        );
      } else {
        anonymized[entry.key] = value;
      }
    }
    
    return anonymized;
  }
  
  Future<String> _anonymizeText(String text, AnonymizationLevel level) async {
    switch (level) {
      case AnonymizationLevel.none:
        return text;
      case AnonymizationLevel.basic:
        return _basicAnonymization(text);
      case AnonymizationLevel.full:
        return await _fullAnonymization(text);
    }
  }
}
```

## Deployment Considerations

### Backend Requirements

1. **ML Model Serving**
   - TensorFlow Serving or ONNX Runtime
   - Model versioning and A/B testing
   - GPU acceleration for training

2. **NLP Infrastructure**
   - Text preprocessing pipeline
   - Feature extraction
   - Model inference optimization

3. **Document Processing**
   - PDF parsing service
   - OCR for scanned documents
   - Document structure extraction

4. **Model Training Pipeline**
   - Automated training workflows
   - Model evaluation and validation
   - Continuous model improvement

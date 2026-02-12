# API Client Usage Examples

This document provides practical examples of using the API client service in your Flutter application.

## Table of Contents

1. [Setup and Configuration](#setup-and-configuration)
2. [Authentication Examples](#authentication-examples)
3. [Form Management Examples](#form-management-examples)
4. [Response Submission Examples](#response-submission-examples)
5. [Error Handling Examples](#error-handling-examples)
6. [Advanced Usage](#advanced-usage)

## Setup and Configuration

### Import Required Packages

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:frontend/core/services/token_storage_service.dart';
```

### Access the API Service

```dart
// In a ConsumerWidget or ConsumerStatefulWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.watch(apiServiceProvider);

    // Use apiService for API calls
    return Container();
  }
}
```

## Authentication Examples

### Example 1: Login with Email and Password

```dart
Future<void> loginWithEmail(
  WidgetRef ref,
  String email,
  String password,
) async {
  final apiService = ref.read(apiServiceProvider);
  final tokenStorage = ref.read(tokenStorageServiceProvider);

  try {
    // Call login API
    final result = await apiService.login(
      identifier: email,
      password: password,
    );

    // Extract tokens from response
    final accessToken = result['access_token'] as String;
    final refreshToken = result['refresh_token'] as String?;
    final user = result['user'] as Map<String, dynamic>;

    // Save tokens securely
    await tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: 3600, // 1 hour
      userId: user['id'] as String,
    );

    print('Login successful! User: ${user['username']}');
  } catch (e) {
    print('Login failed: $e');
    // Error already shown to user via snackbar
  }
}
```

### Example 2: Login with Mobile OTP

```dart
// Step 1: Generate OTP
Future<void> sendOtp(WidgetRef ref, String mobile) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    await apiService.generateOtp(mobile);
    print('OTP sent to $mobile');
  } catch (e) {
    print('Failed to send OTP: $e');
  }
}

// Step 2: Login with OTP
Future<void> loginWithOtp(
  WidgetRef ref,
  String mobile,
  String otp,
) async {
  final apiService = ref.read(apiServiceProvider);
  final tokenStorage = ref.read(tokenStorageServiceProvider);

  try {
    final result = await apiService.loginWithOtp(
      mobile: mobile,
      otp: otp,
    );

    final accessToken = result['access_token'] as String;
    final refreshToken = result['refresh_token'] as String?;

    await tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: 3600,
    );

    print('OTP login successful!');
  } catch (e) {
    print('OTP login failed: $e');
  }
}
```

### Example 3: Register New User

```dart
Future<void> registerUser(WidgetRef ref, {
  required String username,
  required String email,
  required String password,
  required String mobile,
}) async {
  final apiService = ref.read(apiServiceProvider);
  final tokenStorage = ref.read(tokenStorageServiceProvider);

  try {
    final result = await apiService.register(
      username: username,
      email: email,
      password: password,
      userType: 'general',
      mobile: mobile,
      roles: ['user', 'creator', 'editor'],
    );

    // User is automatically logged in after registration
    final accessToken = result['access_token'] as String;
    final refreshToken = result['refresh_token'] as String?;

    await tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: 3600,
    );

    print('Registration successful!');
  } catch (e) {
    print('Registration failed: $e');
  }
}
```

### Example 4: Check if User is Logged In

```dart
Future<bool> isUserLoggedIn(WidgetRef ref) async {
  final tokenStorage = ref.read(tokenStorageServiceProvider);

  // Check if valid tokens exist
  final hasValidTokens = await tokenStorage.hasValidTokens();

  if (hasValidTokens) {
    // Optionally verify with backend
    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.getUserStatus();
      return true;
    } catch (e) {
      // Token might be invalid, clear it
      await tokenStorage.clearTokens();
      return false;
    }
  }

  return false;
}
```

### Example 5: Logout

```dart
Future<void> logout(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);
  final tokenStorage = ref.read(tokenStorageServiceProvider);

  try {
    // Call logout API
    await apiService.logout();
  } catch (e) {
    print('Logout API call failed: $e');
    // Continue with local cleanup even if API fails
  }

  // Clear tokens locally
  await tokenStorage.clearTokens();

  print('Logged out successfully');
}
```

## Form Management Examples

### Example 6: List All Forms

```dart
Future<void> loadForms(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final forms = await apiService.listForms(
      page: 1,
      limit: 20,
      status: 'published',
    );

    print('Loaded ${forms.length} forms');

    for (var form in forms) {
      print('Form: ${form['title']} (${form['status']})');
    }
  } catch (e) {
    print('Failed to load forms: $e');
  }
}
```

### Example 7: Get Single Form

```dart
Future<Map<String, dynamic>?> loadFormDetails(
  WidgetRef ref,
  String formId,
) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final form = await apiService.getForm(formId);

    print('Loaded form: ${form['title']}');
    print('Sections: ${form['sections'].length}');

    return form;
  } catch (e) {
    print('Failed to load form: $e');
    return null;
  }
}
```

### Example 8: Create New Form

```dart
Future<String?> createNewForm(
  WidgetRef ref, {
  required String title,
  required List<Map<String, dynamic>> sections,
}) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final result = await apiService.createForm(
      title: title,
      sections: sections,
      status: 'draft',
      version: '1.0',
    );

    final formId = result['id'] as String;
    print('Form created successfully! ID: $formId');

    return formId;
  } catch (e) {
    print('Failed to create form: $e');
    return null;
  }
}
```

### Example 9: Update Existing Form

```dart
Future<bool> updateForm(
  WidgetRef ref, {
  required String formId,
  required String title,
  required List<Map<String, dynamic>> sections,
}) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    await apiService.updateForm(
      formId: formId,
      title: title,
      sections: sections,
      status: 'draft',
      version: '1.1',
    );

    print('Form updated successfully!');
    return true;
  } catch (e) {
    print('Failed to update form: $e');
    return false;
  }
}
```

### Example 10: Publish Form

```dart
Future<bool> publishForm(WidgetRef ref, String formId) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final result = await apiService.publishForm(formId);

    print('Form published! Status: ${result['form']['status']}');
    return true;
  } catch (e) {
    print('Failed to publish form: $e');
    return false;
  }
}
```

### Example 11: Delete Form

```dart
Future<bool> deleteForm(WidgetRef ref, String formId) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    await apiService.deleteForm(formId);

    print('Form deleted successfully!');
    return true;
  } catch (e) {
    print('Failed to delete form: $e');
    return false;
  }
}
```

### Example 12: Clone Form

```dart
Future<String?> cloneForm(
  WidgetRef ref,
  String originalFormId,
  String newTitle,
) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final result = await apiService.cloneForm(
      formId: originalFormId,
      newTitle: newTitle,
    );

    final newFormId = result['id'] as String;
    print('Form cloned successfully! New ID: $newFormId');

    return newFormId;
  } catch (e) {
    print('Failed to clone form: $e');
    return null;
  }
}
```

## Response Submission Examples

### Example 13: Submit Form Response

```dart
Future<String?> submitFormResponse(
  WidgetRef ref, {
  required String formId,
  required Map<String, dynamic> responses,
  required String userId,
}) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final result = await apiService.submitResponse(
      formId: formId,
      responses: responses,
      submittedBy: userId,
      metadata: {
        'device': 'mobile',
        'app_version': '1.0.0',
        'submitted_at': DateTime.now().toIso8601String(),
      },
    );

    final responseId = result['id'] as String;
    print('Response submitted! ID: $responseId');

    return responseId;
  } catch (e) {
    print('Failed to submit response: $e');
    return null;
  }
}
```

### Example 14: List Form Responses

```dart
Future<void> loadFormResponses(
  WidgetRef ref,
  String formId,
) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final responses = await apiService.listResponses(
      formId: formId,
      page: 1,
      limit: 50,
    );

    print('Loaded ${responses.length} responses');

    for (var response in responses) {
      print('Response ID: ${response['id']}');
      print('Submitted by: ${response['submitted_by']}');
      print('Submitted at: ${response['submitted_at']}');
    }
  } catch (e) {
    print('Failed to load responses: $e');
  }
}
```

### Example 15: Export Responses

```dart
Future<void> exportResponses(
  WidgetRef ref,
  String formId,
) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final data = await apiService.exportResponses(
      formId: formId,
      format: 'json', // or 'csv', 'excel'
    );

    print('Responses exported successfully!');
    // Process exported data (save to file, share, etc.)
  } catch (e) {
    print('Failed to export responses: $e');
  }
}
```

## Error Handling Examples

### Example 16: Comprehensive Error Handling

```dart
Future<void> performApiCall(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final forms = await apiService.listForms();
    print('Success: Loaded ${forms.length} forms');
  } on DioException catch (e) {
    // Handle Dio-specific errors
    if (e.response?.statusCode == 401) {
      print('Authentication error - user will be redirected to login');
    } else if (e.response?.statusCode == 403) {
      print('Permission denied');
    } else if (e.response?.statusCode == 404) {
      print('Resource not found');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      print('Connection timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      print('No internet connection');
    } else {
      print('API error: ${e.message}');
    }
  } catch (e) {
    // Handle other errors
    print('Unexpected error: $e');
  }
}
```

### Example 17: Retry Logic Usage

```dart
Future<void> loadWithRetry(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);

  // RetryInterceptor will automatically retry on network failures
  // You don't need to implement retry logic yourself
  try {
    final forms = await apiService.listForms();
    print('Loaded forms (with automatic retry on failure)');
  } catch (e) {
    // This will only be thrown after all retries are exhausted
    print('Failed even after retries: $e');
  }
}
```

### Example 18: Handling Token Expiry

```dart
Future<void> makeAuthenticatedCall(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);

  // AuthInterceptor will automatically refresh token if it expires
  // You don't need to check token expiry yourself
  try {
    final forms = await apiService.listForms();
    print('Loaded forms (token refreshed automatically if needed)');
  } catch (e) {
    // If token refresh fails, user will be redirected to login
    print('Authentication failed: $e');
  }
}
```

## Advanced Usage

### Example 19: Request Cancellation

```dart
class FormListController {
  CancelToken? _cancelToken;

  Future<void> loadForms(WidgetRef ref) async {
    final apiService = ref.read(apiServiceProvider);

    // Cancel previous request if still running
    _cancelToken?.cancel('New request started');

    // Create new cancel token
    _cancelToken = CancelToken();

    try {
      final forms = await apiService.listForms();
      print('Forms loaded');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        print('Request cancelled');
      } else {
        print('Error: $e');
      }
    }
  }

  void dispose() {
    _cancelToken?.cancel('Controller disposed');
  }
}
```

### Example 20: Progress Tracking for File Upload

```dart
Future<void> uploadFile(WidgetRef ref, File file) async {
  final apiService = ref.read(apiServiceProvider);

  // Create FormData
  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
  });

  try {
    final result = await apiService.uploadFile(formData);

    final fileUrl = result['url'] as String;
    print('File uploaded successfully! URL: $fileUrl');
  } catch (e) {
    print('Upload failed: $e');
  }
}
```

### Example 21: Batch Operations

```dart
Future<void> bulkUpdateForms(
  WidgetRef ref,
  List<String> formIds,
  String newStatus,
) async {
  final apiService = ref.read(apiServiceProvider);

  final results = await Future.wait(
    formIds.map((id) async {
      try {
        // Get form
        final form = await apiService.getForm(id);

        // Update status
        await apiService.updateForm(
          formId: id,
          title: form['title'] as String,
          sections: form['sections'] as List<Map<String, dynamic>>,
          status: newStatus,
        );

        return {'id': id, 'success': true};
      } catch (e) {
        return {'id': id, 'success': false, 'error': e.toString()};
      }
    }),
  );

  final successful = results.where((r) => r['success'] == true).length;
  print('Updated $successful out of ${formIds.length} forms');
}
```

### Example 22: Checking API Health

```dart
Future<bool> checkApiHealth(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final health = await apiService.healthCheck();

    final status = health['status'] as String;
    final version = health['version'] as String;

    print('API Status: $status (v$version)');
    return status == 'ok';
  } catch (e) {
    print('API health check failed: $e');
    return false;
  }
}
```

### Example 23: Custom Timeout for Specific Request

```dart
Future<void> loadLargeDataset(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);

  // For requests that might take longer than default timeout
  // You can use a custom timeout by accessing the underlying client
  try {
    final forms = await apiService.listForms(limit: 1000);
    print('Loaded large dataset');
  } catch (e) {
    print('Failed to load large dataset: $e');
  }
}
```

### Example 24: Analytics Dashboard Integration

```dart
Future<Map<String, dynamic>> loadDashboardData(WidgetRef ref) async {
  final apiService = ref.read(apiServiceProvider);

  try {
    // Load dashboard stats
    final stats = await apiService.getDashboardStats();

    // Load forms
    final forms = await apiService.listForms(limit: 10);

    // Load recent responses
    final responses = await apiService.listResponses(limit: 10);

    return {
      'stats': stats,
      'recentForms': forms,
      'recentResponses': responses,
    };
  } catch (e) {
    print('Failed to load dashboard data: $e');
    rethrow;
  }
}
```

### Example 25: Form Builder Integration

```dart
class FormBuilderController {
  Future<void> saveFormDraft(
    WidgetRef ref,
    String? formId,
    String title,
    List<Map<String, dynamic>> sections,
  ) async {
    final apiService = ref.read(apiServiceProvider);

    try {
      if (formId == null || formId.isEmpty) {
        // Create new form
        final result = await apiService.createForm(
          title: title,
          sections: sections,
          status: 'draft',
        );

        formId = result['id'] as String;
        print('Draft saved as new form: $formId');
      } else {
        // Update existing form
        await apiService.updateForm(
          formId: formId,
          title: title,
          sections: sections,
          status: 'draft',
        );

        print('Draft updated: $formId');
      }
    } catch (e) {
      print('Failed to save draft: $e');
      rethrow;
    }
  }
}
```

## Tips and Best Practices

1. **Always use try-catch**: Wrap API calls in try-catch blocks
2. **Use ApiService**: Don't access Dio directly, use the ApiService wrapper
3. **Let interceptors work**: Don't manually handle auth or retries
4. **Cancel long operations**: Use CancelToken for operations that can be cancelled
5. **Check connectivity**: Use ConnectivityService before making requests in offline-first scenarios
6. **Log errors appropriately**: Use logger for debugging, but don't expose sensitive data
7. **Handle loading states**: Show loading indicators while API calls are in progress
8. **Test error scenarios**: Test your app with no internet, slow connections, and server errors

## Common Patterns

### Pattern 1: Load Data on Widget Init

```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Load data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final apiService = ref.read(apiServiceProvider);

    try {
      final data = await apiService.listForms();
      // Update state
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Pattern 2: Refresh Data on Pull-to-Refresh

```dart
Future<void> _handleRefresh() async {
  final apiService = ref.read(apiServiceProvider);

  try {
    final data = await apiService.listForms();
    // Update state
  } catch (e) {
    // Error already shown via snackbar
  }
}

Widget build(BuildContext context) {
  return RefreshIndicator(
    onRefresh: _handleRefresh,
    child: ListView(...),
  );
}
```

### Pattern 3: Pagination

```dart
class PaginatedListController {
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  Future<void> loadMore(WidgetRef ref) async {
    if (!_hasMore) return;

    final apiService = ref.read(apiServiceProvider);

    try {
      final items = await apiService.listForms(
        page: _currentPage,
        limit: _pageSize,
      );

      if (items.length < _pageSize) {
        _hasMore = false;
      }

      _currentPage++;
      // Add items to list
    } catch (e) {
      print('Failed to load more: $e');
    }
  }
}
```

## Conclusion

This comprehensive guide covers all major use cases for the API client. For more details on specific endpoints, refer to `api_endpoints.dart`. For implementation details, check the README.md file in this directory.

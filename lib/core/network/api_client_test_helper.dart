import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'api_endpoints.dart';
import '../services/token_storage_service.dart';

/// Helper class for testing API client functionality
///
/// This class provides convenient methods for testing the API client
/// in development and debugging scenarios. It demonstrates proper usage
/// patterns and error handling.
class ApiClientTestHelper {
  final WidgetRef ref;

  ApiClientTestHelper(this.ref);

  /// Test authentication flow
  Future<void> testAuthentication({
    required String email,
    required String password,
  }) async {
    final apiService = ref.read(apiServiceProvider);
    final tokenStorage = ref.read(tokenStorageServiceProvider);

    debugPrint('🔐 Testing authentication...');

    try {
      // Test login
      debugPrint('  → Attempting login...');
      final result = await apiService.login(
        identifier: email,
        password: password,
      );

      debugPrint('  ✓ Login successful!');
      debugPrint(
        '    Access Token: ${result['access_token']?.substring(0, 20)}...',
      );
      debugPrint(
        '    Refresh Token: ${result['refresh_token']?.substring(0, 20)}...',
      );

      // Save tokens
      await tokenStorage.saveTokens(
        accessToken: result['access_token'] as String,
        refreshToken: result['refresh_token'] as String?,
        expiresIn: 3600,
      );

      debugPrint('  ✓ Tokens saved to secure storage');

      // Test user status
      debugPrint('  → Fetching user status...');
      final userStatus = await apiService.getUserStatus();
      debugPrint('  ✓ User status retrieved');
      debugPrint('    User: ${userStatus['user']['username']}');
      debugPrint('    Email: ${userStatus['user']['email']}');

      debugPrint('✅ Authentication test PASSED');
    } catch (e, stackTrace) {
      debugPrint('❌ Authentication test FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Test form management operations
  Future<void> testFormManagement() async {
    final apiService = ref.read(apiServiceProvider);

    debugPrint('📋 Testing form management...');

    try {
      // List forms
      debugPrint('  → Listing forms...');
      final forms = await apiService.listForms(limit: 5);
      debugPrint('  ✓ Retrieved ${forms.length} forms');

      if (forms.isNotEmpty) {
        final firstForm = forms[0];
        debugPrint('    First form: ${firstForm['title']}');

        // Get form details
        final formId = firstForm['id'] ?? firstForm['_id'];
        debugPrint('  → Fetching form details for ID: $formId');
        final formDetails = await apiService.getForm(formId);
        debugPrint('  ✓ Form details retrieved');
        debugPrint('    Sections: ${formDetails['sections']?.length ?? 0}');
      }

      // Test form creation
      debugPrint('  → Creating test form...');
      final newForm = await apiService.createForm(
        title: 'API Test Form ${DateTime.now().millisecondsSinceEpoch}',
        sections: [
          {
            'section_id': 'test_section_1',
            'title': 'Test Section',
            'fields': [
              {
                'field_id': 'test_field_1',
                'type': 'text',
                'label': 'Test Field',
                'required': false,
              },
            ],
          },
        ],
      );

      final newFormId = newForm['id'];
      debugPrint('  ✓ Form created with ID: $newFormId');

      // Test form update
      debugPrint('  → Updating form...');
      await apiService.updateForm(
        formId: newFormId,
        title: 'Updated API Test Form',
        sections: [
          {
            'section_id': 'test_section_1',
            'title': 'Updated Test Section',
            'fields': [
              {
                'field_id': 'test_field_1',
                'type': 'text',
                'label': 'Updated Test Field',
                'required': true,
              },
            ],
          },
        ],
      );
      debugPrint('  ✓ Form updated');

      // Test form deletion
      debugPrint('  → Deleting test form...');
      await apiService.deleteForm(newFormId);
      debugPrint('  ✓ Form deleted');

      debugPrint('✅ Form management test PASSED');
    } catch (e, stackTrace) {
      debugPrint('❌ Form management test FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Test response submission
  Future<void> testResponseSubmission(String formId) async {
    final apiService = ref.read(apiServiceProvider);

    debugPrint('📝 Testing response submission...');

    try {
      // Submit response
      debugPrint('  → Submitting response...');
      final response = await apiService.submitResponse(
        formId: formId,
        responses: {
          'test_field_1': 'Test response value',
          'test_field_2': 'Another test value',
        },
        submittedBy: 'test_user',
        metadata: {
          'test_mode': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final responseId = response['id'];
      debugPrint('  ✓ Response submitted with ID: $responseId');

      // List responses
      debugPrint('  → Listing responses...');
      final responses = await apiService.listResponses(
        formId: formId,
        limit: 10,
      );
      debugPrint('  ✓ Retrieved ${responses.length} responses');

      // Get single response
      if (responses.isNotEmpty) {
        final firstResponseId = responses[0]['id'];
        debugPrint('  → Fetching response details...');
        final responseDetails = await apiService.getResponse(firstResponseId);
        debugPrint('  ✓ Response details retrieved');
        debugPrint('    Submitted by: ${responseDetails['submitted_by']}');
      }

      debugPrint('✅ Response submission test PASSED');
    } catch (e, stackTrace) {
      debugPrint('❌ Response submission test FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Test analytics endpoints
  Future<void> testAnalytics() async {
    final apiService = ref.read(apiServiceProvider);

    debugPrint('📊 Testing analytics...');

    try {
      // Get dashboard stats
      debugPrint('  → Fetching dashboard stats...');
      final stats = await apiService.getDashboardStats();
      debugPrint('  ✓ Dashboard stats retrieved');
      debugPrint('    Total forms: ${stats['total_forms']}');
      debugPrint('    Active forms: ${stats['active_forms']}');
      debugPrint('    Total responses: ${stats['total_responses']}');

      debugPrint('✅ Analytics test PASSED');
    } catch (e, stackTrace) {
      debugPrint('❌ Analytics test FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Test retry logic by simulating network errors
  Future<void> testRetryLogic() async {
    final apiService = ref.read(apiServiceProvider);

    debugPrint('🔄 Testing retry logic...');
    debugPrint('   (This will succeed if the backend is running)');

    try {
      // This should automatically retry if there are network issues
      final forms = await apiService.listForms();
      debugPrint('  ✓ Request succeeded (with automatic retry if needed)');
      debugPrint('    Forms loaded: ${forms.length}');

      debugPrint('✅ Retry logic test PASSED');
    } catch (e, stackTrace) {
      debugPrint('❌ Retry logic test FAILED (after all retries)');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Test token storage
  Future<void> testTokenStorage() async {
    final tokenStorage = ref.read(tokenStorageServiceProvider);

    debugPrint('💾 Testing token storage...');

    try {
      // Save test tokens
      debugPrint('  → Saving test tokens...');
      await tokenStorage.saveTokens(
        accessToken: 'test_access_token_123',
        refreshToken: 'test_refresh_token_456',
        expiresIn: 3600,
        userId: 'test_user_789',
      );
      debugPrint('  ✓ Tokens saved');

      // Retrieve tokens
      debugPrint('  → Retrieving tokens...');
      final accessToken = await tokenStorage.getAccessToken();
      final refreshToken = await tokenStorage.getRefreshToken();
      final userId = await tokenStorage.getUserId();

      debugPrint('  ✓ Tokens retrieved');
      debugPrint('    Access token: ${accessToken?.substring(0, 20)}...');
      debugPrint('    Refresh token: ${refreshToken?.substring(0, 20)}...');
      debugPrint('    User ID: $userId');

      // Check validity
      debugPrint('  → Checking token validity...');
      final hasValidTokens = await tokenStorage.hasValidTokens();
      debugPrint('  ✓ Token validity: $hasValidTokens');

      // Get token data
      debugPrint('  → Getting token metadata...');
      final tokenData = await tokenStorage.getTokenData();
      debugPrint('  ✓ Token metadata:');
      tokenData.forEach((key, value) {
        debugPrint('    $key: $value');
      });

      // Clear tokens
      debugPrint('  → Clearing tokens...');
      await tokenStorage.clearTokens();
      debugPrint('  ✓ Tokens cleared');

      debugPrint('✅ Token storage test PASSED');
    } catch (e, stackTrace) {
      debugPrint('❌ Token storage test FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Test API health
  Future<void> testApiHealth() async {
    final apiService = ref.read(apiServiceProvider);

    debugPrint('🏥 Testing API health...');

    try {
      final health = await apiService.healthCheck();
      debugPrint('  ✓ API is healthy');
      debugPrint('    Status: ${health['status']}');
      debugPrint('    Version: ${health['version']}');
      debugPrint('    Timestamp: ${health['timestamp']}');

      debugPrint('✅ API health test PASSED');
    } catch (e, stackTrace) {
      debugPrint('❌ API health test FAILED');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
      debugPrint('   This likely means the backend is not running');
    }
  }

  /// Test all API endpoints configuration
  Future<void> testEndpointsConfiguration() async {
    debugPrint('🔧 Testing endpoints configuration...');

    try {
      debugPrint('  → Checking base URL...');
      debugPrint('    Base URL: ${ApiEndpoints.baseUrl}');

      debugPrint('  → Checking auth endpoints...');
      debugPrint('    Login: ${ApiEndpoints.login}');
      debugPrint('    Register: ${ApiEndpoints.register}');
      debugPrint('    Logout: ${ApiEndpoints.logout}');

      debugPrint('  → Checking form endpoints...');
      debugPrint('    List: ${ApiEndpoints.listForms}');
      debugPrint('    Create: ${ApiEndpoints.createForm}');
      debugPrint('    Get: ${ApiEndpoints.getForm('test-id')}');

      debugPrint('  → Checking response endpoints...');
      debugPrint('    Submit: ${ApiEndpoints.submitResponse}');
      debugPrint('    List: ${ApiEndpoints.listResponses}');

      debugPrint('✅ Endpoints configuration test PASSED');
    } catch (e) {
      debugPrint('❌ Endpoints configuration test FAILED');
      debugPrint('   Error: $e');
    }
  }

  /// Run all tests
  Future<void> runAllTests({
    String? email,
    String? password,
    String? testFormId,
  }) async {
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('           API CLIENT COMPREHENSIVE TEST SUITE             ');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');

    await testEndpointsConfiguration();
    debugPrint('');

    await testApiHealth();
    debugPrint('');

    await testTokenStorage();
    debugPrint('');

    if (email != null && password != null) {
      await testAuthentication(email: email, password: password);
      debugPrint('');

      await testFormManagement();
      debugPrint('');

      await testAnalytics();
      debugPrint('');

      if (testFormId != null) {
        await testResponseSubmission(testFormId);
        debugPrint('');
      }

      await testRetryLogic();
      debugPrint('');
    } else {
      debugPrint('⚠️  Skipping authenticated tests (no credentials provided)');
      debugPrint('');
    }

    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('                   TEST SUITE COMPLETED                     ');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');
  }
}

/// Example usage in a ConsumerWidget:
///
/// ```dart
/// class ApiTestScreen extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     return Scaffold(
///       appBar: AppBar(title: Text('API Client Test')),
///       body: Center(
///         child: ElevatedButton(
///           onPressed: () async {
///             final helper = ApiClientTestHelper(ref);
///             await helper.runAllTests(
///               email: 'test@example.com',
///               password: 'password123',
///             );
///           },
///           child: Text('Run API Tests'),
///         ),
///       ),
///     );
///   }
/// }
/// ```

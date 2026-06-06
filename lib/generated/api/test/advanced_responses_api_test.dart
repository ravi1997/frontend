import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AdvancedResponsesApi
void main() {
  final instance = RidpApi().getAdvancedResponsesApi();

  group(AdvancedResponsesApi, () {
    // Fetch data from another form response where some question may have match for a value. Query Params: form_id, question_id, value
    //
    //Future formApiV1FormsFetchExternalGet() async
    test('test formApiV1FormsFetchExternalGet', () async {
      // TODO
    });

    // User access control for a forms. Returns a detailed JSON report of the current user's permissions.
    //
    //Future formApiV1FormsFormIdAccessControlGet(String formId) async
    test('test formApiV1FormsFormIdAccessControlGet', () async {
      // TODO
    });

    // Management route to update the Access Policy for a form. Requires 'manage_access' permission.
    //
    //Future formApiV1FormsFormIdAccessPolicyPost(String formId) async
    test('test formApiV1FormsFormIdAccessPolicyPost', () async {
      // TODO
    });

    // Management route to update the Access Policy for a form. Requires 'manage_access' permission.
    //
    //Future formApiV1FormsFormIdAccessPolicyPut(String formId) async
    test('test formApiV1FormsFormIdAccessPolicyPut', () async {
      // TODO
    });

    // Fetch data from same form response where some question may have match for a value. Query Params: question_id, value
    //
    //Future formApiV1FormsFormIdFetchSameGet(String formId) async
    test('test formApiV1FormsFormIdFetchSameGet', () async {
      // TODO
    });

    // Fetching meta information about a form response like number of response etc.
    //
    //Future formApiV1FormsFormIdResponsesMetaGet(String formId) async
    test('test formApiV1FormsFormIdResponsesMetaGet', () async {
      // TODO
    });

    // Fetching particular questions responses from a form only. Query Params: question_ids (comma separated)
    //
    //Future formApiV1FormsFormIdResponsesQuestionsGet(String formId) async
    test('test formApiV1FormsFormIdResponsesQuestionsGet', () async {
      // TODO
    });

    // Compatibility endpoint for the dashboard client.  The Flutter dashboard expects GET /form/api/v1/forms/, so we expose a tenant-scoped listing here that mirrors the newer form listing behavior.
    //
    //Future formApiV1FormsGet() async
    test('test formApiV1FormsGet', () async {
      // TODO
    });

  });
}

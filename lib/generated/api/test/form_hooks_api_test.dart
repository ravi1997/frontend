import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for FormHooksApi
void main() {
  final instance = RidpApi().getFormHooksApi();

  group(FormHooksApi, () {
    // Approve or reject a registered external hook (Admin only)
    //
    //Future formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(String hookId, { FormApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest body }) async
    test('test formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost', () async {
      // TODO
    });

    // Register a new external hook for approval
    //
    //Future formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost({ FormApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest body }) async
    test('test formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost', () async {
      // TODO
    });

    // Synchronously trigger all top-level hooks for a form
    //
    //Future formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost(String formId, { Object body }) async
    test('test formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost', () async {
      // TODO
    });

    // Synchronously trigger all hooks for a question
    //
    //Future formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost(String formId, String questionId, { Object body }) async
    test('test formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost', () async {
      // TODO
    });

  });
}

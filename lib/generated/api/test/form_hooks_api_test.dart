import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for FormHooksApi
void main() {
  final instance = RidpApi().getFormHooksApi();

  group(FormHooksApi, () {
    // Approve or reject a registered external hook (Admin only)
    //
    //Future formApiV1FormsExternalHooksHookIdApprovePost(String hookId, { FormApiV1FormsExternalHooksHookIdApprovePostRequest body }) async
    test('test formApiV1FormsExternalHooksHookIdApprovePost', () async {
      // TODO
    });

    // Register a new external hook for approval
    //
    //Future formApiV1FormsExternalHooksRegisterPost({ FormApiV1FormsExternalHooksRegisterPostRequest body }) async
    test('test formApiV1FormsExternalHooksRegisterPost', () async {
      // TODO
    });

    // Synchronously trigger all top-level hooks for a form
    //
    //Future formApiV1FormsFormIdHooksTriggerPost(String formId, { Object body }) async
    test('test formApiV1FormsFormIdHooksTriggerPost', () async {
      // TODO
    });

    // Synchronously trigger all hooks for a question
    //
    //Future formApiV1FormsFormIdQuestionsQuestionIdHooksTriggerPost(String formId, String questionId, { Object body }) async
    test('test formApiV1FormsFormIdQuestionsQuestionIdHooksTriggerPost', () async {
      // TODO
    });

    // Approve or reject a registered external hook (Admin only)
    //
    //Future formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(String hookId, { FormApiV1FormsExternalHooksHookIdApprovePostRequest body }) async
    test('test formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost', () async {
      // TODO
    });

    // Register a new external hook for approval
    //
    //Future formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost({ FormApiV1FormsExternalHooksRegisterPostRequest body }) async
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

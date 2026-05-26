import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for ProjectHooksApi
void main() {
  final instance = RidpApi().getProjectHooksApi();

  group(ProjectHooksApi, () {
    // Synchronously trigger all hooks for a project
    //
    //Future formApiV1FormsHooksTriggerPost(String projectId, { Object body }) async
    test('test formApiV1FormsHooksTriggerPost', () async {
      // TODO
    });

    // Synchronously trigger all hooks for a project
    //
    //Future formApiV1ProjectsProjectIdFormsHooksTriggerPost(String projectId, { Object body }) async
    test('test formApiV1ProjectsProjectIdFormsHooksTriggerPost', () async {
      // TODO
    });

  });
}

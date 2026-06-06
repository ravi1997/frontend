import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for SectionHooksApi
void main() {
  final instance = RidpApi().getSectionHooksApi();

  group(SectionHooksApi, () {
    // Synchronously trigger all hooks for a section
    //
    //Future formApiV1ProjectsProjectIdFormsFormIdSectionsSectionIdHooksTriggerPost(String formId, String sectionId, { Object body }) async
    test('test formApiV1ProjectsProjectIdFormsFormIdSectionsSectionIdHooksTriggerPost', () async {
      // TODO
    });

  });
}

import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for WorkflowApi
void main() {
  final instance = RidpApi().getWorkflowApi();

  group(WorkflowApi, () {
    // List all workflows for the current organization.
    //
    //Future formApiV1WorkflowsGet() async
    test('test formApiV1WorkflowsGet', () async {
      // TODO
    });

    // Create a new multi-step approval workflow.
    //
    //Future formApiV1WorkflowsPost() async
    test('test formApiV1WorkflowsPost', () async {
      // TODO
    });

    // Soft-delete a workflow.
    //
    //Future formApiV1WorkflowsWorkflowIdDelete(String workflowId) async
    test('test formApiV1WorkflowsWorkflowIdDelete', () async {
      // TODO
    });

    // Get detailed workflow definition.
    //
    //Future formApiV1WorkflowsWorkflowIdGet(String workflowId) async
    test('test formApiV1WorkflowsWorkflowIdGet', () async {
      // TODO
    });

    // Update an existing workflow.
    //
    //Future formApiV1WorkflowsWorkflowIdPut(String workflowId) async
    test('test formApiV1WorkflowsWorkflowIdPut', () async {
      // TODO
    });

  });
}

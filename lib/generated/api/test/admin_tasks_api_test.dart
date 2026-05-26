import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AdminTasksApi
void main() {
  final instance = RidpApi().getAdminTasksApi();

  group(AdminTasksApi, () {
    // Get the status, progress, and results of any Celery task (admin only).
    //
    //Future formApiV1AdminTasksTaskIdGet(String taskId) async
    test('test formApiV1AdminTasksTaskIdGet', () async {
      // TODO
    });

  });
}

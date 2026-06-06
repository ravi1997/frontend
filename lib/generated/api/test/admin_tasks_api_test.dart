import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AdminTasksApi
void main() {
  final instance = RidpApi().getAdminTasksApi();

  group(AdminTasksApi, () {
    // Get the status, progress, and results of any Celery task (admin only).
    //
    //Future mahasangrahaApiV1AdminTasksTaskIdGet(String taskId) async
    test('test mahasangrahaApiV1AdminTasksTaskIdGet', () async {
      // TODO
    });

  });
}

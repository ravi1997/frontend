import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for TasksApi
void main() {
  final instance = RidpApi().getTasksApi();

  group(TasksApi, () {
    //Future formApiV1TasksTaskIdGet(String taskId) async
    test('test formApiV1TasksTaskIdGet', () async {
      // TODO
    });

  });
}

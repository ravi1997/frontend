import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for SystemApi
void main() {
  final instance = RidpApi().getSystemApi();

  group(SystemApi, () {
    // Returns submission trends from the OLAP engine.
    //
    //Future formApiV1SystemAnalyticsTrendsOrgIdGet(String orgId) async
    test('test formApiV1SystemAnalyticsTrendsOrgIdGet', () async {
      // TODO
    });

    // Returns metrics about the health of the internal event system. Includes consumer lag, DLQ sizes, and stream lengths.
    //
    //Future formApiV1SystemEventHealthGet() async
    test('test formApiV1SystemEventHealthGet', () async {
      // TODO
    });

    // Initiate GDPR compliance cleanup of soft-deleted records. This is an opt-in operation that permanently deletes records older than the retention period.
    //
    //Future formApiV1SystemGdprCleanupPost() async
    test('test formApiV1SystemGdprCleanupPost', () async {
      // TODO
    });

    // Get the status of an async Celery task. Supports polling for async_publish_form, async_clone_form, async_bulk_export, and async_process_translation_job.
    //
    //Future formApiV1SystemTasksTaskIdGet(String taskId) async
    test('test formApiV1SystemTasksTaskIdGet', () async {
      // TODO
    });

  });
}

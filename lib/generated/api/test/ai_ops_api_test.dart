import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AIOpsApi
void main() {
  final instance = RidpApi().getAIOpsApi();

  group(AIOpsApi, () {
    // Trigger the LoRA dataset building, validation, and training loop asynchronously.
    //
    //Future mahasangrahaApiV1AdminAiOpsLoraImprovePost({ MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest body }) async
    test('test mahasangrahaApiV1AdminAiOpsLoraImprovePost', () async {
      // TODO
    });

    // Retrieve current pipeline cycles, last execution timing, and performance scores.
    //
    //Future mahasangrahaApiV1AdminAiOpsLoraStatusGet() async
    test('test mahasangrahaApiV1AdminAiOpsLoraStatusGet', () async {
      // TODO
    });

  });
}

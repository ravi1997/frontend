import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/networking/api_client.dart';
import '../../../core/networking/dio_provider.dart';

class AIOpsRepository {
  AIOpsRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Retrieves the current status, cycle history, and metrics of the LoRA fine-tuning model loop.
  Future<Map<String, dynamic>> getLoraStatus() async {
    return _apiClient.getMap('/admin/ai-ops/lora/status');
  }

  /// Triggers the continuous improvement pipeline (dataset generation, validation, and Llama-Factory training).
  Future<Map<String, dynamic>> triggerImprovementLoop({
    int cycles = 1,
    int targetDatasetSize = 10000,
    bool fast = true,
  }) async {
    return _apiClient.postMap(
      '/admin/ai-ops/lora/improve',
      data: {
        'cycles': cycles,
        'target_dataset_size': targetDatasetSize,
        'fast': fast,
      },
    );
  }
}

final aiOpsRepositoryProvider = Provider<AIOpsRepository>((ref) {
  return AIOpsRepository(ref.watch(apiClientProvider));
});

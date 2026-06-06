import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/api_client.dart';

class AIOpsRepository {
  AIOpsRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Retrieves the current status, cycle history, and metrics of the LoRA fine-tuning model loop.
  Future<Map<String, dynamic>> getLoraStatus() async {
    final response = await _apiClient.get('/admin/ai-ops/lora/status');
    final data = response.data;
    if (data is Map) {
      // Unpack response envelope if needed; assuming standard API envelope: { "success": true, "data": { ... } }
      final innerData = data['data'];
      if (innerData is Map) {
        return Map<String, dynamic>.from(innerData);
      }
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  /// Triggers the continuous improvement pipeline (dataset generation, validation, and Llama-Factory training).
  Future<Map<String, dynamic>> triggerImprovementLoop({
    int cycles = 1,
    int targetDatasetSize = 10000,
    bool fast = true,
  }) async {
    final response = await _apiClient.post(
      '/admin/ai-ops/lora/improve',
      data: {
        'cycles': cycles,
        'target_dataset_size': targetDatasetSize,
        'fast': fast,
      },
    );
    final data = response.data;
    if (data is Map) {
      final innerData = data['data'];
      if (innerData is Map) {
        return Map<String, dynamic>.from(innerData);
      }
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }
}

final aiOpsRepositoryProvider = Provider<AIOpsRepository>((ref) {
  return AIOpsRepository(ref.watch(apiClientProvider));
});

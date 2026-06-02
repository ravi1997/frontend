import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import 'data/repositories/response_repository_impl.dart';
import 'response_repository.dart';

final responseRepositoryProvider = Provider<ResponseRepository>((ref) {
  return ResponseRepositoryImpl(ref.watch(apiClientProvider));
});

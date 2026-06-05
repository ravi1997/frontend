import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/modules/forms/data/repositories/template_library_repository_impl.dart';
import 'package:frontend/modules/forms/services/template_library_repository.dart';

final templateLibraryRepositoryProvider = Provider<TemplateLibraryRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return TemplateLibraryRepositoryImpl(dio);
});

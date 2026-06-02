import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/form_builder/data/repositories/template_library_repository_impl.dart';
import 'package:frontend/features/form_builder/services/template_library_repository.dart';

final templateLibraryRepositoryProvider = Provider<TemplateLibraryRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return TemplateLibraryRepositoryImpl(dio);
});

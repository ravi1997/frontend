import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/template_library_repository_impl.dart';
import '../../domain/repositories/template_library_repository.dart';

final templateLibraryRepositoryProvider = Provider<TemplateLibraryRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return TemplateLibraryRepositoryImpl(dio);
});

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/template_library_repository_impl.dart';
import '../../domain/repositories/template_library_repository.dart';
import '../controllers/template_library_controller.dart';

part 'template_library_providers.g.dart';

@riverpod
TemplateLibraryRepository templateLibraryRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return TemplateLibraryRepositoryImpl(dio);
}

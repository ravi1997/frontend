import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/recent_form.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_repository_impl.g.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio _dio;

  DashboardRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<DashboardData> getDashboardData() async {
    // We fetch forms to calculate stats and list recent forms
    // As per documentation section 10.2: GET /form/
    final response = await _dio.get('/form/');

    // In a real scenario, this response would be JSON.
    // We'll parse it according to what we expect from a form list.
    final List<dynamic> formsJson = response.data;

    final List<RecentForm> recentForms = formsJson.map((json) {
      return RecentForm(
        id: json['id'] ?? json['_id'] ?? '',
        title: json['title'] ?? 'Untitled Form',
        status: json['status'] ?? 'Draft',
        updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String(),
        ),
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
      );
    }).toList();

    // Sort by updatedAt descending
    recentForms.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final totalForms = recentForms.length;
    final activeForms = recentForms
        .where((f) => f.status.toLowerCase() == 'published')
        .length;

    // For responses, we might need a separate call or it might be in the form data.
    // Let's assume for now it's 0 if not provided in the list.
    int totalResponses = 0;
    for (var form in formsJson) {
      totalResponses += (form['response_count'] as num? ?? 0).toInt();
    }

    return DashboardData(
      stats: DashboardStats(
        totalForms: totalForms,
        activeForms: activeForms,
        totalResponses: totalResponses,
      ),
      recentForms: recentForms.take(20).toList(), // Show up to 20 forms
    );
  }

  @override
  Future<void> deleteForm(String id) async {
    await _dio.delete('/form/$id');
  }

  @override
  Future<void> duplicateForm(String originalFormId, String newTitle) async {
    final response = await _dio.get('/form/$originalFormId');
    final formData = Map<String, dynamic>.from(response.data);

    // Remove ID and update title
    formData.remove('id');
    formData.remove('_id');
    formData['title'] = newTitle;

    // Save as new form
    await _dio.post('/form/', data: formData);
  }
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(dio: ref.watch(dioProvider));
}

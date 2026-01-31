import '../entities/dashboard_data.dart';

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData();
  Future<void> deleteForm(String id);
  Future<void> duplicateForm(String originalFormId, String newTitle);
}

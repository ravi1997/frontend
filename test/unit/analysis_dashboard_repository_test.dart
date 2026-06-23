import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/modules/analytics/analysis_dashboard_repository.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  test('executeBoard calls the analysis execute route', () async {
    final dio = _MockDio();
    final repo = AnalysisDashboardRepository(ApiClient(dio));

    when(() => dio.get(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/'),
        data: {'message': 'ok'},
      ),
    );

    final result = await repo.executeBoard('project-1', 'board-1');

    expect(result['message'], 'ok');
    verify(
      () => dio.get(
        '/api/v1/projects/project-1/analysis-boards/board-1/execute',
      ),
    ).called(1);
  });
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/responses/domain/repositories/response_repository.dart';

part 'mock_response_repository.g.dart';

class MockResponseRepository implements ResponseRepository {
  @override
  Future<List<FormResponse>> getResponsesForForm(String formId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      FormResponse(
        id: '1',
        formId: formId,
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
        answers: {'q1': 'John Doe', 'q2': 'john@example.com', 'q3': 'Male'},
      ),
      FormResponse(
        id: '2',
        formId: formId,
        submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
        answers: {'q1': 'Jane Smith', 'q2': 'jane@example.com', 'q3': 'Female'},
      ),
      FormResponse(
        id: '3',
        formId: formId,
        submittedAt: DateTime.now(),
        answers: {'q1': 'Bob Wilson', 'q2': 'bob@example.com', 'q3': 'Other'},
      ),
    ];
  }

  @override
  Future<FormResponse> getResponseDetail(String responseId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return FormResponse(
      id: responseId,
      formId: 'form_1',
      submittedAt: DateTime.now(),
      answers: {'q1': 'Mock Answer 1', 'q2': 'Mock Answer 2'},
    );
  }

  @override
  Future<void> submitResponse(FormResponse response) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    // ignore: avoid_print
    print('Response submitted successfully: ${response.id}');
  }
}

@riverpod
ResponseRepository responseRepository(Ref ref) {
  return MockResponseRepository();
}

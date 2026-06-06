import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AnalysisBoardApi
void main() {
  final instance = RidpApi().getAnalysisBoardApi();

  group(AnalysisBoardApi, () {
    // Delete an Analysis Board.
    //
    //Future mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete(String projectId, String boardId) async
    test('test mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete', () async {
      // TODO
    });

    // Execute calculations on an Analysis Board.
    //
    //Future mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet(String projectId, String boardId) async
    test('test mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet', () async {
      // TODO
    });

    // Retrieve an Analysis Board by ID.
    //
    //Future mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet(String projectId, String boardId) async
    test('test mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet', () async {
      // TODO
    });

    // Update an Analysis Board.
    //
    //Future mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut(String projectId, String boardId, AnalysisBoardUpdateSchema body) async
    test('test mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut', () async {
      // TODO
    });

    // List all active Analysis Boards in a Project.
    //
    //Future mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsGet(String projectId, { int page, int pageSize }) async
    test('test mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsGet', () async {
      // TODO
    });

    // Create a new Analysis Board in a Project.
    //
    //Future mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsPost(String projectId, AnalysisBoardCreateSchema body) async
    test('test mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsPost', () async {
      // TODO
    });

  });
}

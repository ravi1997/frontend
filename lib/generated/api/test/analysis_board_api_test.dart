import 'package:test/test.dart';
import 'package:ridp_api/ridp_api.dart';


/// tests for AnalysisBoardApi
void main() {
  final instance = RidpApi().getAnalysisBoardApi();

  group(AnalysisBoardApi, () {
    // Delete an Analysis Board.
    //
    //Future formApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete(String projectId, String boardId) async
    test('test formApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete', () async {
      // TODO
    });

    // Execute calculations on an Analysis Board.
    //
    //Future formApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet(String projectId, String boardId) async
    test('test formApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet', () async {
      // TODO
    });

    // Retrieve an Analysis Board by ID.
    //
    //Future formApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet(String projectId, String boardId) async
    test('test formApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet', () async {
      // TODO
    });

    // Update an Analysis Board.
    //
    //Future formApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut(String projectId, String boardId, AnalysisBoardUpdateSchema body) async
    test('test formApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut', () async {
      // TODO
    });

    // List all active Analysis Boards in a Project.
    //
    //Future formApiV1ProjectsProjectIdAnalysisBoardsGet(String projectId, { int page, int pageSize }) async
    test('test formApiV1ProjectsProjectIdAnalysisBoardsGet', () async {
      // TODO
    });

    // Create a new Analysis Board in a Project.
    //
    //Future formApiV1ProjectsProjectIdAnalysisBoardsPost(String projectId, AnalysisBoardCreateSchema body) async
    test('test formApiV1ProjectsProjectIdAnalysisBoardsPost', () async {
      // TODO
    });

  });
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/envelope_interceptor.dart';
import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}
class FakeDioException extends Fake implements DioException {}

void main() {
  late EnvelopeInterceptor interceptor;
  late MockResponseInterceptorHandler responseHandler;
  late MockErrorInterceptorHandler errorHandler;

  setUpAll(() {
    registerFallbackValue(FakeDioException());
  });

  setUp(() {
    interceptor = EnvelopeInterceptor();
    responseHandler = MockResponseInterceptorHandler();
    errorHandler = MockErrorInterceptorHandler();
  });

  group('EnvelopeInterceptor', () {
    test('onResponse should unwrap success data', () {
      final response = Response(
        requestOptions: RequestOptions(),
        data: {
          'success': true,
          'data': {'id': '123'}
        },
        statusCode: 200,
      );

      interceptor.onResponse(response, responseHandler);

      expect(response.data, equals({'id': '123'}));
      verify(() => responseHandler.next(response)).called(1);
    });

    test('onResponse should throw ApiException on success false', () {
      final response = Response(
        requestOptions: RequestOptions(),
        data: {
          'success': false,
          'error': 'Unauthorized',
          'details': ['Token expired']
        },
        statusCode: 401,
      );

      expect(
        () => interceptor.onResponse(response, responseHandler),
        throwsA(isA<DioException>().having(
          (e) => e.error,
          'error',
          isA<ApiException>().having((ae) => ae.message, 'message', 'Unauthorized'),
        )),
      );
    });

    test('onError should unwrap error envelope', () {
      final dioError = DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          data: {
            'success': false,
            'error': 'Validation Error',
            'details': {'field': 'required'}
          },
          statusCode: 400,
        ),
      );

      interceptor.onError(dioError, errorHandler);

      final captured = verify(() => errorHandler.next(captureAny())).captured.first as DioException;
      expect(captured.error, isA<ApiException>());
      final apiException = captured.error as ApiException;
      expect(apiException.message, equals('Validation Error'));
      expect(apiException.details, equals({'field': 'required'}));
    });
  });
}

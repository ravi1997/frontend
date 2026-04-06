import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/envelope_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}

void main() {
  late EnvelopeInterceptor interceptor;
  late MockResponseInterceptorHandler handler;

  setUpAll(() {
    registerFallbackValue(DioException(requestOptions: RequestOptions(path: '')));
  });

  setUp(() {
    interceptor = EnvelopeInterceptor();
    handler = MockResponseInterceptorHandler();
  });

  test('onResponse unwraps success envelope', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/test'),
      data: {
        'success': true,
        'data': {'key': 'value'},
      },
      statusCode: 200,
    );

    interceptor.onResponse(response, handler);

    expect(response.data, {'key': 'value'});
    verify(() => handler.next(response)).called(1);
  });

  test('onResponse rejects failure envelope', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/test'),
      data: {
        'success': false,
        'message': 'API error',
      },
      statusCode: 400,
    );

    interceptor.onResponse(response, handler);

    verify(() => handler.reject(any())).called(1);
  });

  test('onResponse hands off to next handler if not envelope', () {
    final response = Response(
      requestOptions: RequestOptions(path: '/test'),
      data: {'other': 'data'},
      statusCode: 200,
    );

    interceptor.onResponse(response, handler);

    expect(response.data, {'other': 'data'});
    verify(() => handler.next(response)).called(1);
  });
}

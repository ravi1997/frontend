import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';

class EnvelopeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('success')) {
        final bool success = data['success'] ?? false;
        if (success) {
          // Replace response.data with the unwrapped data
          response.data = data['data'];
        } else {
          // Throw an exception that ErrorInterceptor can catch
          final errorStr = data['error']?.toString() ?? 'Unknown API error';
          final details = data['details'];
          
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: ApiException(
              errorStr,
              details: details,
              statusCode: response.statusCode,
            ),
            type: DioExceptionType.badResponse,
          );
        }
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data is Map<String, dynamic>) {
      final data = err.response!.data as Map<String, dynamic>;
      if (data.containsKey('success') && data['success'] == false) {
        final errorStr = data['error']?.toString() ?? 'Unknown API error';
        final details = data['details'];
        
        // Return a specialized exception with details for the UI to use
        return handler.next(err.copyWith(
          error: ApiException(
            errorStr,
            details: details,
            statusCode: err.response?.statusCode,
          ),
        ));
      }
    }
    handler.next(err);
  }
}

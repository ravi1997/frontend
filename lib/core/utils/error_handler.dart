import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';

class ErrorHandler {
  static String handle(Object error, [String locale = 'en']) {
    return getFriendlyMessage(error, locale);
  }

  static String getFriendlyMessage(Object error, [String locale = 'en']) {
    // English messages
    const en = {
      'auth': 'Session expired or authentication failed. Please login again.',
      'network': 'Server unreachable. Please check your internet connection.',
      'not_found': 'The requested resource was not found.',
      'forbidden': 'You do not have permission to perform this action.',
      'timeout': 'Connection timed out. Please try again.',
      'default': 'An unexpected error occurred. Please try again.',
    };

    // Spanish messages
    const es = {
      'auth':
          'La sesión ha caducado o ha fallado la autenticación. Inicie sesión de nuevo.',
      'network': 'Servidor no accesible. Compruebe su conexión a Internet.',
      'not_found': 'No se ha encontrado el recurso solicitado.',
      'forbidden': 'No tiene permiso para realizar esta acción.',
      'timeout': 'Tiempo de espera agotado. Inténtelo de nuevo.',
      'default': 'Se ha producido un error inesperado. Inténtelo de nuevo.',
    };

    final messages = locale == 'es' ? es : en;

    if (error is AuthException) {
      return messages['auth']!;
    }

    if (error is NetworkException) {
      return messages['network']!;
    }

    if (error is DioException) {
      // 1. Check for backend provided message first
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response?.data as Map<String, dynamic>;
        final backendMessage = (data['error'] ?? data['msg'] ?? data['message'])?.toString();
        if (backendMessage != null && backendMessage.isNotEmpty) {
          return backendMessage;
        }
      }

      // 2. Map based on status code
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) return messages['auth']!;
      if (statusCode == 403) return messages['forbidden']!;
      if (statusCode == 404) return messages['not_found']!;
      if (statusCode != null && statusCode >= 500) return messages['default']!;

      // 3. Map based on Dio type
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return messages['timeout']!;
        case DioExceptionType.connectionError:
          return messages['network']!;
        default:
          break;
      }
    }

    if (error is AppException) {
      if (error.message.toLowerCase().contains('not found')) {
        return messages['not_found']!;
      }
      if (error.message.toLowerCase().contains('permission') ||
          error.message.toLowerCase().contains('forbidden')) {
        return messages['forbidden']!;
      }
      return error.message;
    }

    return messages['default']!;
  }
}

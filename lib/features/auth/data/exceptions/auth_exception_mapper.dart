import 'package:dio/dio.dart';

import 'package:re_articles/features/auth/domain/exceptions/auth_exception.dart';

class AuthExceptionMapper {
  static AuthException map(Object error) {
    if (error is! DioException) {
      return const UnknownAuthException();
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkException();
    }

    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return const InvalidRequestException();

      case 401:
        return const InvalidCredentialsException();

      case 409:
        return _mapConflict(error);

      case 500:
      case 502:
      case 503:
        return const ServerException();

      default:
        return const UnknownAuthException();
    }
  }

  static AuthException _mapConflict(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['error']?.toString().toLowerCase();

      if (message?.contains('email') == true) {
        return const EmailAlreadyExistsException();
      }

      if (message?.contains('username') == true) {
        return const UsernameAlreadyExistsException();
      }
    }

    return const InvalidRequestException();
  }
}
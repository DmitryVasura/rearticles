import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}
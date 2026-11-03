import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:re_articles/core/storage/token_storage.dart';

class ApiClient {
  late final Dio dio;

  ApiClient(
    TokenStorage tokenStorage, {
    VoidCallback? onUnauthorized,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://rearticles-server.onrender.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          final isAuthRequest =
              error.requestOptions.path.startsWith('/auth');

          if (error.response?.statusCode == 401 &&
              !isAuthRequest &&
              onUnauthorized != null) {
            final hadToken = await tokenStorage.getToken() != null;

            if (hadToken) {
              await tokenStorage.deleteToken();
              onUnauthorized();
            }
          }

          handler.next(error);
        },
      ),
    );
  }
}
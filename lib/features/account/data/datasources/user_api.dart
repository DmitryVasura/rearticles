import 'package:dio/dio.dart';
import 'package:re_articles/core/storage/token_storage.dart';
import 'package:re_articles/features/account/data/models/author_profile.dart';

class UserApi {

  final Dio dio;

  UserApi(this.dio);

  Future<Map<String, dynamic>> getCurrentUser({
    required TokenStorage tokenStorage
  }) async {
    final token = await tokenStorage.getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await dio.get(
      '/users/me',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<AuthorProfile> getAuthorProfile(int id) async {
    final response = await dio.get('/users/$id');

    return AuthorProfile.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> deleteToken({
    required TokenStorage tokenStorage
  }) async {
    await tokenStorage.deleteToken();
  }
}
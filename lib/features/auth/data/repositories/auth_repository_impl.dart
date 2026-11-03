import 'package:re_articles/features/auth/data/datasources/auth_api.dart';
import 'package:re_articles/features/auth/data/exceptions/auth_exception_mapper.dart';
import 'package:re_articles/features/auth/data/models/auth_response.dart';
import 'package:re_articles/features/auth/domain/entities/auth_result.dart';
import 'package:re_articles/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final data = await api.register(
        username: username,
        email: email,
        password: password,
      );

      return AuthResponseModel
          .fromRegisterJson(data)
          .toEntity();
    } catch (error) {
      throw AuthExceptionMapper.map(error);
    }
  }

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await api.login(
        email: email,
        password: password,
      );

      return AuthResponseModel
          .fromLoginJson(data)
          .toEntity();
    } catch (error) {
      throw AuthExceptionMapper.map(error);
    }
  }
}
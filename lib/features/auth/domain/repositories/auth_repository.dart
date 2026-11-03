import 'package:re_articles/features/auth/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  });

  Future<AuthResult> login({
    required String email,
    required String password,
  });
}
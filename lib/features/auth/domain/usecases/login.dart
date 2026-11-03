import 'package:re_articles/features/auth/domain/entities/auth_result.dart';
import 'package:re_articles/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<AuthResult> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}
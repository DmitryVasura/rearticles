import 'package:re_articles/features/auth/domain/entities/auth_result.dart';
import 'package:re_articles/features/auth/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<AuthResult> call({
    required String username,
    required String email,
    required String password,
  }) {
    return repository.register(
      username: username,
      email: email,
      password: password,
    );
  }
}
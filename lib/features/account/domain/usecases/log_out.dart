import 'package:re_articles/features/account/domain/repositories/user_repository.dart';

class LogOut {
  final UserRepository repository;

  const LogOut(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
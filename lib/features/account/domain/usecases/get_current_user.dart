import 'package:re_articles/features/account/domain/entities/user_result.dart';
import 'package:re_articles/features/account/domain/repositories/user_repository.dart';

class GetCurrentUser {
  final UserRepository repository;

  const GetCurrentUser(this.repository);

  Future<AccountResult> call() {
    return repository.getCurrentUser();
  }
}
import 'package:re_articles/features/account/domain/entities/user_result.dart';

abstract class UserRepository {
  Future<AccountResult> getCurrentUser();
  Future<void> logout();
}
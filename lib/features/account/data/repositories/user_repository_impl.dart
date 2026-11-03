import 'package:re_articles/core/storage/token_storage.dart';
import 'package:re_articles/features/account/data/datasources/user_api.dart';
import 'package:re_articles/features/account/data/models/user_result_model.dart';
import 'package:re_articles/features/account/domain/entities/user_result.dart';
import 'package:re_articles/features/account/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApi api;
  final TokenStorage tokenStorage;

  UserRepositoryImpl(
    this.api,
    this.tokenStorage,
  );

  @override
  Future<AccountResult> getCurrentUser() async {
    final data = await api.getCurrentUser(
      tokenStorage: tokenStorage,
    );

    return UserResultModel
      .fromJson(data)
      .toEntity();
  }

  @override
  Future<void> logout() async {
    await api.deleteToken(
      tokenStorage: tokenStorage
    );
  }
}
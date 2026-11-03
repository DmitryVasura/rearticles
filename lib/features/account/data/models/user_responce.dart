import 'package:re_articles/features/account/data/models/user_result_model.dart';

class UserResponce {
  final UserResultModel user;

  const UserResponce({
    required this.user,
  });

  
  UserResponce toEntity() {
    return UserResponce(
      user: user
    );
  }
}
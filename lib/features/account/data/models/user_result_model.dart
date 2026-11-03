import 'package:re_articles/features/account/domain/entities/user_profile.dart';
import 'package:re_articles/features/account/domain/entities/user_result.dart';

class UserResultModel {
  final int id;
  final String username;
  final String email;
  final int articlesCount;
  final int likesReceived;

  const UserResultModel({
    required this.id,
    required this.username,
    required this.email,
    this.articlesCount = 0,
    this.likesReceived = 0,
  });

  factory UserResultModel.fromJson(Map<String, dynamic> json) {
    return UserResultModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      articlesCount: (json['articlesCount'] as num?)?.toInt() ?? 0,
      likesReceived: (json['likesReceived'] as num?)?.toInt() ?? 0,
    );
  }

  AccountResult toEntity() {
    return AccountResult(
      user: UserProfile(
        id: id,
        username: username,
        email: email,
        articlesCount: articlesCount,
        likesReceived: likesReceived,
      ),
    );
  }
}
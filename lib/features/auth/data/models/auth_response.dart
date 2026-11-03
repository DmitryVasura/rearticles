import 'package:re_articles/features/auth/domain/entities/auth_result.dart';
import 'package:re_articles/features/auth/domain/entities/user.dart';

class AuthResponseModel {
  final String? token;
  final UserModel user;

  const AuthResponseModel({
    this.token,
    required this.user,
  });

  factory AuthResponseModel.fromLoginJson(
    Map<String, dynamic> json,
  ) {
    return AuthResponseModel(
      token: json['token'] as String,
      user: UserModel.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }

  factory AuthResponseModel.fromRegisterJson(
    Map<String, dynamic> json,
  ) {
    return AuthResponseModel(
      user: UserModel.fromJson(json),
    );
  }

  AuthResult toEntity() {
    return AuthResult(
      token: token,
      user: user.toEntity(),
    );
  }
}

class UserModel {
  final int id;
  final String username;
  final String email;
  final bool emailVerified;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool,
    );
  }

  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      emailVerified: emailVerified,
    );
  }
}
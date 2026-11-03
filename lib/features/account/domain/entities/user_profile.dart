import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int id;
  final String username;
  final String email;
  final int articlesCount;
  final int likesReceived;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.articlesCount = 0,
    this.likesReceived = 0,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        articlesCount,
        likesReceived,
      ];
}
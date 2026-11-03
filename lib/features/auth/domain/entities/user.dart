import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final bool emailVerified;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.emailVerified,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    emailVerified,
  ];
}
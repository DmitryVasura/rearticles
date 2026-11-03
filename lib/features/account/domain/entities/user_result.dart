import 'package:equatable/equatable.dart';
import 'package:re_articles/features/account/domain/entities/user_profile.dart';

class AccountResult extends Equatable {
  final UserProfile user;

  const AccountResult({
    required this.user,
  });

  @override
  List<Object?> get props => [
    user,
  ];
}
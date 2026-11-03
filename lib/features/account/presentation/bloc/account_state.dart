import 'package:equatable/equatable.dart';
import 'package:re_articles/features/account/domain/entities/user_result.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class LoginOut extends AccountState {
  const LoginOut();
}

class LogedOut extends AccountState {
  const LogedOut();
}

class AccountLoaded extends AccountState {
  final AccountResult result;

  const AccountLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}
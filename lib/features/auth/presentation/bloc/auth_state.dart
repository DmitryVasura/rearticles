import 'package:equatable/equatable.dart';
import 'package:re_articles/features/auth/domain/entities/auth_result.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  final AuthResult result;

  const AuthSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
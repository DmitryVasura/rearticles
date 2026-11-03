import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/core/storage/token_storage.dart';
import 'package:re_articles/features/auth/domain/exceptions/auth_exception.dart';

import 'package:re_articles/features/auth/domain/usecases/login.dart';
import 'package:re_articles/features/auth/domain/usecases/register.dart';
import 'package:re_articles/features/auth/domain/usecases/validate_email.dart';
import 'package:re_articles/features/auth/domain/usecases/validate_password.dart';
import 'package:re_articles/features/auth/domain/usecases/validate_username.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;

  final ValidateEmail validateEmail;
  final ValidateUsername validateUsername;
  final ValidatePassword validatePassword;
  final TokenStorage tokenStorage;

  AuthBloc({
    required this.login,
    required this.register,
    required this.validateEmail,
    required this.validateUsername,
    required this.validatePassword,
    required this.tokenStorage,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final emailError = validateEmail(event.email);

    if (emailError != null) {
      emit(AuthFailure(emailError));
      return;
    }

    final passwordError = validatePassword(event.password);

    if (passwordError != null) {
      emit(AuthFailure(passwordError));
      return;
    }

    emit(const AuthLoading());

    try {
      final result = await login(
      email: event.email.trim(),
      password: event.password,
    );

    if (result.token != null) {
      await tokenStorage.saveToken(result.token!);
    }

    await tokenStorage.saveUserId(result.user.id);

    emit(AuthSuccess(result));
    } catch (error) {

      emit(
        AuthFailure(
          _mapError(error),
        ),
      );
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    final usernameError = validateUsername(event.username);

    if (usernameError != null) {
      emit(AuthFailure(usernameError));
      return;
    }

    final emailError = validateEmail(event.email);

    if (emailError != null) {
      emit(AuthFailure(emailError));
      return;
    }

    final passwordError = validatePassword(event.password);

    if (passwordError != null) {
      emit(AuthFailure(passwordError));
      return;
    }

    emit(const AuthLoading());

    try {
      await register(
        email: event.email.trim(),
        password: event.password,
        username: event.username,
      );

      final result = await login(
        email: event.email.trim(),
        password: event.password,
      );

      if (result.token != null) {
        await tokenStorage.saveToken(result.token!);
      }

      await tokenStorage.saveUserId(result.user.id);

      emit(AuthSuccess(result));
    } catch (error) {
      emit(AuthFailure(_mapError(error)));
    }
  }

  String _mapError(Object error) {
  if (error is AuthException) {
      return error.message;
    }
    return 'Произошла неизвестная ошибка';
  }
}
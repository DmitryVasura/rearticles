import 'package:equatable/equatable.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends AccountEvent {
  const GetCurrentUserEvent();
}

class LogOutEvent extends AccountEvent {
  const LogOutEvent();
}
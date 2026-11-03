import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/features/account/domain/usecases/get_current_user.dart';
import 'package:re_articles/features/account/domain/usecases/log_out.dart';
import 'package:re_articles/features/account/presentation/bloc/account_event.dart';
import 'package:re_articles/features/account/presentation/bloc/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetCurrentUser getCurrentUser;
  final LogOut logOut;

  AccountBloc(this.getCurrentUser, this.logOut) : super(const AccountInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<LogOutEvent>(_onLogOut);
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());

    try {
      final result = await getCurrentUser();

      emit(AccountLoaded(result));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onLogOut(
    LogOutEvent event,
    Emitter<AccountState> emit
  ) async {
    emit(const LoginOut());

    try {
      await logOut();
      emit(LogedOut());
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginUseCase loginUseCase = LoginUseCase();
  LoginCubit() : super(LoginInitial());
  Account? account;
  String _errorMessage(LoginFailure failure, BuildContext context) {
    AppLocalizations? lang = AppLocalizations.of(context);

    switch (failure.runtimeType) {
      case InvalidEmailFailure:
        return lang!.emailFormFailure;
      case UserNotFoundFailure:
        return lang!.usernotfound;
      case UserDisabledFailure:
        return lang!.usernotfound;
      case WorngPasswordFailure:
        return lang!.passwordNotcorrect;
      case UsernameWithSpaceFailure:
        return lang!.usernameNospace;
      case EmailAlreadyExistedFailure:
        return lang!.emailAlreadyExistedFailure;
      case ServerFailure:
        return lang!.serverFailure;
      case EmpityEmailFailure:
        return lang!.pleaseinputyouremailaddress;
      case LoginServerFailure:
      return lang!.checkyourinternetplease;
      default:
        return lang!.generalFailure;
    }
  }
  
  Future<void> login({required Account account, BuildContext? context}) async {
    AppLocalizations? lang;
    if (context != null) {
      lang = AppLocalizations.of(context!);
    }

    emit(LoginInitial());
    Either<LoginFailure, Account> fold =
        await loginUseCase.call(account: account);
    if (account.email.isEmpty && context != null) {
      emit(ErrorLoginState(error: lang!.empitymail));
    } else if (account.password.isEmpty && context != null) {
      emit(ErrorLoginState(error: lang!.empitypassword));
    } else {
      fold.fold((l) {
        if (l.runtimeType == NewClientFailure) {
        } else {
          emit(ErrorLoginState(error: _errorMessage(l, context!)));
        }
      }, (acc) {
        account = acc;
        emit(LoginDoneState(account: acc));
      });
    }
  }
}

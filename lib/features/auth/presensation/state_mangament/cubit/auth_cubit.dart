// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/use_cases/signup_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  SignUpUseCase signUpUseCase;

  AuthCubit({required this.signUpUseCase}) : super(AuthInitial());

  String _errorMessage(SignUpFailure failure, BuildContext context) {
    AppLocalizations? lang = AppLocalizations.of(context);

    switch (failure.runtimeType) {
      case CharactersPasswordFailure:
        return lang!.noLettersNoNumbersinPasswordFailure;
      case EmailFormFailure:
        return lang!.emailFormFailure;
      case EmpityUserNameFailure:
        return lang!.pleaseinputyourusername;
      case PasswordSizeFailure:
        return lang!.passwordSizeFailure;
      case UsernameWithSpaceFailure:
        return lang!.usernameNospace;
      case EmailAlreadyExistedFailure:
        return lang!.emailAlreadyExistedFailure;
      case ServerFailure:
        return lang!.serverFailure;
      case EmpityEmailFailure:
        return lang!.pleaseinputyouremailaddress;

      default:
        return lang!.generalFailure;
    }
  }

  Future<void> signUp(
      {required Account account, required BuildContext context}) async {
    emit(AuthInitial());
    Either<SignUpFailure, Account> fold =
        await signUpUseCase.call(account: account);
    fold.fold((fail) {
      emit(ErrorStateAuth(error: _errorMessage(fail, context)));
    }, (user) {
      emit(RegisterState(account: user));
    });
  }

  
}

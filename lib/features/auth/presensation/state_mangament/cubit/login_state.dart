// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginDoneState extends LoginState {
  final Account account;
  const LoginDoneState({
    required this.account,
  });
}

class ErrorLoginState extends LoginState {
  final String error;
  const ErrorLoginState({
    required this.error,
  });
}

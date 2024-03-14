// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class ErrorStateAuth extends AuthState {
  final String error;
  const ErrorStateAuth({required this.error});
}

class RegisterState extends AuthState {
  final Account account;
  const RegisterState({
    required this.account,
  });
}

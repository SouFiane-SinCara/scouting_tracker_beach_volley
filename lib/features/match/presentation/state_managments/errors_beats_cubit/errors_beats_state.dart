part of 'errors_beats_cubit.dart';

sealed class ErrorsBeatsState extends Equatable {
  const ErrorsBeatsState();

  @override
  List<Object> get props => [];
}

final class ErrorsBeatsInitial extends ErrorsBeatsState {}

final class ErrorSatate extends ErrorsBeatsState {
  final String error;

  ErrorSatate(this.error);
}

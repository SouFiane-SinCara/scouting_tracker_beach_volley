part of 'reset_line_cubit.dart';

sealed class ResetLineState extends Equatable {
  const ResetLineState();

  @override
  List<Object> get props => [];
}

final class ResetLineInitial extends ResetLineState {}
class ResetNowState extends ResetLineState{}
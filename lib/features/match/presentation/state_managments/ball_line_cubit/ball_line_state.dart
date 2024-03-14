// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ball_line_cubit.dart';

sealed class BallLineState extends Equatable {
  const BallLineState();

  @override
  List<Object> get props => [];
}

final class BallLineInitial extends BallLineState {}

class SelectedBallLineState extends BallLineState {
  final Offset p1;
  final Offset p2;
  final bool continuedLine;
  const SelectedBallLineState({
    required this.p1,
    required this.p2,
    required this.continuedLine,
  });
  
}

part of 'invert_cubit.dart';

sealed class InvertState extends Equatable {
  const InvertState();

  @override
  List<Object> get props => [];
}

final class InvertInitial extends InvertState {}

class InvertNewState extends InvertState {
  final bool inverted;
  final bool blueInverted;
  final bool redInverted;
  const InvertNewState(
      {required this.blueInverted,
      required this.inverted,
      required this.redInverted});
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'attack_type_cubit.dart';

sealed class AttackTypeState extends Equatable {
  const AttackTypeState();

  @override
  List<Object> get props => [];
}

final class AttackTypeInitial extends AttackTypeState {}

class ReceptionState extends AttackTypeState {
  final int team;
  final int player;
  const ReceptionState({
    required this.team,
    required this.player,
  });
}

class ChangeBallState extends AttackTypeState {
  final int team;
  final int player;
  const ChangeBallState({
    required this.team,
    required this.player,
  });
}

class BreackPointState extends AttackTypeState {
  final int team;
  final int player;
  final int breakPoint;
  const BreackPointState({
    required this.team,
    required this.player,
    required this.breakPoint,
  });
}

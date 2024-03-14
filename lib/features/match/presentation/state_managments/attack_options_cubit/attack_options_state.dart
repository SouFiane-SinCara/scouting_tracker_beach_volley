part of 'attack_options_cubit.dart';

sealed class AttackOptionsState extends Equatable {
  const AttackOptionsState();

  @override
  List<Object> get props => [];
}

final class AttackOptionsInitial extends AttackOptionsState {}
class SecondAttackState extends AttackOptionsState{}
class DefededAttackState extends AttackOptionsState{}
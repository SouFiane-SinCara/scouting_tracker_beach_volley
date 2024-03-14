part of 'acctions_play_cubit.dart';

sealed class AcctionsPlayState extends Equatable {
  const AcctionsPlayState();

  @override
  List<Object> get props => [];
}

final class AcctionsPlayInitial extends AcctionsPlayState {}

class BeatState extends AcctionsPlayState {}

class ChangeBallAcctionState extends AcctionsPlayState {}

class BreakPointState extends AcctionsPlayState {}

class RiserState extends AcctionsPlayState {}

class ReceptionState extends AcctionsPlayState {}

class WallState extends AcctionsPlayState {}

class AttackOnDetachmentState extends AcctionsPlayState {}

class AttackOftwoState extends AcctionsPlayState {}

class ErrorsState extends AcctionsPlayState {}

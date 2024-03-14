part of 'choose_player_cubit.dart';

sealed class ChoosePlayerState extends Equatable {
  const ChoosePlayerState();

  @override
  List<Object> get props => [];
}

final class ChoosePlayerInitial extends ChoosePlayerState {}
class FirstState extends ChoosePlayerState{}
class SecondState extends ChoosePlayerState{}
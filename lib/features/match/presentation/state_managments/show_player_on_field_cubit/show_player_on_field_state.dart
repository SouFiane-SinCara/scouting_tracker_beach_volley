part of 'show_player_on_field_cubit.dart';

sealed class ShowPlayerOnFieldState extends Equatable {
  const ShowPlayerOnFieldState();

  @override
  List<Object> get props => [];
}

final class ShowPlayerOnFieldInitial extends ShowPlayerOnFieldState {}
class ShowNewPlayerOnFieldState extends ShowPlayerOnFieldState {
  final bool redTeam ;
  final bool firstPlayer;
  const ShowNewPlayerOnFieldState({required this.firstPlayer, required this.redTeam});
}
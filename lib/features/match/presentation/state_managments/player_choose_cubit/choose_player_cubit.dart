import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';

part 'choose_player_state.dart';

class ChoosePlayerCubit extends Cubit<ChoosePlayerState> {
  Player? player;

  ChoosePlayerCubit() : super(ChoosePlayerInitial());
  void changePlayer(
    Player? newPlayer,
    int playernum,
  ) {
    
    emit(ChoosePlayerInitial());
    if (playernum == 1) {
      player = newPlayer;
      emit(FirstState());
    } else if (playernum == 2) {
      player = newPlayer;
      emit(SecondState());
    } else {
      player = null;
    }
  }
}

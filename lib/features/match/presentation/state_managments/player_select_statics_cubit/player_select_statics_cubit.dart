import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'player_select_statics_state.dart';

class PlayerSelectStaticsCubit extends Cubit<PlayerSelectStaticsState> {
  String playersurname = "select a player";
  PlayerSelectStaticsCubit() : super(PlayerSelectStaticsInitial());
  void changePlayer(String player) {
    
    playersurname = player;
  }
}

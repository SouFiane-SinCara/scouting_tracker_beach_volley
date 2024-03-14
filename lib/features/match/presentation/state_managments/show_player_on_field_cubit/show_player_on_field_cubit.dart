import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'show_player_on_field_state.dart';

class ShowPlayerOnFieldCubit extends Cubit<ShowPlayerOnFieldState> {
  ShowPlayerOnFieldCubit() : super(ShowPlayerOnFieldInitial());
  void showPlayer({required bool firstPlayer, required bool redTeam}){
    emit(ShowPlayerOnFieldInitial());
    emit(ShowNewPlayerOnFieldState(firstPlayer: firstPlayer, redTeam: redTeam));
  }
}

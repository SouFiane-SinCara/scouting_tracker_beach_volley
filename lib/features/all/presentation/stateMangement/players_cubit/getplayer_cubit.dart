import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/add_player_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/get_players_use_case.dart';

part 'getplayer_state.dart';

class GetplayerCubit extends Cubit<GetplayerState> {
  GetplayerCubit() : super(GetplayerInitial());
  Future<void> addPlayer({required Player player}) async {
    emit(GetplayerInitial());
    AddPlayerUseCase addPlayerUseCase = AddPlayerUseCase();
    Either<FireStoreFailure, Unit> fold =
        await addPlayerUseCase.call(player: player);
    fold.fold((fail) {
      emit(ErrorPlayerState());
    }, (done) => emit(AddedPlayerState()));
  }

  Future<void> getPlayers({required Player player}) async {
    GetPlayersUseCase getPlayersUseCase = GetPlayersUseCase();
    Either<FireStoreFailure, List<Player>> fold =
        await getPlayersUseCase.call(player: player);
    fold.fold((l) => emit(ErrorPlayerState()), (allplayers) {
      if (allplayers.isEmpty) {
        emit(EmpityPlayerState());
      } else {
        emit(LoadedPlayerState(players: allplayers));
      }
    });
  }
}

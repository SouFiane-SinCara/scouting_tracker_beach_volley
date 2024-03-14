import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/repository/repository.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/repository/repository_imp.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/repository/repository.dart';

part 'get_beats_state.dart';

class GetBeatsCubit extends Cubit<GetBeatsState> {
  List<BeatAction> beats = [];
  GetBeatsCubit() : super(GetBeatsInitial());
  Future<void> getBeats({required AMatch aMatch}) async {
    emit(GetBeatsInitial());
    RepositoryMatch repositoryMatch = RepositoryMatchImp();
    final Either<FireStoreFailure, List<BeatAction>> fold =
        await repositoryMatch.getBeatsActions(aMatch: aMatch);
    fold.fold((fail) {
      emit(BeatsActionsErrorState());
    }, (allBeats) {
      allBeats.forEach((element) {
        
      });
      beats = allBeats;

      emit(BeatsActionsLoadedState(beats: allBeats));
    });
  }
}

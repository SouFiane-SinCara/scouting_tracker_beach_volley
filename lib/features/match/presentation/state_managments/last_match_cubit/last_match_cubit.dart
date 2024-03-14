import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/use_cases/get_last_match.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'last_match_state.dart';

class LastMatchCubit extends Cubit<LastMatchState> {
  AMatch ?aMatch ;
  LastMatchCubit() : super(LastMatchInitial());
  Future<void> getLastMatch({required Account account}) async {
    emit(LastMatchInitial());
    GetLastMatchUseCase getLastMatchUseCase = GetLastMatchUseCase();
    Either<LastMatchFailure, AMatch> fold = await getLastMatchUseCase.call();
    fold.fold((fail) {
      switch (fail.runtimeType) {
        case NoMatchStartedFailure:
          emit(ChooseMatchState(account: account));
        case MatchFireStoreFailure:
          emit(ErrorMatchState());

        default:
          emit(ErrorMatchState());
      }
    }, (match) {

      
      aMatch = match;
      emit(StartedMatchState(aMatch: match));

    }
    );
}
}
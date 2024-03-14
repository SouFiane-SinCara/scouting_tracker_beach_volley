import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/add_match_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/get_matches_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

part 'match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit() : super(MatchInitial());
  Future<void> addMatch(
      {required AMatch match, required BuildContext context}) async {
    AddMatchUseCase addMatchUseCase = AddMatchUseCase();
    Either<FireStoreFailure, Unit> fold =
        await addMatchUseCase.call(match: match);
  }

  Future<void> getMatches(
      {required String title,
      required String date,
      required String location,
      required BuildContext context,
      required Account account}) async {
    GetMatchesUseCase getMatchesUseCase = await GetMatchesUseCase();
    Either<FireStoreFailure, List<AMatch>> fold = await getMatchesUseCase.call(
        title: title, date: date, location: location, account: account);
    fold.fold((f) {
      emit(ErrorMatchesState(
          error: AppLocalizations.of(context)!.serverFailure));
    }, (allMatches) {
      if (allMatches.isEmpty) {
        emit(EmpityMatchesState());
      } else {
        emit(LoadedMatchesState(matches: allMatches));
      }
    });
  }
}

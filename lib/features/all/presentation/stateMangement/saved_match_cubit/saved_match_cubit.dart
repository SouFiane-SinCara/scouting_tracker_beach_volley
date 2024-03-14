import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'saved_match_state.dart';

class SavedMatchCubit extends Cubit<SavedMatchState> {
  SavedMatchCubit() : super(SavedMatchInitial());
  Future<void> navigateToTournaments(Account account) async {
    emit(SavedMatchInitial());
    RemoteData remoteData = RemoteFB();
    List<String> tournaments =
        await remoteData.getTournaments(account: account);

    emit(TournamentsState(tournaments: tournaments));
  }

  Future<void> navigateToLocationsDate(
      Account account, String tournamentTitle) async {
    emit(SavedMatchInitial());
    RemoteData remoteData = RemoteFB();
    List<Map> locationsDate = await remoteData.getlocationdate(
        account: account, tournamentTitle: tournamentTitle);

    emit(LocationsDateState(
        locationDate: locationsDate, tournamentTitle: tournamentTitle));
  }

  Future<void> navigateToMatch(
      {required String email,
      required String titlematch,
      required String tournamentTitle,
      required String location,
      required String date}) async {
    RemoteDataSourceGetLastMatch remoteData = RemoteDataSourceGetLastMatchFB();
    remoteData.getMatch(
        date: date,
        discription: titlematch,
        email: email,
        location: location,
        tournamentTitle: tournamentTitle);
  }

  Future<void> navigateToTournamentsPlayers() async {
    emit(SavedMatchInitial());

    emit(TournamentsPlayersState());
  }

  Future<void> navigateToMatches(
      {required Account account,
      required String title,
      required String date,
      required String location}) async {
    emit(SavedMatchInitial());
    RemoteData remoteData = RemoteFB();
    List<AMatch> matches = await remoteData.getMatches(
        title: title, date: date, location: location, account: account);
    
    emit(MatchesState(matches: matches.isEmpty? [] : matches));
  }
}

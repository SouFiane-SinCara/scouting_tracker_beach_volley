import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/create_location_date_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/create_tournament_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/get_Tournaments_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/get_location_date_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

part 'tournaments_state.dart';

class TournamentsCubit extends Cubit<TournamentsState> {
  TournamentsCubit() : super(TournamentsInitial());
  Future getTournaments({required Account account}) async {
    emit(TournamentsInitial());
    Either<FireStoreFailure, List<String>> fold =
        await GetTournamentsUseCase().call(account: account);
    fold.fold((fail) {
      emit(ErrorTournamentsState());
    }, (tournaments) {
      tournaments.isEmpty
          ? emit(EmpityTournamentsState())
          : emit(LoadedTournamentsState(tournaments: tournaments));
    });
  }

  Future getlocationDate(
      {required Account account, required String tournamentTitle}) async {
    emit(TournamentsInitial());
    Either<FireStoreFailure, List<Map>> fold = await GetLocationDateUseCase()
        .call(account: account, tournamentTitle: tournamentTitle);
    fold.fold((fail) {
      emit(ErrorTournamentsState());
    }, (locationsdate) {
      locationsdate.isEmpty
          ? emit(EmpityTournamentsState())
          : emit(LoadedLocationState(locationdate:locationsdate ));
    });
  }

  Future createTournament(
      {required String title, required Account account}) async {
    emit(TournamentsInitial());

    Either<FireStoreFailure, Unit> fold =
        await CreateTournamnetsUseCase().call(account: account, title: title);
    await getTournaments(account: account);
  }

  Future createLocationDate(
      {
      required Account account,
      required String tournamentTitle,
      required String location,
      required String date}) async {
    emit(TournamentsInitial());

    Either<FireStoreFailure, Unit> fold = await CreateLocationDateUseCase()
        .call(
            tournamentTitle: tournamentTitle,
            account: account,
            location: location,
            date: date);
    await getTournaments(account: account);
  }
  void getPlayers({required  }){

  }
}

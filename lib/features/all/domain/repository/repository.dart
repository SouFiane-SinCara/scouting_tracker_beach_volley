import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';

abstract class Repository {
  String getLanguage();
  storageLanguage(String lang);
  Future<Either<FireStoreFailure, Unit>> createTournament(
      {required String title, required Account account});
  Future<Either<FireStoreFailure, Unit>> createLocationDate(
      {required String tournamentTitle,
      required Account account,
      required String location,
      required String date});
  Future<Either<FireStoreFailure, List<String>>> getTournaments(
      {required Account account});
  Future<Either<FireStoreFailure, List<Player>>> getPlayers(
      {required Player player});
  Future<Either<FireStoreFailure, List<Map>>> getlocationsTournaments(
      {required Account account, required String tournamentTitle});

  Future<Either<FireStoreFailure, Unit>> addPlayer({required Player player});
  Future<Either<FireStoreFailure, Unit>> addMatch({required AMatch match});
  Future<Either<FireStoreFailure, List<AMatch>>> getMatches(
      {required String title,
      required String date,
      required String location,
      required Account account});
}

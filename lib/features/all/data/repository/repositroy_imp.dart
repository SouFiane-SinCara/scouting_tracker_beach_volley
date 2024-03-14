// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/exeptions/exeptions.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/repository/repository.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

class RepositoryImp extends Repository {
  RemoteData remoteData;
  LocalDataSource localDataSource;
  RepositoryImp({
    required this.remoteData,
    required this.localDataSource,
  });
  @override
  String getLanguage() {
    return localDataSource.getData();
  }

  @override
  storageLanguage(String lang) async {
    await localDataSource.storageData(lang);
  }

  @override
  Future<Either<FireStoreFailure, Unit>> createTournament(
      {required String title, required Account account}) async {
    try {
      await remoteData.createTournament(title: title, account: account);
      return const Right(unit);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }

  @override
  Future<Either<FireStoreFailure, List<String>>> getTournaments(
      {required Account account}) async {
    try {
      List<String> tournaments =
          await remoteData.getTournaments(account: account);
      return Right(tournaments);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }

  @override
  Future<Either<FireStoreFailure, Unit>> createLocationDate(
      {required String tournamentTitle,
      required Account account,
      required String location,
      required String date}) async {
    try {
      await remoteData.createLoctionDate(
          account: account,
          location: location,
          date: date,
          titleTournament: tournamentTitle);
      return const Right(unit);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }

  @override
  Future<Either<FireStoreFailure, List<Map>>> getlocationsTournaments(
      {required Account account, required String tournamentTitle}) async {
    try {
      List<Map> tournaments = await remoteData.getlocationdate(
          account: account, tournamentTitle: tournamentTitle);
      return Right(tournaments);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }

  @override
  Future<Either<FireStoreFailure, Unit>> addPlayer(
      {required Player player}) async {
    try {
      await remoteData.addPlayer(player: player);
      return const Right(unit);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }

  @override
  Future<Either<FireStoreFailure, List<Player>>> getPlayers(
      {required Player player}) async {
    try {
      List<Player> tournaments = await remoteData.getPlayers(player: player);
      return Right(tournaments);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }

  @override
  Future<Either<FireStoreFailure, Unit>> addMatch(
      {required AMatch match}) async {
    try {
      await remoteData.addMatch(match: match);
      
      return Right(unit);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }

  @override
  Future<Either<FireStoreFailure, List<AMatch>>> getMatches(
      {required String title,
      required String date,
      required String location,
      required Account account}) async {
    try {
      List<AMatch> matches = await remoteData.getMatches(

          title: title, date: date, location: location, account: account);
      return Right(matches);
    } on FirestoreGeneralExeption {}
    return Left(FirestoreGeneralFailure());
  }
}

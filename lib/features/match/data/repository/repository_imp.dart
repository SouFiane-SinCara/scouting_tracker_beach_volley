import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/exeptions/exeptions.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/repository/repository.dart';

class RepositoryMatchImp extends RepositoryMatch {
  RemoteDataSourceGetLastMatch remoteDataSourceGetLastMatch =
      RemoteDataSourceGetLastMatchFB();
  @override
  Future<Either<LastMatchFailure, AMatch>> getLastMatch() async {
    try {
      AMatch aMatch = await remoteDataSourceGetLastMatch.getLastMatch();
      return Right(aMatch);
    } on NoMatchStartedExeptions {
      return Left(NoMatchStartedFailure());
    } on MatchFireStoreExeptions {
      return Left(MatchFireStoreFailure());
    }
  }
  
  @override
  Future<Either<FireStoreFailure, Unit>> addBeat(
      {BeatAction? beatAction}) async {
    try {
      await remoteDataSourceGetLastMatch.addBeatAction(beatAction: beatAction!);
      return const Right(unit);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    
    }
  
  }
  
  @override
  Future<Either<FireStoreFailure, List<BeatAction>>> getBeatsActions({required AMatch aMatch }) async {
    try {
    List<BeatAction> beats=   await remoteDataSourceGetLastMatch.getBeatsActions(aMatch:aMatch );
      return Right(beats);
    } on FirestoreGeneralExeption {
      return Left(FirestoreGeneralFailure());
    }
  }
}

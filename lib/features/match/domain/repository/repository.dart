import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';

abstract class RepositoryMatch {
  Future<Either<LastMatchFailure, AMatch>> getLastMatch();
  Future<Either<FireStoreFailure, Unit>> addBeat({ BeatAction beatAction});
  Future<Either<FireStoreFailure,List<BeatAction>>> getBeatsActions({required
    AMatch aMatch
  });
}

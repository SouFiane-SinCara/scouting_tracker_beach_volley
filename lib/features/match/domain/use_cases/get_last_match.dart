import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/repository/repository_imp.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/repository/repository.dart';

class GetLastMatchUseCase {
  RepositoryMatch repositoryMatch = RepositoryMatchImp();
  Future<Either<LastMatchFailure, AMatch>> call() {
    return repositoryMatch.getLastMatch();
  }
}

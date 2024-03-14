import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/repository/repositroy_imp.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMatchUseCase {
  Future<Either<FireStoreFailure, Unit>> call({required AMatch match}) async {
    Repository repository = RepositoryImp(
        remoteData: RemoteFB(),
        localDataSource: LocalDataSourceImp(
            sharedPreferences: await SharedPreferences.getInstance()));
    return repository.addMatch(match: match);
  }
}

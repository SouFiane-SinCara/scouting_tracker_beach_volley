import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/repository/repositroy_imp.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/repository/repository.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocationDateUseCase {
  Future<Either<FireStoreFailure, List<Map>>> call(
      {required Account account, required String tournamentTitle}) async {
    Repository repository = RepositoryImp(
        remoteData: RemoteFB(),
        localDataSource: LocalDataSourceImp(
            sharedPreferences: await SharedPreferences.getInstance()));

    return repository.getlocationsTournaments(
        account: account, tournamentTitle: tournamentTitle);
  }
}

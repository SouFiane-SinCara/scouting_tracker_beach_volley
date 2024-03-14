import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/repository/repositroy_imp.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/repository/repository.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/repository/repository_imp.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/source/local.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/source/remote.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUseCase {
  Future<Either<LoginFailure, Account>> call({required Account account}) async {
    RepositoryAuth repository = RepositoryAuthImp(
        remoteData: AuthRemoteDataFB(
            localDataAccount: LocalDataSharedPereference(
                sharedPreferences: await SharedPreferences.getInstance())));

    return repository.login(account: account);
  }
}

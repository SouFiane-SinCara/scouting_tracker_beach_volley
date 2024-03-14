import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/repository/repository_imp.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/source/local.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/source/remote.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpUseCase {
  Future<Either<SignUpFailure, Account>> call(
      {required Account account}) async {
    RepositoryAuth repositoryAuth = RepositoryAuthImp(
        remoteData: AuthRemoteDataFB(
            localDataAccount: LocalDataSharedPereference(
                sharedPreferences: await SharedPreferences.getInstance())));

    return repositoryAuth.signUp(account: account);
  }
}

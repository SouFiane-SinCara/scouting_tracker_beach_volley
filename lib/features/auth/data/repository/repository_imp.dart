// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/exeptions/exeptions.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/source/remote.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/repository/repository.dart';

class RepositoryAuthImp extends RepositoryAuth {
  AuthRemoteData remoteData;
  RepositoryAuthImp({
    required this.remoteData,
  });
  @override
  Future<Either<SignUpFailure, Account>> signUp(
      {required Account account}) async {
    try {
      await remoteData.signUp(account: account);
      return Right(account);
    } on PasswordSizeExeption {
      return Left(PasswordSizeFailure());
    } on CharactersPasswordExeption {
      return Left(CharactersPasswordFailure());
    } on ServerExpetion {
      return Left(ServerFailure());
    } on EmailAlreadyExistedExeption {
      return Left(EmailAlreadyExistedFailure());
    } on EmailFormExeption {
      return Left(EmailFormFailure());
    } on EmpityUserNameExeption {
      return Left(EmpityUserNameFailure());
    } on EmpityEmailExeption {
      return Left(EmpityEmailFailure());
    } on UsernameWithSpaceExeption {
      return Left(UsernameWithSpaceFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<LoginFailure, Account>> login(
      {required Account account}) async {
    try {
      Account acc = await remoteData.login(account: account);
      return Right(acc);
    } on NewClientExeption {
      return Left(NewClientFailure());
    } on WorngPasswordExeption {
      return Left(WorngPasswordFailure());
    } on UserNotFoundExeption {
      return Left(UserNotFoundFailure());
    } on InvalidEmailExeption {
      return Left(InvalidEmailFailure());
    } on UserDisabledExeption {
      return Left(UserDisabledFailure());
    } on LoginServerExeption {
      return Left(LoginServerFailure());
    }
  }
}

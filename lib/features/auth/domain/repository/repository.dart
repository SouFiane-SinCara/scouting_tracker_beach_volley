import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scouting_tracker_beach_volley/core/errors/failures/failures.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

abstract class RepositoryAuth {
  Future<Either<SignUpFailure, Account>> signUp({required Account account});
  Future<Either<LoginFailure, Account>> login({required Account account});
}

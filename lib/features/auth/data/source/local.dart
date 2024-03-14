// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:scouting_tracker_beach_volley/core/errors/exeptions/exeptions.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataAccount {
  Future storageData({required Account account});
  Future<Either<SharedPereferenceExeption, Account>> getdata();
  Future delete();
}

class LocalDataSharedPereference extends LocalDataAccount {
  SharedPreferences sharedPreferences;
  LocalDataSharedPereference({
    required this.sharedPreferences,
  });
  @override
  Future<Either<SharedPereferenceExeption, Account>> getdata() async {
    List<String>? account = sharedPreferences.getStringList('account');
    if (account == null) {
      return Left(EmpitySharedPereferenceExeption());
    } else {
      return Right(Account(
          username: account[0], email: account[1], password: account[2]));
    }
  }

  @override
  Future storageData({required Account account}) async {
    
    bool f = await sharedPreferences.setStringList(
        'account', [account.username, account.email, account.password]);
    
  }

  @override
  Future delete() async {
    await sharedPreferences.clear();
  }
}

import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

class AccountModel extends Account {
  const AccountModel(
      {required super.username, required super.email, required super.password});
  factory AccountModel.fromJson(Map e) {
    return AccountModel(
        username: e['username'], email: e['email'], password: e['password']);
  }
  Map<String,String> toJson(Account account) {
    return {
      "username": account.username,
      "email": account.email,
      "password": account.password
    };
  }
}

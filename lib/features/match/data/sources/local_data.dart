// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSouceMatch {
  Future<Map<String, dynamic>> getLastMatch();
  Future storageCurentMatchData({
    required String email,
    required String titlematch,
    required String tournamentTitle,
    required String location,
    required String date,
  });
}

class LocalDataSourceMatchSharedPereference extends LocalDataSouceMatch {
  SharedPreferences sharedPreferences;
  LocalDataSourceMatchSharedPereference({
    required this.sharedPreferences,
  });
  @override
  Future storageCurentMatchData({
    required String email,
    required String titlematch,
    required String tournamentTitle,
    required String location,
    required String date,
  }) async {
    await sharedPreferences.setStringList(
        'match', [location, date, tournamentTitle, titlematch, email]);
  }

  @override
  Future<Map<String, dynamic>> getLastMatch() async {
    List<String>? data = sharedPreferences.getStringList('match');

    return {
      'location': data != null ? data[0] : null,
      'date': data != null ? data[1] : null,
      'tournamentTitle': data != null ? data[2] : null,
      'titleMatch': data != null ? data[3] : null,
      'email': data != null ? data[4] : null
    };
  }
}

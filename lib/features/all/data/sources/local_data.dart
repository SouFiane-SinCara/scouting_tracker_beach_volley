// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  storageData(String lang);
  getData();
}

class LocalDataSourceImp extends LocalDataSource {
  SharedPreferences sharedPreferences;
  LocalDataSourceImp({
    required this.sharedPreferences,
  });

  @override
  storageData(String lang) async {
    await sharedPreferences.setString("lang", lang);
  }

  @override
  String getData() {
    String? result = sharedPreferences.getString("lang");
    return result ?? "en";
  }
}

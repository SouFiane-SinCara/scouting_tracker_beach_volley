// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/storage_language_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scouting_tracker_beach_volley/features/all/data/repository/repositroy_imp.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/use_cases/get_language_use_case.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());
  Future<void> changeLanguage(String language) async {
    emit(LanguageInitial());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String lang = GetLanguageUseCase(
            repository: RepositoryImp(
                remoteData: RemoteFB(),
                localDataSource:
                    LocalDataSourceImp(sharedPreferences: sharedPreferences)))
        .call();
    if (language == "") {
      if (lang == "it") {
        emit(ItState());
      } else {
        emit(EnState());
      }
    } else if (language == "en") {
      StorageLanguageUseCase(
              repository: RepositoryImp(
                  remoteData: RemoteFB(),
                  localDataSource:
                      LocalDataSourceImp(sharedPreferences: sharedPreferences)))
          .call("en");
      emit(EnState());
    } else {
      StorageLanguageUseCase(
              repository: RepositoryImp(
                  remoteData: RemoteFB(),
                  localDataSource:
                      LocalDataSourceImp(sharedPreferences: sharedPreferences)))
          .call("it");
      emit(ItState());
    }
  }
}

import 'package:scouting_tracker_beach_volley/features/all/domain/repository/repository.dart';

class StorageLanguageUseCase {
  Repository repository;
  StorageLanguageUseCase({
    required this.repository,
  });
  call(String lang) {
    return repository.storageLanguage(lang);
  }
}

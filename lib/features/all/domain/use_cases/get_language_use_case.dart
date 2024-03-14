import 'package:scouting_tracker_beach_volley/features/all/domain/repository/repository.dart';

class GetLanguageUseCase {
  Repository repository ;
  
  GetLanguageUseCase({required this.repository});
  call() {
    return repository.getLanguage();
  }
}

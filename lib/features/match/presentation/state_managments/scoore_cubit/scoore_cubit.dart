import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';

part 'scoore_state.dart';

class ScooreCubit extends Cubit<ScooreState> {
  
  ScooreCubit() : super(ScooreInitial());
  void getSccore(
      {required int rouandSet,
      required int homeScoore,
      required int homeset1,
      required int homeset2,
      required int homeset3,
      required int awayset1,
      required int awayset2,
      required int awayset3,
      required int currentSet,
      required int awayScoore,
      bool? isDelete,
      required bool? home}) {
    emit(ScooreInitial());
    RemoteDataSourceGetLastMatch remoteDataSourceGetLastMatch =
        RemoteDataSourceGetLastMatchFB();
    
    
    isDelete == null
        ? home != null
            ? remoteDataSourceGetLastMatch.addPoint(
                home: home,
                scoore: home ? homeScoore : awayScoore,
                rouand: currentSet)
            : null
        : home != null
            ? remoteDataSourceGetLastMatch.addPoint(
                isDelete: true,
                home: home,
                scoore: home ? homeScoore : awayScoore,
                rouand: currentSet)
            : null;

    if (home != null) {
      if (home) {
        if (currentSet == 1) {
          isDelete != null ? homeset1-- : homeset1++;
        } else if (currentSet == 2) {
          isDelete != null ? homeset2-- : homeset2++;
        } else if (currentSet == 3) {
          isDelete != null ? homeset3-- : homeset3++;
        }
      } else {
        if (currentSet == 1) {
          isDelete != null ? awayset1-- : awayset1++;
        } else if (currentSet == 2) {
          isDelete != null ? awayset2-- : awayset2++;
        } else if (currentSet == 3) {
          isDelete != null ? awayset3-- : awayset3++;
        }
      }
    }

    emit(NewSccoreState(
        homeSccore: homeScoore,
        awaySccore: awayScoore,
        awaySet1: awayset1,
        awaySet2: awayset2,
        awaySet3: awayset3,
        homeSet1: homeset1,
        homeSet2: homeset2,
        currentSet: currentSet,
        homeSet3: homeset3));
  }
}

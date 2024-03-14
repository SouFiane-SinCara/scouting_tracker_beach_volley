import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sets_state.dart';

class SetsCubit extends Cubit<SetsState> {
  int ?currentSet ;

  SetsCubit() : super(SetsInitial());
  void ChangeSets(SetsState newSetState, int ?newSet) {
    emit(SetsInitial());
    emit(newSetState);
    currentSet = newSet;
  }
}

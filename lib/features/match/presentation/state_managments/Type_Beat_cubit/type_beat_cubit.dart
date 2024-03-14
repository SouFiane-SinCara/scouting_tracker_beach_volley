import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'type_beat_state.dart';

class TypeBeatCubit extends Cubit<TypeBeatState> {
  String typeBeat='normal';
  TypeBeatCubit() : super(TypeBeatInitial());
  void changeBeatType(TypeBeatState typeBeatState) {
    
    if (typeBeatState is FloatState) {
      typeBeat = 'flaot';
      emit(FloatState());
    } else if (typeBeatState is JumpState) {
      typeBeat = 'jump';
      emit(JumpState());
    } else if (typeBeatState is JumpFloatState) {
      typeBeat = 'jumpFloat';
      emit(JumpFloatState());
    } else if (typeBeatState is HybirdState) {
      typeBeat = 'hybird';
      emit(HybirdState());
    } else if (typeBeatState is NormaleState) {
      typeBeat = 'normal';
      emit(NormaleState());
    }else{
       emit(TypeBeatInitial());
    }
  }
}

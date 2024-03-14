import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'riser_type_state.dart';

class RiserTypeCubit extends Cubit<RiserTypeState> {
  String ?typeofriser;
  RiserTypeCubit() : super(RiserTypeInitial());
  void newTypeRise(RiserTypeState riserTypeState){
    if(riserTypeState is QuickRiseState){
      emit(QuickRiseState());
      
    }else if(riserTypeState is BehindRiseState){
      emit(BehindRiseState());
    
    }else if(riserTypeState is SuperRiseState){
      emit(SuperRiseState());
    
    }else if(riserTypeState is NormalRiseState){
      emit(NormalRiseState());
    }else {
      emit(RiserTypeInitial());
    }
  }
}

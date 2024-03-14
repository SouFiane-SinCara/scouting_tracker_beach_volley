import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'graphic_or_state_state.dart';

class GraphicOrStateCubit extends Cubit<GraphicOrStateState> {
  GraphicOrStateCubit() : super(GraphicOrStateInitial());
 void change(GraphicOrStateState newstate){
    emit(GraphicOrStateInitial());
    emit(newstate);
 } 
}

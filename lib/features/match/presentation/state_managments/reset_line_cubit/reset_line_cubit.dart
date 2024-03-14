import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reset_line_state.dart';

class ResetLineCubit extends Cubit<ResetLineState> {
  ResetLineCubit() : super(ResetLineInitial());
  void reset(){

    emit(ResetLineInitial());
    emit(ResetNowState());
  }
}

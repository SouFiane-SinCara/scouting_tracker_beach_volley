import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'acctions_play_state.dart';

class AcctionsPlayCubit extends Cubit<AcctionsPlayState> {
  
  AcctionsPlayCubit() : super(AcctionsPlayInitial());
  
  
}

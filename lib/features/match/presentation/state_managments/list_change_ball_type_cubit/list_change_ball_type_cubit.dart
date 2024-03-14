import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_change_ball_type_state.dart';

class ListChangeBallTypeCubit extends Cubit<ListChangeBallTypeState> {
  String currentChangeBallList = "All Change ball ";
  ListChangeBallTypeCubit() : super(ListChangeBallTypeInitial());
  void changeBallType(String changeBallList){
    currentChangeBallList = changeBallList;
  }
}

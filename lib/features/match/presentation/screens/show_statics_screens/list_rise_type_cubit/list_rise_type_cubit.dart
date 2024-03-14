import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_rise_type_state.dart';

class ListRiseTypeCubit extends Cubit<ListRiseTypeState> {
  String rise= 'select rise';
  ListRiseTypeCubit() : super(ListRiseTypeInitial());
  void changeRise(String changeRise){
    rise = changeRise ;
  }
}

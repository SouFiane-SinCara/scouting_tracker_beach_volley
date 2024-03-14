import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_wall_state.dart';

class ListWallCubit extends Cubit<ListWallState> {
  String typeWall="all"; 
  ListWallCubit() : super(ListWallInitial());
   void wallType(String type) {
    typeWall = type;
  }
}

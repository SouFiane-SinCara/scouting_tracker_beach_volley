import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_type_lines_state.dart';

class ListTypeLinesCubit extends Cubit<ListTypeLinesState> {
  String lineType = 'select type Line';
  ListTypeLinesCubit() : super(ListTypeLinesInitial());
  void changeLineType(String type) {
    lineType = type;
  }
}

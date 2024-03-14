import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rouand_state.dart';

class RouandCubit extends Cubit<RouandState> {
  RouandCubit() : super(RouandInitial());
  void nextRouand(int rouandNum) {
    emit(RouandInitial());
    emit(NextRouandState(rouandNum: rouandNum,));
  }
}

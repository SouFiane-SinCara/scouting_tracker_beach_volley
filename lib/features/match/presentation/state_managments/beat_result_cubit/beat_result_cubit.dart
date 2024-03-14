import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'beat_result_state.dart';

class BeatResultCubit extends Cubit<BeatResultState> {
  BeatResultCubit() : super(BeatResultInitial());
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';

part 'direction_state.dart';

class DirectionCubit extends Cubit<DirectionState> {
  DirectionCubit() : super(DirectionInitial());
  Future<void> newDirection({required int newDirection}) async {
    emit(DirectionInitial());
    RemoteDataSourceGetLastMatch  remoteDataSourceGetLastMatch =
        RemoteDataSourceGetLastMatchFB();
    await remoteDataSourceGetLastMatch.windUplaod(direction: newDirection);
    
    emit(NewDirectionState(direction: newDirection));
  }
}

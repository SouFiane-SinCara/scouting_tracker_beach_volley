import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  int ?team;
  TeamCubit() : super(TeamInitial());
  void changeTeam(int newTeam){
    
    team = newTeam;
  }
}

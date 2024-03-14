import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'attack_type_state.dart';

class AttackTypeCubit extends Cubit<AttackTypeState> {
  int breackpointNum = -1;

  int? team;
  int? player;
  AttackTypeCubit() : super(AttackTypeInitial());

  void newAttack(AttackTypeState attackTypeState) {
    
    if (attackTypeState is BreackPointState) {
      emit(AttackTypeInitial());

      breackpointNum++;
      player = attackTypeState.player;
      team = attackTypeState.team;
      emit(BreackPointState(
          team: team!, player: player!, breakPoint: breackpointNum));
    } else if (attackTypeState is ChangeBallState) {
      player = attackTypeState.player;
      team = attackTypeState.team;
      emit(attackTypeState);
    } else if (attackTypeState is ReceptionState) {
      player = attackTypeState.player;
      team = attackTypeState.team;
      emit(ReceptionState(player: player!,team: team!));
    }else{
       breackpointNum = -1;
      emit(attackTypeState);
    }
  }
}

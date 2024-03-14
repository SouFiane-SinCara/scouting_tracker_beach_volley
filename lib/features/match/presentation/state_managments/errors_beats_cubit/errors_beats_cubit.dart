import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/repository/repository_imp.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_type_cubit/attack_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/show_player_on_field_cubit/show_player_on_field_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/team_cubit/team_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';

part 'errors_beats_state.dart';

class ErrorsBeatsCubit extends Cubit<ErrorsBeatsState> {
  ErrorsBeatsCubit() : super(ErrorsBeatsInitial());

  Future<void> cheack(
      {required int? player,
      bool? isbatting,
      bool? deletable,
      required int? team,
      required Player? playerSelected,
      required bool continuedLine,
      required Offset p1,
      String? attackOption,
      required Offset p2,
      String? attackOptions,
      bool? isimmediateAce,
      bool? isWall,
      bool? wittoutChangeBK,
      required int curentSet,
      required AttackTypeState attackTypeState,
      required String stateName,
      required String method,
      required String type,
      required BuildContext context}) async {
    emit(ErrorsBeatsInitial());
    AppLocalizations? lang = AppLocalizations.of(context);

    if (playerSelected == null) {
      emit(ErrorSatate(lang!.playernotselected));
    } else {
      try {
        int? breackPoint =
            BlocProvider.of<AttackTypeCubit>(context).breackpointNum;

        RepositoryMatchImp? repositoryMatchImp = RepositoryMatchImp();
        await repositoryMatchImp.addBeat(
            beatAction: BeatAction(
                breackpointNum: breackPoint,
                currentSet: curentSet,
                playerNumber: player!,
                playerTeam: team!,
                deletable: deletable,
                state: stateName,
                method: method,
                player: playerSelected,
                continued: continuedLine,
                p2: p2,
                attackOption: attackOption,
                playersurname: playerSelected.surname,
                p1: p1,
                type: type));

        isbatting != null ||
                isWall != null ||
                isimmediateAce != null ||
                wittoutChangeBK != null
            ? null
            : BlocProvider.of<AttackTypeCubit>(context)
                .newAttack(attackTypeState);
        emit(ErrorsBeatsInitial());

        if (isimmediateAce == null) {
          BlocProvider.of<TeamCubit>(context).changeTeam(team);
        }
        if (method == "defendedattack" ||
            method == "plus" ||
            method == "minus") {
          ShowPlayerOnFieldState playerField =
              BlocProvider.of<ShowPlayerOnFieldCubit>(context).state;

          if (playerField is ShowNewPlayerOnFieldState) {
            BlocProvider.of<ShowPlayerOnFieldCubit>(context).showPlayer(
                firstPlayer: true, redTeam: playerField.redTeam ? false : true);
          }
        }
      } catch (e) {}
    }
  }
}

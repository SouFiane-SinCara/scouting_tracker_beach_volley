import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/Type_Beat_cubit/type_beat_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_options_cubit/attack_options_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_type_cubit/attack_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/ball_line_cubit/ball_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/errors_beats_cubit/errors_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_choose_cubit/choose_player_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';

class EndAction extends StatelessWidget {
  const EndAction({super.key, required this.data});
  final Map data;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    AMatch match = data['match'];

    AppLocalizations? lang = AppLocalizations.of(context);
    List<List> actions = [
      [lang!.attachmentPoint, "attachmentPointBK"],
      [lang.attackError, "attackErrorBK"],
      [lang.walledAttackbyPlayer, "attackErrorBK"],
      [lang.walledAttackbyPlayer, "attackErrorBK"],
      [lang.errorRaised, "errorRaisedBK"],
    ];
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<AttackTypeCubit, AttackTypeState>(
          builder: (context, attackType) {
            return Text(attackType is ReceptionState
                ? lang.reception
                : attackType is BreackPointState && attackType.breakPoint != 0
                    ? '${lang.breakPoint} Nr ${attackType.breakPoint}'
                    : lang.changeBall);
          },
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: actions.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onLongPress: () {
                    print("end acction : ${data['team']}}");
                    Player? playerSelected =
                        BlocProvider.of<ChoosePlayerCubit>(context).player;
                    print("end acction : $playerSelected");
                  },
                  onTap: () async {
                    Player? playerSelected =
                        BlocProvider.of<ChoosePlayerCubit>(context).player;
                    bool? continuedLine =
                        BlocProvider.of<BallLineCubit>(context).continued;
                    String? attackoption =
                        BlocProvider.of<AttackOptionsCubit>(context)
                            .state
                            .toString();
                    Offset? p1 =
                        BlocProvider.of<BallLineCubit>(context).startPoint;
                    Offset? p2 =
                        BlocProvider.of<BallLineCubit>(context).endPoint;
                    String type =
                        BlocProvider.of<TypeBeatCubit>(context).typeBeat;
                    AttackTypeState attackType =
                        BlocProvider.of<AttackTypeCubit>(context).state;
                    int breackPoint = BlocProvider.of<AttackTypeCubit>(context)
                        .breackpointNum;

                    await BlocProvider.of<ErrorsBeatsCubit>(context).cheack(
                        attackTypeState: BreackPointState(
                            breakPoint: breackPoint,
                            player: data['player']!,
                            team: data['team']),
                        curentSet: data['currentSet'],
                        method: actions[index][1],
                        stateName: attackType.toString(),
                        player:  playerSelected==null?null: int.parse(playerSelected.player),
                        team: data['team'] == 1 ? 2 : 1,
                        continuedLine: continuedLine,
                        deletable: index == 3 || index == 2 ? null : true,
                        p1: p1,
                        p2: p2,
                        isWall: index == 3 || index == 2 ? true : null,
                        attackOption: attackoption,
                        playerSelected:  playerSelected,
                        type: type,
                        context: context);
                    
                    if (index == 3 || index == 2) {
                      BlocProvider.of<AttackTypeCubit>(context)
                              .breackpointNum ==
                          breackPoint - 1;
                      await BlocProvider.of<ErrorsBeatsCubit>(context).cheack(
                          attackTypeState: BreackPointState(
                              breakPoint: breackPoint,
                              player: data['player']!,
                              team: data['team']),
                          curentSet: data['currentSet'],
                          method: "WallAttackBK",
                          deletable: true,
                          stateName: attackType.toString(),
                          player: data['team'] == 1
                              ? index == 2
                                  ? int.parse(match.player1.player)
                                  : int.parse(match.player2.player)
                              : index == 2
                                  ? int.parse(match.player3.player)
                                  : int.parse(match.player4.player),
                          team: data['team'],
                          continuedLine: continuedLine,
                          p1: p1,
                          p2: p2,
                          attackOption: attackoption,
                          playerSelected: playerSelected ==null ?null: data['team'] == 1
                              ? index == 2
                                  ? match.player1
                                  : match.player2
                              : index == 2
                                  ? match.player3
                                  : match.player4,
                          type: type,
                          context: context);
                    }

                    if (BlocProvider.of<ErrorsBeatsCubit>(context).state
                        is ErrorSatate) {
                      Navigator.pop(context, null);
                    } else {
                      if (index == 0) {
                        if (data['team'] == 1) {
                          Navigator.pop(context, {'team': 2});
                        } else {
                          Navigator.pop(context, {'team': 1});
                        }
                      } else {
                        Navigator.pop(context, {'team': data['team']});
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                        horizontal: size.width * 0.05),
                    height: size.height * 0.1,
                    width: size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                        vertical: size.height * 0.03),
                    child: FittedBox(
                        child: Text(
                      index == 2 || index == 3
                          ? " ${lang.walledAttackbyPlayer} => ${data['team'] == 1 ? index == 2 ? match.player1.surname : match.player2.surname : index == 2 ? match.player3.surname : match.player4.surname}"
                          : actions[index][0],
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

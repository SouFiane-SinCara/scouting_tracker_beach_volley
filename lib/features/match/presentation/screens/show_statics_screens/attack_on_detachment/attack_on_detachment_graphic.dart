import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_change_ball_type_cubit/list_change_ball_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_type_lines_cubit/list_type_lines_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_wall_cubit/list_wall_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/beats_colors_info.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttackOnDetachmentGraphic extends StatelessWidget {
  final bool? isAttackOftwoState;
  const AttackOnDetachmentGraphic({super.key, this.isAttackOftwoState});

  @override
  Widget build(BuildContext context) {
    Size size = device(context);

    ThemeData theme = Theme.of(context);
    AppLocalizations? lang = AppLocalizations.of(context);

    List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;
    List<Map> attackOnDetachmentLines = [];
    beats.forEach(
      (element) {
        if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                element.playersurname ||
            BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                "select a player" ||
            BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                lang!.allPlayers) {
          String? linetype;
          BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                  lang!.allBreackPoint
              ? linetype = '0'
              : BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                      lang.allChangeBall
                  ? linetype = '1'
                  : linetype = null;

          if (linetype == '0') {
            if (element.breackpointNum == 0 &&
                (element.state == "BreackPointState" || element.state == "BreackPointState()") ) {
              if (element.currentSet ==
                      BlocProvider.of<SetsCubit>(context).currentSet ||
                  BlocProvider.of<SetsCubit>(context).currentSet == null) {
                if ((( element.attackOption == 'DefededAttackState' ||( element.attackOption == 'DefededAttackState' ||element.attackOption == 'DefededAttackState()')) &&
                        isAttackOftwoState == null) || 
                    (( element.attackOption == 'SecondAttackState' || ( element.attackOption == 'SecondAttackState' || element.attackOption == 'SecondAttackState()' ) )&&
                        isAttackOftwoState != null)) {
                  if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                          .currentChangeBallList ==
                      lang!.right) {
                    if ((element.p1.dx < 150 && element.p1.dy > 85) ||
                        (element.p1.dx > 150 && element.p1.dy < 64)) {
                      element.method == "WallAttackBK"
                          ? null
                          : attackOnDetachmentLines.add({
                              "p1": element.p1,
                              "p2": element.p2,
                              "continued": element.continued,
                              "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black
                            });
                    }
                  } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                          .currentChangeBallList ==
                      lang!.center) {
                    if (element.p1.dy < 85 && element.p1.dy > 64) {
                      element.method == "WallAttackBK"
                          ? null
                          : attackOnDetachmentLines.add({
                              "p1": element.p1,
                              "p2": element.p2,
                              "continued": element.continued,
                              "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                            });
                    }
                  } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                          .currentChangeBallList ==
                      lang!.left) {
                    if ((element.p1.dy < 64 && element.p1.dx < 150) ||
                        (element.p1.dy > 85 && element.p1.dx > 150)) {
                      element.method == "WallAttackBK"
                          ? null
                          : attackOnDetachmentLines.add({
                              "p1": element.p1,
                              "p2": element.p2,
                              "continued": element.continued,
                              "color":element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                            });
                    }
                  } else {
                    element.method == "WallAttackBK"
                        ? null
                        : attackOnDetachmentLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color":element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                          });
                  }
                }
              }
            }
          } else if (linetype == '1') {
            if ((element.state == "BreackPointState" || element.state == "BreackPointState()")  &&
                element.breackpointNum > 0) {
              if (element.currentSet ==
                      BlocProvider.of<SetsCubit>(context).currentSet ||
                  BlocProvider.of<SetsCubit>(context).currentSet == null) {
                if ((( element.attackOption == 'DefededAttackState' ||element.attackOption == 'DefededAttackState()') &&
                        isAttackOftwoState == null) ||
                    (( element.attackOption == 'SecondAttackState' || element.attackOption == 'SecondAttackState()' ) &&
                        isAttackOftwoState != null)) {
                  if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                          .currentChangeBallList ==
                      lang!.right) {
                    if ((element.p1.dx < 150 && element.p1.dy > 85) ||
                        (element.p1.dx > 150 && element.p1.dy < 64)) {
                      element.method == "WallAttackBK"
                          ? null
                          : attackOnDetachmentLines.add({
                              "p1": element.p1,
                              "p2": element.p2,
                              "continued": element.continued,
                              "color":element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                            });
                    }
                  } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                          .currentChangeBallList ==
                      lang!.center) {
                    if (element.p1.dy < 85 && element.p1.dy > 64) {
                      element.method == "WallAttackBK"
                          ? null
                          : attackOnDetachmentLines.add({
                              "p1": element.p1,
                              "p2": element.p2,
                              "continued": element.continued,
                              "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                            });
                    }
                  } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                          .currentChangeBallList ==
                      lang!.left) {
                    if ((element.p1.dy < 64 && element.p1.dx < 150) ||
                        (element.p1.dy > 85 && element.p1.dx > 150)) {
                      element.method == "WallAttackBK"
                          ? null
                          : attackOnDetachmentLines.add({
                              "p1": element.p1,
                              "p2": element.p2,
                              "continued": element.continued,
                              "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                            });
                    }
                  } else {
                    element.method == "WallAttackBK"
                        ? null
                        : attackOnDetachmentLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                          });
                  }
                }
              }
            }
          } else {
            if (element.currentSet ==
                    BlocProvider.of<SetsCubit>(context).currentSet ||
                BlocProvider.of<SetsCubit>(context).currentSet == null) {
              if ((( element.attackOption == 'DefededAttackState' ||element.attackOption == 'DefededAttackState()') &&
                      isAttackOftwoState == null) ||
                  (( element.attackOption == 'SecondAttackState' || element.attackOption == 'SecondAttackState()' ) &&
                      isAttackOftwoState != null)) {
                if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                        .currentChangeBallList ==
                    lang!.right) {
                  if ((element.p1.dx < 150 && element.p1.dy > 85) ||
                      (element.p1.dx > 150 && element.p1.dy < 64)) {
                    element.method == "WallAttackBK"
                        ? null
                        : attackOnDetachmentLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color":element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                          });
                  }
                } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                        .currentChangeBallList ==
                    lang!.center) {
                  if (element.p1.dy < 85 && element.p1.dy > 64) {
                    element.method == "WallAttackBK"
                        ? null
                        : attackOnDetachmentLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                          });
                  }
                } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                        .currentChangeBallList ==
                    lang!.left) {
                  if ((element.p1.dy < 64 && element.p1.dx < 150) ||
                      (element.p1.dy > 85 && element.p1.dx > 150)) {
                    element.method == "WallAttackBK"
                        ? null
                        : attackOnDetachmentLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                          });
                  }
                } else {
                  element.method == "WallAttackBK"
                      ? null
                      : attackOnDetachmentLines.add({
                          "p1": element.p1,
                          "p2": element.p2,
                          "continued": element.continued,
                          "color": element.method == "attachmentPointBK"?Colors.green:element.method == "replayableattack"?Colors.yellow:element.method == "defendedattack"?Colors.red: Colors.black

                        });
                }
              }
            }
          }
        }
      },
    );
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.091,
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.05,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      border: Border.all(width: 2, color: theme.primaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: BlocBuilder<LastMatchCubit, LastMatchState>(
                    builder: (context, state) {
                      if (state is StartedMatchState) {
                        return SvgPicture.asset(
                          'lib/core/assets/icons/wind_direction_icons/${state.aMatch.wind}.svg',
                          color: theme.primaryColor,
                        );
                      } else {
                        return SvgPicture.asset(
                          'lib/core/assets/icons/wind_direction_icons/${0}.svg',
                          color: theme.primaryColor,
                        );
                      }
                    },
                  ),
                ),

                  
                  BeatColorsInfo(info1: ColorTitle(color: Colors.green, title: lang!.point+" #"),
                  info2: ColorTitle(color: Colors.red, title: lang.defendedAttack+" -"),
                  info3: ColorTitle(color: Colors.yellow, title: lang.replayableattack.contains("+")?lang.replayableattack:lang.replayableattack+" +"),
                  info4: ColorTitle(color: Colors.black,title: lang.attackError+" ="),)
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          SizedBox(
              width: 300,
              height: 150,
              child: VolleyballField(
                isShowStatics: true,
                lines: attackOnDetachmentLines,
              )),
        ],
      ),
    );
  }
}

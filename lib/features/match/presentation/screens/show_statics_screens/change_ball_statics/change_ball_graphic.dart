import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/list_rise_type_cubit/list_rise_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_change_ball_type_cubit/list_change_ball_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_type_lines_cubit/list_type_lines_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/beats_colors_info.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeBallGraphic extends StatefulWidget {
  final bool? isBreakPoint;
  const ChangeBallGraphic({super.key, this.isBreakPoint});

  @override
  State<ChangeBallGraphic> createState() => _ChangeBallGraphicState();
}

class _ChangeBallGraphicState extends State<ChangeBallGraphic> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations? lang = AppLocalizations.of(context);

    Size size = device(context);
    List<Map> changeballLines = [];
    List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;
    beats.forEach((element) {
      if (element.currentSet ==
              BlocProvider.of<SetsCubit>(context).currentSet ||
          BlocProvider.of<SetsCubit>(context).currentSet == null) {

            print("attack : ${element.method}");
        if (((element.state == "BreackPointState" ||
                    element.state == "BreackPointState()") &&
                element.breackpointNum == 0 &&
                widget.isBreakPoint == null) ||
            ((element.state == "BreackPointState" ||
                    element.state == "BreackPointState()") &&
                element.breackpointNum != 0 &&
                widget.isBreakPoint != null)) {
          String lineType =
              element.continued ? lang!.continued : lang!.discontinued;
          if (BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                  lineType ||
              BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                  'select type Line' ||
              BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                  lang!.selectLineType) {
            if ((BlocProvider.of<PlayerSelectStaticsCubit>(context)
                            .playersurname ==
                        element.playersurname ||
                    BlocProvider.of<PlayerSelectStaticsCubit>(context)
                            .playersurname ==
                        lang!.allPlayers ||
                    BlocProvider.of<PlayerSelectStaticsCubit>(context)
                            .playersurname ==
                        "select a player") &&
                (BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                        element.type ||
                    BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                        'select rise' ||
                    BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                        lang!.selectrise)) {
              if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                      .currentChangeBallList ==
                  lang!.right) {
                if ((element.p1.dx < 150 && element.p1.dy > 85) ||
                    (element.p1.dx > 150 && element.p1.dy < 64)) {
                  element.method == "WallAttackBK"
                      ? null
                      : changeballLines.add({
                          "p1": element.p1,
                          "p2": element.p2,
                          "continued": element.continued,
                          "color": element.method == "replayableattack"
                              ? Colors.yellow
                              : element.method == "defendedattack"
                                  ? Colors.red
                                  : element.method == "attachmentPointBK"
                                      ? Colors.green
                                      : Colors.black
                        });
                }
              } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                      .currentChangeBallList ==
                  lang!.center) {
                if (element.p1.dy < 85 && element.p1.dy > 64) {
                  element.method == "WallAttackBK"
                      ? null
                      : changeballLines.add({
                          "p1": element.p1,
                          "p2": element.p2,
                          "continued": element.continued,
                          "color": element.method == "replayableattack"
                              ? Colors.yellow
                              : element.method == "defendedattack"
                                  ? Colors.red
                                  : element.method == "attachmentPointBK"
                                      ? Colors.green
                                      : Colors.black
                        });
                }
              } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                      .currentChangeBallList ==
                  lang!.left) {
                if ((element.p1.dy < 64 && element.p1.dx < 150) ||
                    (element.p1.dy > 85 && element.p1.dx > 150)) {
                  element.method == "WallAttackBK"
                      ? null
                      : changeballLines.add({
                          "p1": element.p1,
                          "p2": element.p2,
                          "continued": element.continued,
                          "color": element.method == "replayableattack"
                              ? Colors.yellow
                              : element.method == "defendedattack"
                                  ? Colors.red
                                  : element.method == "attachmentPointBK"
                                      ? Colors.green
                                      : Colors.black
                        });
                }
              } else {
                element.method == "WallAttackBK"
                    ? null
                    : changeballLines.add({
                        "p1": element.p1,
                        "p2": element.p2,
                        "continued": element.continued,
                        "color": element.method == "replayableattack"
                            ? Colors.yellow
                            : element.method == "defendedattack"
                                ? Colors.red
                                : element.method == "attachmentPointBK"
                                    ? Colors.green
                                    : Colors.black
                      });
              }
            }
          }
        } else {
          if ((element.state == "BreackPointState()" &&
                  element.breackpointNum == 0 &&
                  widget.isBreakPoint == null) ||
              (element.state == "BreackPointState()" &&
                  element.breackpointNum != 0 &&
                  widget.isBreakPoint != null)) {
                    
            String lineType = element.continued ? 'continued' : 'discontinued';
            if (BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                    lineType ||
                BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                    'select type Line' ||
                BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                    lang!.selectLineType) {
              if ((BlocProvider.of<PlayerSelectStaticsCubit>(context)
                              .playersurname ==
                          element.playersurname ||
                      BlocProvider.of<PlayerSelectStaticsCubit>(context)
                              .playersurname ==
                          lang!.allPlayers ||
                      BlocProvider.of<PlayerSelectStaticsCubit>(context)
                              .playersurname ==
                          "select a player") &&
                  (BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                          element.type ||
                      BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                          'select rise' ||
                      BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                          lang!.selectrise)) {
                if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                        .currentChangeBallList ==
                    lang!.right) {
                  if ((element.p1.dx < 150 && element.p1.dy > 85) ||
                      (element.p1.dx > 150 && element.p1.dy < 64)) {
                    element.method == "WallAttackBK"
                        ? null
                        : changeballLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color": element.method == "replayableattack"
                                ? Colors.yellow
                                : element.method == "defendedattack"
                                    ? Colors.red
                                    : element.method == "attachmentPointBK"
                                        ? Colors.green
                                        : Colors.black
                          });
                  }
                } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                        .currentChangeBallList ==
                    lang!.center) {
                  if (element.p1.dy < 85 && element.p1.dy > 64) {
                    element.method == "WallAttackBK"
                        ? null
                        : changeballLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color": element.method == "replayableattack"
                                ? Colors.yellow
                                : element.method == "defendedattack"
                                    ? Colors.red
                                    : element.method == "attachmentPointBK"
                                        ? Colors.green
                                        : Colors.black
                          });
                  }
                } else if (BlocProvider.of<ListChangeBallTypeCubit>(context)
                        .currentChangeBallList ==
                    lang!.left) {
                  if ((element.p1.dy < 64 && element.p1.dx < 150) ||
                      (element.p1.dy > 85 && element.p1.dx > 150)) {
                    element.method == "WallAttackBK"
                        ? null
                        : changeballLines.add({
                            "p1": element.p1,
                            "p2": element.p2,
                            "continued": element.continued,
                            "color": element.method == "replayableattack"
                                ? Colors.yellow
                                : element.method == "defendedattack"
                                    ? Colors.red
                                    : element.method == "attachmentPointBK"
                                        ? Colors.green
                                        : Colors.black
                          });
                  }
                } else {
                  element.method == "WallAttackBK"
                      ? null
                      : changeballLines.add({
                          "p1": element.p1,
                          "p2": element.p2,
                          "continued": element.continued,
                          "color": element.method == "replayableattack"
                              ? Colors.yellow
                              : element.method == "defendedattack"
                                  ? Colors.red
                                  : element.method == "attachmentPointBK"
                                      ? Colors.green
                                      : Colors.black
                        });
                }
              }
            }
          }
        }
      }
    });
    changeballLines.forEach((element) {
      print("colors :" + element["color"].toString());
    });
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.091,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    )),
                BeatColorsInfo(
                  info1:
                      ColorTitle(color: Colors.green, title: lang!.point + "#"),
                  info2: ColorTitle(
                      color: Colors.red, title: lang.defendedAttack + "-"),
                  info3: ColorTitle(
                      color: Colors.yellow,
                      title: lang.replayableattack.contains("+")
                          ? lang.replayableattack
                          : lang.replayableattack + "+"),
                  info4: ColorTitle(
                      color: Colors.black, title: lang.attackError + "="),
                )
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
                lines: changeballLines,
              )),
        ],
      ),
    );
  }
}

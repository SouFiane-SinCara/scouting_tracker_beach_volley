import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_type_lines_cubit/list_type_lines_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_wall_cubit/list_wall_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/beats_colors_info.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';

class WallGraphic extends StatelessWidget {
  const WallGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = device(context);

    ThemeData theme = Theme.of(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    List<Map> wallLines = [];

    List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;
    beats.forEach((element) {
      bool? lineType;
      BlocProvider.of<ListTypeLinesCubit>(context).lineType == "continue"
          ? lineType = true
          : BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                  "tratteggiate"
              ? lineType = false
              : lineType = null;
      
      if (lineType == element.continued) {
        if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                element.playersurname ||
            BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                "select a player" ||
            BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                lang!.allPlayers) {
          if ((element.state == "BreackPointState" || element.state == "BreackPointState()") &&
              element.method == "WallAttackBK" &&
              (BlocProvider.of<SetsCubit>(context).currentSet ==
                      element.currentSet ||
                  BlocProvider.of<SetsCubit>(context).currentSet == null) &&
              (BlocProvider.of<ListWallCubit>(context).typeWall ==
                      "Cambio Palla" ||
                  BlocProvider.of<ListWallCubit>(context).typeWall ==
                      "Change Ball")) {
            (element.state == "BreackPointState" || element.state == "BreackPointState()") && element.breackpointNum == 0
                ? wallLines.add({
                    "p1": element.p1,
                    "p2": element.p2,
                    "continued": element.continued,
                    "color": Colors.black
                  })
                : null;
          } else if ((element.state == "BreackPointState" || element.state == "BreackPointState()") &&
              element.method == "WallAttackBK" &&
              (BlocProvider.of<SetsCubit>(context).currentSet ==
                      element.currentSet ||
                  BlocProvider.of<SetsCubit>(context).currentSet == null) &&
              (BlocProvider.of<ListWallCubit>(context).typeWall ==
                      "Break Point" ||
                  BlocProvider.of<ListWallCubit>(context).typeWall == 'all' ||
                  BlocProvider.of<ListWallCubit>(context).typeWall ==
                      lang!.all)) {
            ((element.state == "BreackPointState" || element.state == "BreackPointState()") &&
                        element.breackpointNum != 0) ||
                    (BlocProvider.of<ListWallCubit>(context).typeWall ==
                            'all' ||
                        BlocProvider.of<ListWallCubit>(context).typeWall ==
                            lang!.all)
                ? wallLines.add({
                    "p1": element.p1,
                    "p2": element.p2,
                    "continued": element.continued,
                    "color": Colors.black
                  })
                : null;
          }
        }
      } else if (lineType == null) {
        if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                element.playersurname ||
            BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                "select a player" ||
            BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
                lang!.allPlayers) {
          if ((element.state == "BreackPointState" || element.state == "BreackPointState()") &&
              element.method == "WallAttackBK" &&
              (BlocProvider.of<SetsCubit>(context).currentSet ==
                      element.currentSet ||
                  BlocProvider.of<SetsCubit>(context).currentSet == null) &&
              (BlocProvider.of<ListWallCubit>(context).typeWall ==
                      "Cambio Palla" ||
                  BlocProvider.of<ListWallCubit>(context).typeWall ==
                      "Change Ball")) {
            (element.state == "BreackPointState" || element.state == "BreackPointState()") && element.breackpointNum == 0
                ? wallLines.add({
                    "p1": element.p1,
                    "p2": element.p2,
                    "continued": element.continued,
                    "color": Colors.black
                  })
                : null;
          } else if ((element.state == "BreackPointState" || element.state == "BreackPointState()") &&
              element.method == "WallAttackBK" &&
              (BlocProvider.of<SetsCubit>(context).currentSet ==
                      element.currentSet ||
                  BlocProvider.of<SetsCubit>(context).currentSet == null) &&
              (BlocProvider.of<ListWallCubit>(context).typeWall ==
                      "Break Point" ||
                  BlocProvider.of<ListWallCubit>(context).typeWall == 'all' ||
                  BlocProvider.of<ListWallCubit>(context).typeWall ==
                      lang!.all)) {
            ((element.state == "BreackPointState" || element.state == "BreackPointState()") &&
                        element.breackpointNum != 0) ||
                    (BlocProvider.of<ListWallCubit>(context).typeWall ==
                            'all' ||
                        BlocProvider.of<ListWallCubit>(context).typeWall ==
                            lang!.all)
                ? wallLines.add({
                    "p1": element.p1,
                    "p2": element.p2,
                    "continued": element.continued,
                    "color": Colors.black
                  })
                : null;
          }
        }
      }
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
              mainAxisAlignment:   MainAxisAlignment.spaceBetween,
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
                      
                  BeatColorsInfo(info2: ColorTitle(color: Colors.black, title: lang!.wall+" ="),
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
                lines: wallLines,
              )),
        ],
      ),
    );
  }
}

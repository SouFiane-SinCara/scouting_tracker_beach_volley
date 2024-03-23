import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/list_rise_type_cubit/list_rise_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/ball_line_cubit/ball_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_type_lines_cubit/list_type_lines_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/beats_colors_info.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';

class BeatGrafic extends StatelessWidget {
  final bool? isreception;
  const BeatGrafic({super.key, this.isreception});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;
    List<Map> goodLines = [];
    List<Map> errorsLines = [];
    beats.forEach((element) {
      int? curentSet = BlocProvider.of<SetsCubit>(context).currentSet;

      if (curentSet == null || curentSet == element.currentSet) {
        if (element.state == 'reception') {
          bool? lineType;
          BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                  lang!.continued
              ? lineType = true
              : BlocProvider.of<ListTypeLinesCubit>(context).lineType ==
                      lang.discontinued
                  ? lineType = false
                  : lineType = null;

          if (lineType == element.continued || lineType == null) {
            print("method : " + element.method);
            if ((element.method == 'battingError') ||
                (element.method == "minus" && isreception != null) ||
                 (element.method == "plus" && isreception == null) ||
                (element.method == "QuickreceivingOtherFields" &&
                    isreception != null) ||(element.method == "Quickminus" &&
                    isreception != null) || 
                (element.method == "receivingOtherFields" &&
                    isreception != null) ||
                (isreception == null && element.method == "plus") ||
                element.method == "QuickAce") {
              if ((BlocProvider.of<PlayerSelectStaticsCubit>(context)
                              .playersurname ==
                          element.player.surname ||
                      BlocProvider.of<PlayerSelectStaticsCubit>(context)
                              .playersurname ==
                          "select a player" ||
                      BlocProvider.of<PlayerSelectStaticsCubit>(context)
                              .playersurname ==
                          lang!.allPlayers) &&
                  (BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                          element.type ||
                      BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                          lang!.selectrise ||
                      BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                          'select rise')) {
                print("color: " + element.method);
                (element.method == "QuickAce" && isreception == null) ||
                        (element.method == "battingError" &&
                            isreception != null) ||
                        (element.method == 'receivingOtherFields' &&
                            isreception != null) || (element.method == 'minus' &&
                            isreception != null) 
                    ? null
                    : errorsLines.add({
                        "p1": element.p1,
                        "p2": element.p2,
                        "continued": element.continued,
                        "color": element.method == "plus" ||
                                element.method == "minus" ||
                                element.method == "QuickreceivingOtherFields" || element.method == "Quickminus"
                            ? Colors.red
                            : Colors.black
                      });
              }
            } else {
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
                (element.method == 'immediateAce' && isreception != null) ||
                        (element.method == 'QuickreceivingOtherFields' &&
                            isreception == null) ||  (element.method == 'plus' &&
                            isreception != null) || (element.method == 'Quickplus' &&
                            isreception == null) || (element.method == 'minus' &&
                            isreception != null) || (element.method == "Quickminus" && isreception == null) 
                    ? null
                    : goodLines.add({
                        "p1": element.p1,
                        "p2": element.p2,
                        "continued": element.continued,
                        "color": isreception == null
                            ? element.method == 'minus'
                                ? Colors.yellow[700]
                                : element.method == 'immediateAce'
                                    ? Colors.green
                                    : element.method == 'receivingOtherFields'
                                        ? Colors.red
                                        : Colors.black
                            : element.method == 'Quickplus'
                                ? Colors.green
                                : element.method == 'receivingOtherFields'  
                                    ? Colors.red
                                    : Colors.black
                      });
              }
            }
          }
        }
      }
    });

    return Column(
      children: [

        Container(
          width: size.width,
          height: size.height * 0.1,
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
                  )),
                  BeatColorsInfo(info1: ColorTitle(color: Colors.green, title: isreception != null ?lang!.positiveReception+" +": "Ace #"),
                  info2: ColorTitle(color: Colors.red, title: isreception != null ? lang!.negativeReception+" -": lang!.postiveOpponentReception+' +'),
                  info3:  isreception != null ?null:ColorTitle(color: Colors.yellow, title:  lang.negativeOpponentReception+' -'),
                  info4: ColorTitle(color: Colors.black,title: isreception != null ? lang.immediateAce+" =": lang.lineError+" ="),
                  )
            ],
          ),
        ),
        size.width > 611
            ? SizedBox(
                height: size.height * 0.01,
              )
            : SizedBox(),
        Container(
          width: size.width,
          color: theme.colorScheme.primary,
          height: size.height,
          child: size.width > 611
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: size.width * 0.2,
                          alignment: Alignment.center,
                          height: size.height * 0.05,
                          child: Text(
                            lang!.good,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                            width: 300,
                            height: 150,
                            child: VolleyballField(
                              isShowStatics: true,
                              lines: goodLines,
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          width: size.width * 0.2,
                          alignment: Alignment.center,
                          height: size.height * 0.05,
                          child: Text(
                            lang!.errors,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                            width: 300,
                            height: 150,
                            child: VolleyballField(
                              isShowStatics: true,
                              lines: errorsLines,
                            )),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      width: size.width * 0.2,
                      alignment: Alignment.center,
                      height: size.height * 0.05,
                      child: Text(
                        lang!.good,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                        width: 300,
                        height: 150,
                        child: VolleyballField(
                          isShowStatics: true,
                          lines: goodLines,
                        )),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Container(
                      width: size.width * 0.2,
                      alignment: Alignment.center,
                      height: size.height * 0.05,
                      child: Text(
                        lang!.errors,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                        width: 300,
                        height: 150,
                        child: VolleyballField(
                          isShowStatics: true,
                          lines: errorsLines,
                        )),
                  ],
                ),
        ),
      ],
    );
  }
}

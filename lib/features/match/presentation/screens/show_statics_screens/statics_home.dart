import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/attack_of_2nd/;attack_of_2nd_statistic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/attack_of_2nd/attack_of_2nd_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/attack_on_detachment/attack_on_detachment_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/attack_on_detachment/attack_on_detachment_statistic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/beat_statics/beat_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/beat_statics/beat_statistics.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/breack_point_statics/breack_point_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/breack_point_statics/breack_point_statistic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/change_ball_statics/change_ball_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/change_ball_statics/change_ball_statistic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/errors_statics/errors_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/errors_statics/errors_statistic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/list_rise_type_cubit/list_rise_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/riser_statics/riser_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/wall_statitcs/wall_graphic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/wall_statitcs/wall_statistic.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/start_match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_options_cubit/attack_options_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/table_data_cubit/table_data_cubit.dart';

import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/graphic_or_state_cubit/graphic_or_state_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_change_ball_type_cubit/list_change_ball_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_type_lines_cubit/list_type_lines_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_wall_cubit/list_wall_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/down_button.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/text_card.dart';

class StaticsPage extends StatefulWidget {
  Account account;
  StaticsPage({super.key, required this.account});

  @override
  State<StaticsPage> createState() => _StaticsPageState();
}

class _StaticsPageState extends State<StaticsPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    AcctionsPlayCubit acctions = BlocProvider.of<AcctionsPlayCubit>(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    void turnToInitial() {
      BlocProvider.of<ListChangeBallTypeCubit>(context)
          .changeBallType("All Change ball ");
      BlocProvider.of<ListRiseTypeCubit>(context).changeRise('select rise');
      BlocProvider.of<ListWallCubit>(context).wallType("all");
      BlocProvider.of<PlayerSelectStaticsCubit>(context)
          .changePlayer("select a player");
      BlocProvider.of<ListTypeLinesCubit>(context)
          .changeLineType('select type Line');
    }

    return WillPopScope(
      onWillPop: () async {
        print("WillPopScope");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StartMatch(fromChoosePage: false, account: widget.account),
            ));
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height * 0.08,
            ),
            Container(
              width: size.width,
              height: size.height * 0.12,
              child: SingleChildScrollView(
                child: BlocBuilder<GraphicOrStateCubit, GraphicOrStateState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StartMatch(
                                      fromChoosePage: false,
                                      account: widget.account),
                                ));
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: theme.primaryColor,
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();
                            BlocProvider.of<GraphicOrStateCubit>(context)
                                .change(StateStaticsSatate());
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.bar_chart_rounded,
                                color: state is StateStaticsSatate
                                    ? theme.primaryColor
                                    : theme.primaryColor.withOpacity(0.2),
                              ),
                              Text(
                                lang!.stats,
                                style: TextStyle(
                                  color: state is StateStaticsSatate
                                      ? theme.primaryColor
                                      : theme.primaryColor.withOpacity(0.2),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: size.width * 0.1),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            BlocProvider.of<GraphicOrStateCubit>(context)
                                .change(GraphicsSatate());
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.show_chart_outlined,
                                color: state is GraphicsSatate ||
                                        state is GraphicOrStateInitial
                                    ? theme.primaryColor
                                    : theme.primaryColor.withOpacity(0.2),
                              ),
                              Text(
                                lang.graphics,
                                style: TextStyle(
                                  color: state is GraphicsSatate ||
                                          state is GraphicOrStateInitial
                                      ? theme.primaryColor
                                      : theme.primaryColor.withOpacity(0.2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        BlocBuilder<SetsCubit, SetsState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "sets:",
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: size.width * 0.005,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    BlocProvider.of<SetsCubit>(context)
                                                .currentSet ==
                                            1
                                        ? BlocProvider.of<SetsCubit>(context)
                                            .ChangeSets(SetsInitial(), null)
                                        : BlocProvider.of<SetsCubit>(context)
                                            .ChangeSets(FirstSetState(), 1);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: size.width * 0.08,
                                    height: size.height * 0.09,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            color: theme.primaryColor),
                                        color: state is FirstSetState
                                            ? theme.colorScheme.secondary
                                            : theme.colorScheme.primary,
                                        shape: BoxShape.circle),
                                    child: const FittedBox(
                                        child: Text('1',
                                            style: TextStyle(fontSize: 30))),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.005,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    BlocProvider.of<SetsCubit>(context)
                                                .currentSet ==
                                            2
                                        ? BlocProvider.of<SetsCubit>(context)
                                            .ChangeSets(SetsInitial(), null)
                                        : BlocProvider.of<SetsCubit>(context)
                                            .ChangeSets(SecondSetState(), 2);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: size.width * 0.08,
                                    height: size.height * 0.09,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            color: theme.primaryColor),
                                        color: state is SecondSetState
                                            ? theme.colorScheme.secondary
                                            : theme.colorScheme.primary,
                                        shape: BoxShape.circle),
                                    child: const FittedBox(
                                        child: Text('2',
                                            style: TextStyle(fontSize: 30))),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.005,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    BlocProvider.of<SetsCubit>(context)
                                                .currentSet ==
                                            3
                                        ? BlocProvider.of<SetsCubit>(context)
                                            .ChangeSets(SetsInitial(), null)
                                        : BlocProvider.of<SetsCubit>(context)
                                            .ChangeSets(ThirthSetState(), 3);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: size.width * 0.08,
                                    height: size.height * 0.09,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            color: theme.primaryColor),
                                        color: state is ThirthSetState
                                            ? theme.colorScheme.secondary
                                            : theme.colorScheme.primary,
                                        shape: BoxShape.circle),
                                    child: const FittedBox(
                                        child: Text(
                                      '3',
                                      style: TextStyle(fontSize: 30),
                                    )),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              width: size.width,
              height: size.height * 0.15,
              color: theme.colorScheme.primary,
              child: BlocBuilder<AcctionsPlayCubit, AcctionsPlayState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();
                            acctions.emit(BeatState());
                          },
                          child: TextCard(
                            taped: state is BeatState ||
                                    state is AcctionsPlayInitial
                                ? true
                                : false,
                            text: lang!.beat,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();
                            BlocProvider.of<TableDataCubit>(context).update(
                              ChangeBallAcctionState(),
                              context,
                            );
                            acctions.emit(ChangeBallAcctionState());
                          },
                          child: TextCard(
                            taped:
                                state is ChangeBallAcctionState ? true : false,
                            text: lang.changeBall,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            acctions.emit(BreakPointState());
                          },
                          child: TextCard(
                            taped: state is BreakPointState ? true : false,
                            text: lang.breakPoint,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            acctions.emit(RiserState());
                          },
                          child: TextCard(
                            taped: state is RiserState ? true : false,
                            text: lang.riser,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            acctions.emit(ReceptionState());
                          },
                          child: TextCard(
                            taped: state is ReceptionState ? true : false,
                            text: lang.reception,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            acctions.emit(WallState());
                          },
                          child: TextCard(
                            taped: state is WallState ? true : false,
                            text: lang.wall,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            acctions.emit(AttackOnDetachmentState());
                          },
                          child: TextCard(
                            taped:
                                state is AttackOnDetachmentState ? true : false,
                            text: lang.attackOndetachment,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            acctions.emit(AttackOftwoState());
                          },
                          child: TextCard(
                            taped: state is AttackOftwoState ? true : false,
                            text: lang.attackOftwoend,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            turnToInitial();

                            acctions.emit(ErrorsState());
                          },
                          child: TextCard(
                            taped: state is ErrorsState ? true : false,
                            text: lang.errors,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<GraphicOrStateCubit, GraphicOrStateState>(
              builder: (context, graphicOrStateCubit) {
                return BlocBuilder<AcctionsPlayCubit, AcctionsPlayState>(
                  builder: (context, acctionsPlayState) {
                    return SizedBox(
                      width: size.width,
                      height: size.height * 0.1,
                      child: BlocBuilder<LastMatchCubit, LastMatchState>(
                        builder: (context, state) {
                          String? selectedPlayer;
                          String? currentRise;
                          String? currentTypeLine;

                          List<String?> players = [];
                          List<String?> typeLines = [];
                          if (acctionsPlayState is AttackOnDetachmentState ||
                              acctionsPlayState is AttackOftwoState) {
                            typeLines = [
                              lang!.allBreackPoint,
                              lang.allChangeBall,
                              lang.selectLineType
                            ];
                          } else {
                            typeLines = [
                              lang!.continued,
                              lang.discontinued,
                              lang.selectLineType
                            ];
                          }
                          List<String?> beatsType = [];
                          if (acctionsPlayState is BeatState ||
                              acctionsPlayState is AcctionsPlayInitial ||
                              acctionsPlayState is ReceptionState) {
                            beatsType = [
                              'flaot',
                              'jump',
                              'jumpFloat',
                              'hybird',
                              'normal',
                              lang.selectrise
                            ];
                          } else if (acctionsPlayState
                                  is ChangeBallAcctionState ||
                              acctionsPlayState is AttackOnDetachmentState ||
                              acctionsPlayState is BreakPointState ||
                              acctionsPlayState is AttackOftwoState) {
                            beatsType = [
                              lang.right,
                              lang.left,
                              lang.center,
                              acctionsPlayState is BreakPointState
                                  ? lang.allBreackPoint
                                  : acctionsPlayState
                                              is AttackOnDetachmentState ||
                                          acctionsPlayState is AttackOftwoState
                                      ? lang.all
                                      : lang.allChangeBall,
                            ];
                          } else if (acctionsPlayState is ErrorsState) {
                            beatsType = [
                              lang.errorsBreackPoint,
                              lang.errorsChangeBall,
                              lang.battingError,
                              lang.allBattingErrors
                            ];
                          } else if (acctionsPlayState is WallState) {
                            beatsType = [
                              lang.changeBall,
                              lang.breakPoint,
                              lang.all
                            ];
                          }
                          AMatch aMatch =
                              BlocProvider.of<LastMatchCubit>(context).aMatch!;
                          if ((acctionsPlayState is BeatState ||
                                  acctionsPlayState is ChangeBallAcctionState ||
                                  acctionsPlayState is BreakPointState ||
                                  acctionsPlayState is WallState ||
                                  acctionsPlayState
                                      is AttackOnDetachmentState ||
                                  acctionsPlayState is AttackOftwoState ||
                                  acctionsPlayState is ErrorsState ||
                                  acctionsPlayState is AcctionsPlayInitial) &&
                              graphicOrStateCubit is StateStaticsSatate) {
                            players = [
                              '${aMatch.player1.surname} / ${aMatch.player2.surname}',
                              '${aMatch.player3.surname} / ${aMatch.player4.surname}',
                              lang.allPlayers
                            ];
                          } else {
                            players = [
                              aMatch.player1.surname,
                              aMatch.player2.surname,
                              aMatch.player3.surname,
                              aMatch.player4.surname,
                              lang.allPlayers
                            ];
                          }
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                acctionsPlayState is RiserState
                                    ? SizedBox()
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: theme.primaryColor),
                                          color: theme.colorScheme.primary,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        width: size.width * 0.33,
                                        height: size.height * 0.08,
                                        child: DownButton(
                                          fun: (value) {
                                            setState(() {
                                              BlocProvider.of<
                                                          PlayerSelectStaticsCubit>(
                                                      context)
                                                  .changePlayer(value!);
                                            });
                                          },
                                          list: players.map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item!,
                                              ),
                                            );
                                          }).toList(),
                                          hintText: BlocProvider.of<
                                                              PlayerSelectStaticsCubit>(
                                                          context)
                                                      .playersurname ==
                                                  "select a player"
                                              ? lang.allPlayers
                                              : BlocProvider.of<
                                                          PlayerSelectStaticsCubit>(
                                                      context)
                                                  .playersurname,
                                          value: selectedPlayer,
                                        )),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                (graphicOrStateCubit is StateStaticsSatate) &&
                                            (acctionsPlayState
                                                    is ChangeBallAcctionState ||
                                                acctionsPlayState
                                                    is WallState ||
                                                acctionsPlayState
                                                    is AttackOnDetachmentState ||
                                                acctionsPlayState
                                                    is ErrorsState ||
                                                acctionsPlayState
                                                    is AttackOftwoState ||
                                                acctionsPlayState
                                                    is BreakPointState) ||
                                        acctionsPlayState is RiserState
                                    ? const SizedBox()
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: theme.primaryColor),
                                          color: theme.colorScheme.primary,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        width: size.width * 0.33,
                                        height: size.height * 0.08,
                                        child: DownButton(
                                          fun: (value) {
                                            if (acctionsPlayState
                                                    is BeatState ||
                                                acctionsPlayState
                                                    is AcctionsPlayInitial ||
                                                acctionsPlayState
                                                    is ReceptionState) {
                                              setState(() {
                                                BlocProvider.of<
                                                            ListRiseTypeCubit>(
                                                        context)
                                                    .changeRise(value!);
                                              });
                                            } else if (acctionsPlayState
                                                    is ChangeBallAcctionState ||
                                                acctionsPlayState
                                                    is AttackOnDetachmentState ||
                                                acctionsPlayState
                                                    is BreakPointState ||
                                                acctionsPlayState
                                                    is AttackOftwoState) {
                                              setState(() {
                                                BlocProvider.of<
                                                            ListChangeBallTypeCubit>(
                                                        context)
                                                    .changeBallType(value!);
                                              });
                                            } else if (acctionsPlayState
                                                is WallState) {
                                              setState(() {
                                                BlocProvider.of<ListWallCubit>(
                                                        context)
                                                    .wallType(value!);
                                              });
                                            } else if (acctionsPlayState
                                                is ErrorsState) {
                                              setState(() {
                                                BlocProvider.of<
                                                            ListChangeBallTypeCubit>(
                                                        context)
                                                    .changeBallType(value!);
                                              });
                                            }
                                          },
                                          list: beatsType.map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item!),
                                            );
                                          }).toList(),
                                          hintText: acctionsPlayState is BeatState ||
                                                  acctionsPlayState
                                                      is AcctionsPlayInitial ||
                                                  acctionsPlayState
                                                      is ReceptionState
                                              ? BlocProvider.of<ListRiseTypeCubit>(context)
                                                          .rise ==
                                                      'select rise'
                                                  ? lang.selectrise
                                                  : BlocProvider.of<ListRiseTypeCubit>(context)
                                                      .rise
                                              : acctionsPlayState
                                                          is ChangeBallAcctionState ||
                                                      acctionsPlayState
                                                          is AttackOnDetachmentState ||
                                                      acctionsPlayState
                                                          is BreakPointState ||
                                                      acctionsPlayState
                                                          is ErrorsState ||
                                                      acctionsPlayState
                                                          is AttackOftwoState
                                                  ? BlocProvider.of<ListChangeBallTypeCubit>(context)
                                                              .currentChangeBallList ==
                                                          "All Change ball "
                                                      ? acctionsPlayState
                                                              is BreakPointState
                                                          ? lang.allBreackPoint
                                                          : acctionsPlayState
                                                                      is AttackOnDetachmentState ||
                                                                  acctionsPlayState
                                                                      is AttackOftwoState
                                                              ? lang.all
                                                              : acctionsPlayState
                                                                      is ErrorsState
                                                                  ? lang
                                                                      .allBattingErrors
                                                                  : lang
                                                                      .allChangeBall
                                                      : BlocProvider.of<ListChangeBallTypeCubit>(context)
                                                          .currentChangeBallList
                                                  : acctionsPlayState
                                                          is WallState
                                                      ? BlocProvider.of<ListWallCubit>(context)
                                                                  .typeWall ==
                                                              "all"
                                                          ? lang.all
                                                          : BlocProvider.of<ListWallCubit>(
                                                                  context)
                                                              .typeWall
                                                      : "",
                                          value: currentRise,
                                        )),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                (graphicOrStateCubit is StateStaticsSatate) &&
                                            (acctionsPlayState is BeatState ||
                                                acctionsPlayState
                                                    is ChangeBallAcctionState ||
                                                acctionsPlayState
                                                    is BreakPointState ||
                                                acctionsPlayState
                                                    is WallState ||
                                                acctionsPlayState
                                                    is ErrorsState ||
                                                acctionsPlayState
                                                    is AttackOnDetachmentState ||
                                                acctionsPlayState
                                                    is AttackOftwoState ||
                                                acctionsPlayState
                                                    is AcctionsPlayInitial) ||
                                        acctionsPlayState is RiserState
                                    ? const SizedBox()
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: theme.primaryColor),
                                          color: theme.colorScheme.primary,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        width: size.width * 0.33,
                                        height: size.height * 0.08,
                                        child: DownButton(
                                          fun: (value) {
                                            setState(() {
                                              BlocProvider.of<
                                                          ListTypeLinesCubit>(
                                                      context)
                                                  .changeLineType(value!);
                                            });
                                          },
                                          list: typeLines.map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item!),
                                            );
                                          }).toList(),
                                          hintText: BlocProvider.of<
                                                              ListTypeLinesCubit>(
                                                          context)
                                                      .lineType ==
                                                  'select type Line'
                                              ? lang.selectLineType
                                              : BlocProvider.of<
                                                          ListTypeLinesCubit>(
                                                      context)
                                                  .lineType,
                                          value: currentTypeLine,
                                        )),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<GraphicOrStateCubit, GraphicOrStateState>(
                  builder: (context, graphicOrStatistic) {
                    return BlocBuilder<AcctionsPlayCubit, AcctionsPlayState>(
                      builder: (context, acctionsPlayState) {
                        if (graphicOrStatistic is GraphicsSatate ||
                            graphicOrStatistic is GraphicOrStateInitial) {
                          if (acctionsPlayState is AcctionsPlayInitial ||
                              acctionsPlayState is BeatState) {
                            return BeatGrafic();
                          } else if (acctionsPlayState
                              is ChangeBallAcctionState) {
                            return ChangeBallGraphic();
                          } else if (acctionsPlayState is BreakPointState) {
                            return BreackPOintGraphic();
                          } else if (acctionsPlayState is RiserState) {
                            return RiserGraphic();
                          } else if (acctionsPlayState is ReceptionState) {
                            return BeatGrafic(
                              isreception: true,
                            );
                          } else if (acctionsPlayState is WallState) {
                            return WallGraphic();
                          } else if (acctionsPlayState
                              is AttackOnDetachmentState) {
                            return AttackOnDetachmentGraphic();
                          } else if (acctionsPlayState is AttackOftwoState) {
                            return AttackOf2ndGraphic();
                          } else if (acctionsPlayState is ErrorsState) {
                            return ErrorsGraphic();
                          }
                        } else {
                          if (acctionsPlayState is AcctionsPlayInitial ||
                              acctionsPlayState is BeatState) {
                            return BeatStatistics();
                          } else if (acctionsPlayState
                              is ChangeBallAcctionState) {
                            return ChangeBallStatistics();
                          } else if (acctionsPlayState is BreakPointState) {
                            return BreackpointStatistic();
                          } else if (acctionsPlayState is RiserState) {
                            return RiserGraphic();
                          } else if (acctionsPlayState is ReceptionState) {
                            return BeatStatistics(
                              isReception: true,
                            );
                          } else if (acctionsPlayState is WallState) {
                            return WallStatistic();
                          } else if (acctionsPlayState
                              is AttackOnDetachmentState) {
                            return AttackOnDetachmentStatistic();
                          } else if (acctionsPlayState is AttackOftwoState) {
                            return AttackOf2ndStatistic();
                          } else if (acctionsPlayState is ErrorsState) {
                            return ErrorsStatistic();
                          }
                        }
                        return const SizedBox();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

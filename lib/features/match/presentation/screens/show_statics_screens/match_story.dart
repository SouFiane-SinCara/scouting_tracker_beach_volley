import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/login_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/start_match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';

class Matchstory extends StatefulWidget {
  Account account;

  Matchstory({Key? key, required this.account}) : super(key: key);

  @override
  _MatchstoryState createState() => _MatchstoryState();
}

class _MatchstoryState extends State<Matchstory> {
  int totHomeScoore = 0;
  int totAwayScoore = 0;
  int homeScoore = 0;
  int awayScoore = 0;
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
    AppLocalizations? lang = AppLocalizations.of(context);
    totHomeScoore = 0;
    totAwayScoore = 0;
    homeScoore = 0;
    awayScoore = 0;
    String acctionDiscription(
        String acction, int breakPoint, String stateAcction) {
      String prefix;
        print('beat ${stateAcction} ');
      if (stateAcction == 'reception') {
        prefix = 'BT - ';
      } else if ((stateAcction == 'BreackPointState()'||stateAcction == 'BreackPointState' ) && breakPoint > 0) {
        prefix = 'BK $breakPoint - ';
      } else {
        prefix = '${lang!.so} - ';
      }
      if (acction == 'battingError') {
        return prefix + lang!.battingError;
      } else if (acction == 'attackErrorBK') {
        return prefix + lang!.attackError;
      } else if (acction == 'WallAttackBK') {
        return prefix + lang!.wall;
      } else if (acction == 'immediateAce') {
        return prefix + lang!.immediateAce;
      } else if (acction == 'attachmentPointBK') {
        return prefix + lang!.attachmentPoint;
      } else if (acction == 'errorRaisedBK') {
        return prefix + lang!.errorRaised;
      } else {
        return acction;
      }
    }

    return BlocBuilder<LastMatchCubit, LastMatchState>(
      builder: (context, lastMatch) {
        if (lastMatch is StartedMatchState) {
          BlocProvider.of<GetBeatsCubit>(context)
              .getBeats(aMatch: lastMatch.aMatch);
          return BlocBuilder<GetBeatsCubit, GetBeatsState>(
            builder: (context, beatstate) {
              if (beatstate is BeatsActionsLoadedState) {
                return BlocBuilder<SetsCubit, SetsState>(
                  builder: (context, setsSate) {
                    totHomeScoore = 0;
                    totAwayScoore = 0;
                    homeScoore = 0;
                    awayScoore = 0;
                    List<BeatAction> beats = beatstate.beats;
                    beats.forEach((element) {
                      print(element.player.surname);
                    });
                    List.generate(beats.length, (index) {
                      int? currentSet =
                          BlocProvider.of<SetsCubit>(context).currentSet;
                      if (currentSet == beats[index].currentSet ||
                          currentSet == null) {
                        if (index == 0) {
                          totHomeScoore = 0;
                          totAwayScoore = 0;
                        }

                        if (beats[index].method == 'immediateAce' ||
                            beats[index].method == 'attachmentPointBK' ||
                            beats[index].method == 'attackErrorBK' ||
                            beats[index].method == 'errorRaisedBK' ||
                            beats[index].method == 'WallAttackBK' ||
                            beats[index].method == 'battingError') {
                          if ((beats.length - 1 == index) ||
                              (beats[index + 1].method != 'WallAttackBK' &&
                                  beats[index].method == 'attackErrorBK') ||
                              (beats[index].method != 'attackErrorBK')) {
                            if (beats[index].playerTeam == 1) {
                              if (beats[index].method == 'battingError' ||
                                  beats[index].method == 'attackErrorBK' ||
                                  beats[index].method == "errorRaisedBK") {
                                totAwayScoore = totAwayScoore + 1;
                              } else {
                                totHomeScoore = totHomeScoore + 1;
                              }
                            } else {
                              if (beats[index].method == 'battingError' || beats[index].method == 'errorRaisedBK' || 


                                  beats[index].method == 'attackErrorBK') {
                                totHomeScoore = totHomeScoore + 1;
                              } else {
                                totAwayScoore = totAwayScoore + 1;
                              }
                            }
                          }
                        }
                      }
                    });

                    return WillPopScope(
                      onWillPop: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StartMatch(
                                  fromChoosePage: false,
                                  account: widget.account),
                            ));
                        return true;
                      },
                      child: Scaffold(
                        appBar: AppBar(
                            elevation: 0,
                            leading: IconButton(
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
                                )),
                            title: Text(
                              lang!.matchstory,
                              style: TextStyle(color: theme.primaryColor),
                            ),
                            actions: [
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
                                              ? BlocProvider.of<SetsCubit>(
                                                      context)
                                                  .ChangeSets(
                                                      SetsInitial(), null)
                                              : BlocProvider.of<SetsCubit>(
                                                      context)
                                                  .ChangeSets(
                                                      FirstSetState(), 1);
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
                                          child: FittedBox(
                                              child: Text('1',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color:
                                                          theme.primaryColor))),
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
                                              ? BlocProvider.of<SetsCubit>(
                                                      context)
                                                  .ChangeSets(
                                                      SetsInitial(), null)
                                              : BlocProvider.of<SetsCubit>(
                                                      context)
                                                  .ChangeSets(
                                                      SecondSetState(), 2);
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
                                          child: FittedBox(
                                              child: Text('2',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color:
                                                          theme.primaryColor))),
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
                                              ? BlocProvider.of<SetsCubit>(
                                                      context)
                                                  .ChangeSets(
                                                      SetsInitial(), null)
                                              : BlocProvider.of<SetsCubit>(
                                                      context)
                                                  .ChangeSets(
                                                      ThirthSetState(), 3);
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
                                          child: FittedBox(
                                              child: Text(
                                            '3',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: theme.primaryColor),
                                          )),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ]),
                        backgroundColor: theme.colorScheme.primary,
                        body: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width,
                              ),
                              DataTable(
                                columns: [
                                  DataColumn(
                                    label: Flexible(
                                        child: Text(
                                            '${lastMatch.aMatch.player1.name} ${lastMatch.aMatch.player1.surname}   ${lastMatch.aMatch.player2.name} ${lastMatch.aMatch.player2.surname}')),
                                  ),
                                  DataColumn(label: Text('vs')),
                                  DataColumn(
                                    label: Flexible(
                                        child: Text(
                                            '${lastMatch.aMatch.player3.name} ${lastMatch.aMatch.player3.surname}   ${lastMatch.aMatch.player4.name} ${lastMatch.aMatch.player4.surname}')),
                                  ),
                                ],
                                rows: [],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    border: TableBorder.all(
                                        color: theme.primaryColor, width: 2),
                                    columns: [
                                      DataColumn(
                                        label:
                                            Flexible(child: Text(lang.action)),
                                      ),
                                      DataColumn(
                                        label: Flexible(
                                            child: Text(lang.actionof)),
                                      ),
                                      DataColumn(
                                        label: Flexible(
                                            child:
                                                Text(totHomeScoore.toString())),
                                      ),
                                      DataColumn(
                                          label: Flexible(
                                              child: Text(
                                                  totAwayScoore.toString()))),
                                      DataColumn(
                                        label: Flexible(
                                            child: Text(lang.actionof)),
                                      ),
                                      DataColumn(
                                        label:
                                            Flexible(child: Text(lang.action)),
                                      ),
                                    ],
                                    rows: List<DataRow>.from(
                                        List.generate(beats.length, (index) {
                                      int? currentSet =
                                          BlocProvider.of<SetsCubit>(context)
                                              .currentSet;
                                      if ((beats[index].currentSet ==
                                              currentSet) ||
                                          (currentSet == null)) {
                                        if (index == 0) {
                                          totHomeScoore = 0;
                                          totAwayScoore = 0;
                                          homeScoore = 0;
                                          awayScoore = 0;
                                        }
                                        print("delete : " +
                                            beats[index].deletable.toString());
                                        if (beats[index].method == 'immediateAce' ||
                                            beats[index].method ==
                                                'attachmentPointBK' ||
                                            beats[index].method ==
                                                'attackErrorBK' ||
                                            beats[index].method ==
                                                'errorRaisedBK' ||
                                            beats[index].method ==
                                                'WallAttackBK' ||
                                            (beats[index].deletable != null &&
                                                beats[index].method ==
                                                    'battingError')) {
                                          if ((beats.length - 1 == index) ||
                                              (beats[index + 1].method !=
                                                      'WallAttackBK' &&
                                                  beats[index].deletable !=
                                                      null &&
                                                  beats[index].method ==
                                                      'attackErrorBK') ||
                                              (beats[index].method !=
                                                  'attackErrorBK')) {
                                            if ((beats[index].playerTeam == 1 &&
                                                    (beats[index].method !=
                                                            'attackErrorBK' && beats[index].method !=
                                                            'errorRaisedBK' &&
                                                        beats[index].method !=
                                                            'battingError')) ||
                                                ((beats[index].method ==
                                                            'battingError' ||
                                                        beats[index].method ==
                                                            'attackErrorBK'||
                                                        beats[index].method ==
                                                            'errorRaisedBK') &&
                                                    beats[index].playerTeam ==
                                                        2)) {
                                              homeScoore++;
                                            } else {
                                              awayScoore++;
                                            }
                                            print(beats[index]
                                                .playerNumber
                                                .toString());
                                            final row = DataRow(cells: [
                                              beats[index].playerTeam == 1
                                                  ? DataCell(Text(
                                                      acctionDiscription(
                                                          beats[index].method,
                                                          beats[index]
                                                              .breackpointNum,
                                                          beats[index].state)))
                                                  : const DataCell(Text('')),
                                              beats[index].playerTeam == 1
                                                  ? DataCell(Text(
                                                      '${beats[index].player.name} ${beats[index].player.surname}'))
                                                  : const DataCell(Text('')),
                                              (beats[index].playerTeam == 1 &&
                                                          (beats[index]
                                                                      .method !=
                                                                  'battingError' &&beats[index]
                                                                      .method !=
                                                                  'errorRaisedBK' &&
                                                              beats[index]
                                                                      .method !=
                                                                  'attackErrorBK')) ||
                                                      ((beats[index].method ==
                                                                  'battingError' ||beats[index].method ==
                                                                  'errorRaisedBK' ||
                                                              beats[index]
                                                                      .method ==
                                                                  'attackErrorBK') &&
                                                          beats[index]
                                                                  .playerTeam ==
                                                              2)
                                                  ? DataCell(
                                                      Text("${homeScoore}"))
                                                  : const DataCell(Text("")),
                                              (beats[index].playerTeam == 2 &&
                                                          (beats[index]
                                                                      .method !=
                                                                  'battingError' &&beats[index]
                                                                      .method !=
                                                                  'errorRaisedBK' &&
                                                              beats[index]
                                                                      .method !=
                                                                  'attackErrorBK')) ||
                                                      ((beats[index].method ==
                                                                  'battingError' || beats[index].method ==
                                                                  'errorRaisedBK' ||
                                                              beats[index]
                                                                      .method ==
                                                                  'attackErrorBK') &&
                                                          beats[index]
                                                                  .playerTeam ==
                                                              1)
                                                  ? DataCell(
                                                      Text("${awayScoore}"))
                                                  : const DataCell(Text("")),
                                              beats[index].playerTeam == 2
                                                  ? DataCell(Text(
                                                      '${beats[index].player.name} ${beats[index].player.surname}'))
                                                  : const DataCell(Text('')),
                                              beats[index].playerTeam == 2
                                                  ? DataCell(Text(
                                                      acctionDiscription(
                                                          beats[index].method,
                                                          beats[index]
                                                              .breackpointNum,
                                                          beats[index].state)))
                                                  : const DataCell(Text('')),
                                            ]);

                                            return row;
                                          }
                                        }
                                      }
                                    })
                                            .where((row) => row != null)
                                            .toList()
                                            .reversed
                                        // i want to do this function when datarows has been builded
                                        ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  color: theme.colorScheme.primary,
                  height: size.height,
                  width: size.width,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
            },
          );
        } else {
          return Container(
            height: size.height,
            width: size.width,
            color: theme.colorScheme.primary,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

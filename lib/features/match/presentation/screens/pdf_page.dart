// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/list_rise_type_cubit/list_rise_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/start_match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/scoore_cubit/scoore_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:screenshot/screenshot.dart';

class PdfStatistics extends StatefulWidget {
  final Account account;
  const PdfStatistics({super.key, required this.account});

  @override
  State<PdfStatistics> createState() => _PdfStatisticsState();
}

class _PdfStatisticsState extends State<PdfStatistics> {
  @override
  void initState() {
    super.initState();
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Set portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenshotController = ScreenshotController();
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);

    TableCell myCell(String left, String right, String center) {
      return TableCell(
          child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              left,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              right,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ));
    }

    return BlocBuilder<LastMatchCubit, LastMatchState>(
      builder: (context, matchState) {
        if (matchState is StartedMatchState) {
          BlocProvider.of<GetBeatsCubit>(context)
              .getBeats(aMatch: matchState.aMatch);
          return BlocBuilder<GetBeatsCubit, GetBeatsState>(
            builder: (context, beatsState) {
              if (beatsState is BeatsActionsLoadedState) {
                int homeScoore = 0;
                int awayScoore = 0;
                List<BeatAction> beats = beatsState.beats;
                List<String> partialScooreSet1 = [];
                List<String> partialScooreSet2 = [];
                List<String> partialScooreSet3 = [];
                List beatsData = [];
                List changeBallData = [];
                List attackData = [];
                List breakPointData = [];
                List errorsData = [];
                List wallData = [];
                List hashtagData = [];
                List cphashtagData = [];
                List bphashtagData = [];
                List totalPoints = [];
                List.generate(beats.length, (index) {
                  if (index == 0) {
                    homeScoore = 0;
                    awayScoore = 0;
                  }

                  if (beats[index].method == 'immediateAce' ||
                      beats[index].method == 'attachmentPointBK' ||
                      beats[index].method == 'attackErrorBK' ||
                      beats[index].method == 'errorRaisedBK' ||
                      beats[index].method == 'manual' ||
                      beats[index].method == 'WallAttackBK' ||
                      (beats[index].deletable != null &&
                          beats[index].method == 'battingError')) {
                    if ((beats.length - 1 == index) ||
                        (beats[index + 1].method != 'WallAttackBK' &&
                            beats[index].deletable != null &&
                            beats[index].method == 'attackErrorBK') ||
                        (beats[index].method != 'attackErrorBK')) {
                      if ((beats[index].method == 'manual' &&
                              beats[index].playerTeam == 1) ||
                          (beats[index].playerTeam == 1 &&
                              (beats[index].method != 'attackErrorBK' &&
                                  beats[index].method != 'errorRaisedBK' &&
                                  beats[index].method != 'battingError')) ||
                          ((beats[index].method == 'battingError' ||
                                  beats[index].method == 'attackErrorBK' ||
                                  beats[index].method == 'errorRaisedBK') &&
                              beats[index].playerTeam == 2)) {
                        homeScoore++;
                        int somma = homeScoore + awayScoore;
                        if (somma % 6 == 0) {
                          if (beats[index].currentSet == 1) {
                            partialScooreSet1.add("$homeScoore - $awayScoore");
                          } else if (beats[index].currentSet == 2) {
                            partialScooreSet2.add("$homeScoore - $awayScoore");
                          } else if (beats[index].currentSet == 3) {
                            partialScooreSet3.add("$homeScoore - $awayScoore");
                          }
                        }
                      } else {
                        awayScoore++;

                        int somma = homeScoore + awayScoore;
                        if (somma % 6 == 0) {
                          if (beats[index].currentSet == 1) {
                            partialScooreSet1.add("$homeScoore - $awayScoore");
                          } else if (beats[index].currentSet == 2) {
                            partialScooreSet2.add("$homeScoore - $awayScoore");
                          } else if (beats[index].currentSet == 3) {
                            partialScooreSet3.add("$homeScoore - $awayScoore");
                          }
                        }
                      }
                    }
                  }
                });

                //! get beats data
                beatsData = [
                  [
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                  ],
                  [
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                  ],
                  [
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                  ],
                  [
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                  ],
                  [
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                  ],
                  [
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                    {"tot": 0, "err": 0, "pt": 0},
                  ],
                ];

                List<Player> players = [
                  matchState.aMatch.player1,
                  matchState.aMatch.player2,
                  matchState.aMatch.player3,
                  matchState.aMatch.player4,
                ];
                int tothashtag = 0;
                int totplus = 0;
                int totminus = 0;
                int totequal = 0;
                int totaleBeat = 0;
                int hashtag = 0;
                int plus = 0;
                int minus = 0;
                int equal = 0;
                int tot = 0;
                int indexPlayer = 0;
                for (var player in players) {
                  tothashtag = 0;
                  totplus = 0;
                  totminus = 0;
                  totequal = 0;
                  totaleBeat = 0;
                  hashtag = 0;
                  plus = 0;
                  minus = 0;
                  equal = 0;
                  tot = 0;
                  for (int i = 0; i <= 2; i++) {
                    plus = 0;
                    minus = 0;
                    equal = 0;
                    tot = 0;
                    hashtag = 0;

                    for (var element in beats) {
                      if (element.currentSet == i + 1 &&
                          element.method != "manual") {
                        if (i + 1 == 1) {}
                        debugPrint(
                            "compare:    ${element.currentSet}:${i + 1}");
                        if (player.surname == element.playersurname) {
                          if (element.state == 'reception' &&
                              element.method != "Quickplus" &&
                              element.method != "Quickminus" &&
                              element.method != "QuickAce" &&
                              element.method != "QuickreceivingOtherFields") {
                            tot++;
                            if (element.method == 'immediateAce') {
                              hashtag++;
                            } else if (element.method == 'minus' ||
                                element.method == 'receivingOtherFields') {
                              plus++;
                            } else if (element.method == 'plus') {
                              minus++;
                            } else if (element.method == 'battingError') {
                              equal++;
                            }
                          }
                        }
                      }
                    }
                    totaleBeat += tot;
                    totequal += equal;
                    totplus += plus;
                    totminus += minus;
                    tothashtag += hashtag;

                    beatsData[indexPlayer]
                        [i] = {"tot": tot, "err": equal, "pt": hashtag};
                  }

                  beatsData[indexPlayer].add({
                    "tot": beatsData[indexPlayer][0]['tot'] +
                        beatsData[indexPlayer][1]['tot'] +
                        beatsData[indexPlayer][2]['tot'] as int,
                    "err": beatsData[indexPlayer][0]['err'] +
                        beatsData[indexPlayer][1]['err'] +
                        beatsData[indexPlayer][2]['err'] as int,
                    "pt": beatsData[indexPlayer][0]['pt'] +
                        beatsData[indexPlayer][1]['pt'] +
                        beatsData[indexPlayer][2]['pt'] as int
                  });

                  indexPlayer++;
                }
                //! cambio palla
                // hashtag
                cphashtagData = [
                  [
                    {"cpH": 0},
                    {"cpH": 0},
                    {"cpH": 0},
                  ],
                  [
                    {"cpH": 0},
                    {"cpH": 0},
                    {"cpH": 0},
                  ],
                  [
                    {"cpH": 0},
                    {"cpH": 0},
                    {"cpH": 0},
                  ],
                  [
                    {"cpH": 0},
                    {"cpH": 0},
                    {"cpH": 0},
                  ],
                ];
                changeBallData = [
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                ];
                tothashtag = 0;
                totplus = 0;
                totminus = 0;
                totequal = 0;
                totaleBeat = 0;
                indexPlayer = 0;
                for (var player in players) {
                  tothashtag = 0;
                  totplus = 0;
                  totminus = 0;
                  totequal = 0;
                  totaleBeat = 0;

                  hashtag = 0;
                  plus = 0;
                  minus = 0;
                  equal = 0;
                  tot = 0;
                  ChangeBallAcctionState acctionsPlayState =
                      ChangeBallAcctionState();

                  for (int curentSet = 1; curentSet <= 3; curentSet++) {
                    hashtag = 0;
                    plus = 0;
                    minus = 0;
                    equal = 0;
                    tot = 0;
                    for (var element in beats) {
                      if (curentSet == element.currentSet) {
                        if (element.type ==
                                BlocProvider.of<ListRiseTypeCubit>(context)
                                    .rise ||
                            BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                                'select rise' ||
                            BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                                lang!.selectrise) {
                          if (player.surname == element.playersurname) {
                            if (((element.state == 'BreackPointState()' ||
                                        element.state == 'BreackPointState') &&
                                    element.breackpointNum == 0 &&
                                    element.method != 'WallAttackBK' &&
                                    acctionsPlayState
                                        is ChangeBallAcctionState) ||
                                (element.method == "WallAttackBK" &&
                                    acctionsPlayState is BreakPointState) ||
                                ((element.state == 'BreackPointState()' ||
                                        element.state == 'BreackPointState') &&
                                    element.breackpointNum != 0 &&
                                    acctionsPlayState is BreakPointState) ||
                                ((element.method ==
                                            "QuickreceivingOtherFields" ||
                                        element.method == 'QuickAce') &&
                                    acctionsPlayState
                                        is ChangeBallAcctionState)) {
                              tot++;
                              if (element.method == "attachmentPointBK" ||
                                  element.method == 'WallAttackBK') {
                                hashtag++;
                              } else if (element.method == 'replayableattack') {
                                plus++;
                              } else if (element.method == 'defendedattack' ||
                                  element.method ==
                                      'QuickreceivingOtherFields') {
                                minus++;
                              } else if (element.method == 'attackErrorBK' ||
                                  element.method == 'QuickAce' ||
                                  element.method == "errorRaisedBK") {
                                equal++;
                              }
                            }
                          }
                        }
                      }
                    }
                    totaleBeat += tot;
                    totequal += equal;
                    totplus += plus;
                    totminus += minus;
                    tothashtag += hashtag;
                    cphashtagData[indexPlayer]
                        [curentSet - 1] = {'cpH': hashtag};
                    changeBallData[indexPlayer][curentSet - 1] = {
                      "tot": tot,
                      "plus": plus,
                      "minus": minus,
                      "equal": equal,
                      "hashtag": hashtag,
                      "eff%": tot == 0
                          ? 0
                          : double.parse(
                              ((hashtag / tot) * 100).toStringAsFixed(2))
                    };
                  }
                  cphashtagData[indexPlayer].add({'cpH': tothashtag});
                  changeBallData[indexPlayer].add({
                    "tot": changeBallData[indexPlayer][0]['tot'] +
                        changeBallData[indexPlayer][1]['tot'] +
                        changeBallData[indexPlayer][2]['tot'] as int,
                    "plus": changeBallData[indexPlayer][0]['plus'] +
                        changeBallData[indexPlayer][1]['plus'] +
                        changeBallData[indexPlayer][2]['plus'] as int,
                    "minus": changeBallData[indexPlayer][0]['minus'] +
                        changeBallData[indexPlayer][1]['minus'] +
                        changeBallData[indexPlayer][2]['minus'] as int,
                    "equal": changeBallData[indexPlayer][0]['equal'] +
                        changeBallData[indexPlayer][1]['equal'] +
                        changeBallData[indexPlayer][2]['equal'] as int,
                    "hashtag": changeBallData[indexPlayer][0]['hashtag'] +
                        changeBallData[indexPlayer][1]['hashtag'] +
                        changeBallData[indexPlayer][2]['hashtag'] as int,
                    "eff%": double.parse((changeBallData[indexPlayer][0]
                                ['eff%'] +
                            changeBallData[indexPlayer][1]['eff%'] +
                            changeBallData[indexPlayer][2]['eff%'] / 3)
                        .toStringAsFixed(2)),
                  });
                  indexPlayer++;
                }
                //! attacco
                bphashtagData = [
                  [
                    {"bpH": 0},
                    {"bpH": 0},
                    {"bpH": 0},
                  ],
                  [
                    {"bpH": 0},
                    {"bpH": 0},
                    {"bpH": 0},
                  ],
                  [
                    {"bpH": 0},
                    {"bpH": 0},
                    {"bpH": 0},
                  ],
                  [
                    {"bpH": 0},
                    {"bpH": 0},
                    {"bpH": 0},
                  ],
                ];
                breakPointData = [
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                  [
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                    {
                      "tot": 0,
                      "plus": 0,
                      "minus": 0,
                      "equal": 0,
                      "hashtag": 0,
                      "eff%": 0.0
                    },
                  ],
                ];
                tothashtag = 0;
                totplus = 0;
                totminus = 0;
                totequal = 0;
                totaleBeat = 0;
                indexPlayer = 0;
                for (var player in players) {
                  tothashtag = 0;
                  totplus = 0;
                  totminus = 0;
                  totequal = 0;
                  totaleBeat = 0;

                  hashtag = 0;
                  plus = 0;
                  minus = 0;
                  equal = 0;
                  tot = 0;
                  BreakPointState acctionsPlayState = BreakPointState();

                  for (int curentSet = 1; curentSet <= 3; curentSet++) {
                    hashtag = 0;
                    plus = 0;
                    minus = 0;
                    equal = 0;
                    tot = 0;
                    for (var element in beats) {
                      if (curentSet == element.currentSet) {
                        if (player.surname == element.playersurname) {
                          if (((element.state == 'BreackPointState()' ||
                                      element.state == 'BreackPointState') &&
                                  element.breackpointNum == 0 &&
                                  element.method != 'WallAttackBK' &&
                                  acctionsPlayState
                                      is ChangeBallAcctionState) ||
                              (element.method == "WallAttackBK" &&
                                  acctionsPlayState is BreakPointState) ||
                              ((element.state == 'BreackPointState()' ||
                                      element.state == 'BreackPointState') &&
                                  element.breackpointNum != 0 &&
                                  acctionsPlayState is BreakPointState) ||
                              ((element.method == "QuickreceivingOtherFields" ||
                                      element.method == 'QuickAce') &&
                                  acctionsPlayState
                                      is ChangeBallAcctionState)) {
                            tot++;
                            if (element.method == "attachmentPointBK" ||
                                element.method == 'WallAttackBK') {
                              player.team == '1' && player.player == '1'
                                  ? print("addhashtag")
                                  : null;
                              hashtag++;
                            } else if (element.method == 'replayableattack') {
                              plus++;
                            } else if (element.method == 'defendedattack' ||
                                element.method == 'QuickreceivingOtherFields') {
                              minus++;
                            } else if (element.method == 'attackErrorBK' ||
                                element.method == 'QuickAce' ||
                                element.method == "errorRaisedBK") {
                              equal++;
                            }
                          }
                        }
                      }
                    }
                    totaleBeat += tot;
                    totequal += equal;
                    totplus += plus;
                    totminus += minus;
                    tothashtag += hashtag;
                    if (hashtag != 0) {
                      print("addedHashtag currentSet: " +
                          curentSet.toString() +
                          "player :${player.name}");
                    }

                    bphashtagData[indexPlayer][curentSet - 1] = {
                      'bpH': hashtag,
                    };
                    breakPointData[indexPlayer][curentSet - 1] = {
                      "tot": tot,
                      "plus": plus,
                      "minus": minus,
                      "equal": equal,
                      "hashtag": hashtag,
                      "eff%": tot == 0
                          ? 0
                          : double.parse(
                              ((hashtag / tot) * 100).toStringAsFixed(2))
                    };
                  }
                  bphashtagData[indexPlayer].add({
                    'bpH': tothashtag,
                  });
                  breakPointData[indexPlayer].add({
                    "tot": breakPointData[indexPlayer][0]['tot'] +
                        breakPointData[indexPlayer][1]['tot'] +
                        breakPointData[indexPlayer][2]['tot'] as int,
                    "plus": breakPointData[indexPlayer][0]['plus'] +
                        breakPointData[indexPlayer][1]['plus'] +
                        breakPointData[indexPlayer][2]['plus'] as int,
                    "minus": breakPointData[indexPlayer][0]['minus'] +
                        breakPointData[indexPlayer][1]['minus'] +
                        breakPointData[indexPlayer][2]['minus'] as int,
                    "equal": breakPointData[indexPlayer][0]['equal'] +
                        breakPointData[indexPlayer][1]['equal'] +
                        breakPointData[indexPlayer][2]['equal'] as int,
                    "hashtag": breakPointData[indexPlayer][0]['hashtag'] +
                        breakPointData[indexPlayer][1]['hashtag'] +
                        breakPointData[indexPlayer][2]['hashtag'] as int,
                    "eff%": breakPointData[indexPlayer][0]['eff%'] +
                        breakPointData[indexPlayer][1]['eff%'] +
                        breakPointData[indexPlayer][2]['eff%'] / 3 as double,
                  });
                  indexPlayer++;
                }
                // errori
                errorsData = [
                  [
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                  ],
                  [
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                  ],
                  [
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                  ],
                  [
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                    {
                      "cpE": 0,
                      "bpE": 0,
                    },
                  ],
                ];
                tothashtag = 0;
                totplus = 0;
                totminus = 0;
                totequal = 0;
                totaleBeat = 0;
                indexPlayer = 0;
                for (var player in players) {
                  tothashtag = 0;
                  totplus = 0;
                  totminus = 0;
                  totequal = 0;
                  totaleBeat = 0;

                  hashtag = 0;
                  plus = 0;
                  minus = 0;
                  equal = 0;
                  tot = 0;
                  for (int curentSet = 1; curentSet <= 3; curentSet++) {
                    hashtag = 0;
                    plus = 0;
                    minus = 0;
                    equal = 0;
                    tot = 0;
                    for (var element in beats) {
                      if (curentSet == element.currentSet) {
                        if (player.surname == element.playersurname) {
                          if (element.method == 'attackErrorBK' &&
                              element.breackpointNum == 0) {
                            hashtag++;
                            tot++;
                          } else if (element.method == 'attackErrorBK' &&
                              element.breackpointNum != 0) {
                            plus++;
                            tot++;
                          }
                        }
                      }
                    }
                    errorsData[indexPlayer][curentSet - 1] = {
                      "cpE": hashtag,
                      "bpE": plus,
                    };
                    totaleBeat += tot;
                    totequal += equal;
                    totplus += plus;
                    totminus += minus;
                    tothashtag += hashtag;
                  }
                  errorsData[indexPlayer].add({
                    "cpE": tothashtag,
                    "bpE": totplus,
                  });
                  indexPlayer++;
                }

                wallData = [
                  [
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                  ],
                  [
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                  ],
                  [
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                  ],
                  [
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                    {
                      "wall": 0,
                    },
                  ],
                ];
                print("wallData $wallData");
                tothashtag = 0;
                totplus = 0;
                totminus = 0;
                totequal = 0;
                totaleBeat = 0;
                indexPlayer = 0;
                for (var player in players) {
                  hashtag = 0;
                  plus = 0;
                  minus = 0;
                  equal = 0;
                  tot = 0;
                  tothashtag = 0;
                  totplus = 0;
                  totminus = 0;
                  totequal = 0;
                  totaleBeat = 0;
                  for (int curentSet = 1; curentSet <= 3; curentSet++) {
                    hashtag = 0;
                    plus = 0;
                    minus = 0;
                    equal = 0;
                    tot = 0;
                    for (var element in beats) {
                      if (curentSet == element.currentSet) {
                        if (player.surname == element.playersurname) {
                          if (element.method == 'WallAttackBK') {
                            print("wall player" + player.name);
                            tot++;
                          }
                        }
                      }
                    }
                    wallData[indexPlayer][curentSet - 1] = {
                      "wall": tot,
                    };
                    totaleBeat += tot;
                    totequal += equal;
                    totplus += plus;
                    totminus += minus;
                    tothashtag += hashtag;
                  }

                  wallData[indexPlayer].add({
                    "wall": totaleBeat,
                  });
                  indexPlayer++;
                }
                print("walldata $wallData");
                double pthash(int x, int y) {
                  double numerator = wallData[x][y]['wall'].toDouble() +
                      (cphashtagData[x][y]['cpH'].toDouble() +
                          bphashtagData[x][y]['bpH'].toDouble());

                  double denominator = changeBallData[x][y]['tot'].toDouble() +
                      breakPointData[x][y]['tot'].toDouble();

                  double result;

                  if (denominator != 0) {
                    result = ((numerator / denominator) * 100);
                  } else {
                    result =
                        0; // or whatever value you want when denominator is zero
                  }
                  return double.parse((result).toStringAsFixed(2));
                }

                attackData = [
                  [
                    {
                      "tot": changeBallData[0][0]['tot'] +
                          breakPointData[0][0]['tot'],
                      "cp": changeBallData[0][0]['tot'],
                      "bp": breakPointData[0][0]['tot'],
                      "err": errorsData[0][0]['cpE'] + errorsData[0][0]['bpE'],
                      "mur": wallData[0][0]['wall'],
                      "pt": cphashtagData[0][0]['cpH'] +
                          bphashtagData[0][0]['bpH'],
                      "eff%": pthash(0, 0)
                    },
                    {
                      "tot": changeBallData[0][1]['tot'] +
                          breakPointData[0][1]['tot'],
                      "cp": changeBallData[0][1]['tot'],
                      "bp": breakPointData[0][1]['tot'],
                      "err": errorsData[0][1]['cpE'] + errorsData[0][1]['bpE'],
                      "mur": wallData[0][1]['wall'],
                      "pt": cphashtagData[0][1]['cpH'] +
                          bphashtagData[0][1]['bpH'],
                      "eff%": pthash(0, 1)
                    },
                    {
                      "tot": changeBallData[0][2]['tot'] +
                          breakPointData[0][2]['tot'],
                      "cp": changeBallData[0][2]['tot'],
                      "bp": breakPointData[0][2]['tot'],
                      "err": errorsData[0][2]['cpE'] + errorsData[0][2]['bpE'],
                      "mur": wallData[0][2]['wall'],
                      "pt": cphashtagData[0][2]['cpH'] +
                          bphashtagData[0][2]['bpH'],
                      "eff%": pthash(0, 2)
                    },
                    {
                      "tot": changeBallData[0][3]['tot'] +
                          breakPointData[0][3]['tot'],
                      "cp": changeBallData[0][3]['tot'],
                      "bp": breakPointData[0][3]['tot'],
                      "err": errorsData[0][3]['cpE'] + errorsData[0][3]['bpE'],
                      "mur": wallData[0][3]['wall'],
                      "pt": cphashtagData[0][3]['cpH'] +
                          bphashtagData[0][3]['bpH'],
                      "eff%": pthash(0, 3)
                    },
                  ],
                  [
                    {
                      "tot": changeBallData[1][0]['tot'] +
                          breakPointData[1][0]['tot'],
                      "cp": changeBallData[1][0]['tot'],
                      "bp": breakPointData[1][0]['tot'],
                      "err": errorsData[1][0]['cpE'] + errorsData[1][0]['bpE'],
                      "mur": wallData[1][0]['wall'],
                      "pt": cphashtagData[1][0]['cpH'] +
                          bphashtagData[1][0]['bpH'],
                      "eff%": pthash(1, 0)
                    },
                    {
                      "tot": changeBallData[1][1]['tot'] +
                          breakPointData[1][1]['tot'],
                      "cp": changeBallData[1][1]['tot'],
                      "bp": breakPointData[1][1]['tot'],
                      "err": errorsData[1][1]['cpE'] + errorsData[1][1]['bpE'],
                      "mur": wallData[1][1]['wall'],
                      "pt": cphashtagData[1][1]['cpH'] +
                          bphashtagData[1][1]['bpH'],
                      "eff%": pthash(1, 1)
                    },
                    {
                      "tot": changeBallData[1][2]['tot'] +
                          breakPointData[1][2]['tot'],
                      "cp": changeBallData[1][2]['tot'],
                      "bp": breakPointData[1][2]['tot'],
                      "err": errorsData[1][2]['cpE'] + errorsData[1][2]['bpE'],
                      "mur": wallData[1][2]['wall'],
                      "pt": cphashtagData[1][2]['cpH'] +
                          bphashtagData[1][2]['bpH'],
                      "eff%": pthash(1, 2)
                    },
                    {
                      "tot": changeBallData[1][3]['tot'] +
                          breakPointData[1][3]['tot'],
                      "cp": changeBallData[1][3]['tot'],
                      "bp": breakPointData[1][3]['tot'],
                      "err": errorsData[1][3]['cpE'] + errorsData[1][3]['bpE'],
                      "mur": wallData[1][3]['wall'],
                      "pt": cphashtagData[1][3]['cpH'] +
                          bphashtagData[1][3]['bpH'],
                      "eff%": pthash(1, 3)
                    },
                  ],
                  [
                    {
                      "tot": changeBallData[2][0]['tot'] +
                          breakPointData[2][0]['tot'],
                      "cp": changeBallData[2][0]['tot'],
                      "bp": breakPointData[2][0]['tot'],
                      "err": errorsData[2][0]['cpE'] + errorsData[2][0]['bpE'],
                      "mur": wallData[2][0]['wall'],
                      "pt": cphashtagData[2][0]['cpH'] +
                          bphashtagData[2][0]['bpH'],
                      "eff%": pthash(2, 0)
                    },
                    {
                      "tot": changeBallData[2][1]['tot'] +
                          breakPointData[2][1]['tot'],
                      "cp": changeBallData[2][1]['tot'],
                      "bp": breakPointData[2][1]['tot'],
                      "err": errorsData[2][1]['cpE'] + errorsData[2][1]['bpE'],
                      "mur": wallData[2][1]['wall'],
                      "pt": cphashtagData[2][1]['cpH'] +
                          bphashtagData[2][1]['bpH'],
                      "eff%": pthash(2, 1)
                    },
                    {
                      "tot": changeBallData[2][2]['tot'] +
                          breakPointData[2][2]['tot'],
                      "cp": changeBallData[2][2]['tot'],
                      "bp": breakPointData[2][2]['tot'],
                      "err": errorsData[2][2]['cpE'] + errorsData[2][2]['bpE'],
                      "mur": wallData[2][2]['wall'],
                      "pt": cphashtagData[2][2]['cpH'] +
                          bphashtagData[2][2]['bpH'],
                      "eff%": pthash(2, 2)
                    },
                    {
                      "tot": changeBallData[2][3]['tot'] +
                          breakPointData[2][3]['tot'],
                      "cp": changeBallData[2][3]['tot'],
                      "bp": breakPointData[2][3]['tot'],
                      "err": errorsData[2][3]['cpE'] + errorsData[2][3]['bpE'],
                      "mur": wallData[2][3]['wall'],
                      "pt": cphashtagData[2][3]['cpH'] +
                          bphashtagData[2][3]['bpH'],
                      "eff%": pthash(2, 3)
                    },
                  ],
                  [
                    {
                      "tot": changeBallData[3][0]['tot'] +
                          breakPointData[3][0]['tot'],
                      "cp": changeBallData[3][0]['tot'],
                      "bp": breakPointData[3][0]['tot'],
                      "err": errorsData[3][0]['cpE'] + errorsData[3][0]['bpE'],
                      "mur": wallData[3][0]['wall'],
                      "pt": cphashtagData[3][0]['cpH'] +
                          bphashtagData[3][0]['bpH'],
                      "eff%": pthash(3, 0)
                    },
                    {
                      "tot": changeBallData[3][1]['tot'] +
                          breakPointData[3][1]['tot'],
                      "cp": changeBallData[3][1]['tot'],
                      "bp": breakPointData[3][1]['tot'],
                      "err": errorsData[3][1]['cpE'] + errorsData[3][1]['bpE'],
                      "mur": wallData[3][1]['wall'],
                      "pt": cphashtagData[3][1]['cpH'] +
                          bphashtagData[3][1]['bpH'],
                      "eff%": pthash(3, 1)
                    },
                    {
                      "tot": changeBallData[3][2]['tot'] +
                          breakPointData[3][2]['tot'],
                      "cp": changeBallData[3][2]['tot'],
                      "bp": breakPointData[3][2]['tot'],
                      "err": errorsData[3][2]['cpE'] + errorsData[3][2]['bpE'],
                      "mur": wallData[3][2]['wall'],
                      "pt": cphashtagData[3][2]['cpH'] +
                          bphashtagData[3][2]['bpH'],
                      "eff%": pthash(3, 2)
                    },
                    {
                      "tot": changeBallData[3][3]['tot'] +
                          breakPointData[3][3]['tot'],
                      "cp": changeBallData[3][3]['tot'],
                      "bp": breakPointData[3][3]['tot'],
                      "err": errorsData[3][3]['cpE'] + errorsData[3][3]['bpE'],
                      "mur": wallData[3][3]['wall'],
                      "pt": cphashtagData[3][3]['cpH'] +
                          bphashtagData[3][3]['bpH'],
                      "eff%": pthash(3, 3)
                    },
                  ],
                  [
                    {
                      "tot": changeBallData[3][0]['tot'] +
                          breakPointData[3][0]['tot'],
                      "cp": changeBallData[3][0]['tot'],
                      "bp": breakPointData[3][0]['tot'],
                      "err": errorsData[3][0]['cpE'] + errorsData[3][0]['bpE'],
                      "mur": wallData[3][0]['wall'],
                      "pt": cphashtagData[3][0]['cpH'] +
                          bphashtagData[3][0]['bpH'],
                      "eff%": pthash(3, 0)
                    },
                    {
                      "tot": changeBallData[3][1]['tot'] +
                          breakPointData[3][1]['tot'],
                      "cp": changeBallData[3][1]['tot'],
                      "bp": breakPointData[3][1]['tot'],
                      "err": errorsData[3][1]['cpE'] + errorsData[3][1]['bpE'],
                      "mur": wallData[3][1]['wall'],
                      "pt": cphashtagData[3][1]['cpH'] +
                          bphashtagData[3][1]['bpH'],
                      "eff%": pthash(3, 1)
                    },
                    {
                      "tot": changeBallData[3][2]['tot'] +
                          breakPointData[3][2]['tot'],
                      "cp": changeBallData[3][2]['tot'],
                      "bp": breakPointData[3][2]['tot'],
                      "err": errorsData[3][2]['cpE'] + errorsData[3][2]['bpE'],
                      "mur": wallData[3][2]['wall'],
                      "pt": cphashtagData[3][2]['cpH'] +
                          bphashtagData[3][2]['bpH'],
                      "eff%": pthash(3, 2)
                    },
                    {
                      "tot": changeBallData[3][3]['tot'] +
                          breakPointData[3][3]['tot'],
                      "cp": changeBallData[3][3]['tot'],
                      "bp": breakPointData[3][3]['tot'],
                      "err": errorsData[3][3]['cpE'] + errorsData[3][3]['bpE'],
                      "mur": wallData[3][3]['wall'],
                      "pt": cphashtagData[3][3]['cpH'] +
                          bphashtagData[3][3]['bpH'],
                      "eff%": pthash(3, 3)
                    },
                  ],
                  [
                    {
                      "tot": changeBallData[3][0]['tot'] +
                          breakPointData[3][0]['tot'],
                      "cp": changeBallData[3][0]['tot'],
                      "bp": breakPointData[3][0]['tot'],
                      "err": errorsData[3][0]['cpE'] + errorsData[3][0]['bpE'],
                      "mur": wallData[3][0]['wall'],
                      "pt": cphashtagData[3][0]['cpH'] +
                          bphashtagData[3][0]['bpH'],
                      "eff%": pthash(3, 0)
                    },
                    {
                      "tot": changeBallData[3][1]['tot'] +
                          breakPointData[3][1]['tot'],
                      "cp": changeBallData[3][1]['tot'],
                      "bp": breakPointData[3][1]['tot'],
                      "err": errorsData[3][1]['cpE'] + errorsData[3][1]['bpE'],
                      "mur": wallData[3][1]['wall'],
                      "pt": cphashtagData[3][1]['cpH'] +
                          bphashtagData[3][1]['bpH'],
                      "eff%": pthash(3, 1)
                    },
                    {
                      "tot": changeBallData[3][2]['tot'] +
                          breakPointData[3][2]['tot'],
                      "cp": changeBallData[3][2]['tot'],
                      "bp": breakPointData[3][2]['tot'],
                      "err": errorsData[3][2]['cpE'] + errorsData[3][2]['bpE'],
                      "mur": wallData[3][2]['wall'],
                      "pt": cphashtagData[3][2]['cpH'] +
                          bphashtagData[3][2]['bpH'],
                      "eff%": pthash(3, 2)
                    },
                    {
                      "tot": changeBallData[3][3]['tot'] +
                          breakPointData[3][3]['tot'],
                      "cp": changeBallData[3][3]['tot'],
                      "bp": breakPointData[3][3]['tot'],
                      "err": errorsData[3][3]['cpE'] + errorsData[3][3]['bpE'],
                      "mur": wallData[3][3]['wall'],
                      "pt": cphashtagData[3][3]['cpH'] +
                          bphashtagData[3][3]['bpH'],
                      "eff%": pthash(3, 3)
                    },
                  ],
                ];
                //to check postion of data
                // for (int i = 0; i < 4; i++) {
                //   for (int j = 0; j < 3; j++) {
                //     beatsData[i][j] = {'tot': i + j, 'err': i + j, 'pt': i + j};
                //   }
                // }
                // for (int i = 0; i < 4; i++) {
                //   for (int j = 0; j < 3; j++) {
                //     changeBallData[i][j] = {
                //       'tot': i + j,
                //       'equal': i + j,
                //       'pt': i + j,
                //       'plus': i + j,
                //       'minus': i + j,
                //       'hashtag': i + j,
                //       "eff%": i + j
                //     };
                //   }
                // }
                // for (int i = 0; i < 4; i++) {
                //   for (int j = 0; j < 3; j++) {
                //     attackData[i][j] = {
                //       "tot": i + j,
                //       "cp": i + j,
                //       "bp": i + j,
                //       "err": i + j,
                //       "mur": i + j,
                //       "pt": i + j,
                //       "eff%": i + j
                //     };
                //   }
                // }
                totalPoints = [
                  [
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                  ],
                  [
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                  ],
                  [
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                  ],
                  [
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                  ],
                  [
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                  ],
                  [
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                    {
                      "tot": 0,
                    },
                  ],
                ];
                for (int i = 0; i <= 5; i++) {
                  for (int j = 0; j < 3; j++) {
                    if (i == 4) {
                      totalPoints[i][j] = {
                        "tot": beatsData[0][j]['pt'] +
                            attackData[0][j]['mur'] +
                            attackData[0][j]['pt'] +
                            beatsData[1][j]['pt'] +
                            attackData[1][j]['mur'] +
                            attackData[1][j]['pt'] as int
                      };
                    } else if (i == 5) {
                      totalPoints[i][j] = {
                        "tot": beatsData[2][j]['pt'] +
                            attackData[2][j]['mur'] +
                            attackData[2][j]['pt'] +
                            beatsData[3][j]['pt'] +
                            attackData[3][j]['mur'] +
                            attackData[3][j]['pt'] as int
                      };
                    } else {
                      totalPoints[i][j] = {
                        "tot": beatsData[i][j]['pt'] +
                            attackData[i][j]['mur'] +
                            attackData[i][j]['pt'] as int
                      };
                    }
                  }
                }
                for (int i = 4; i <= 5; i++) {
                  for (int j = 0; j < 3; j++) {
                    beatsData[i][j] = {
                      "tot": i == 4
                          ? beatsData[0][j]['tot'] + beatsData[1][j]['tot']
                              as int
                          : beatsData[2][j]['tot'] + beatsData[3][j]['tot']
                              as int,
                      "err": i == 4
                          ? beatsData[0][j]['err'] + beatsData[1][j]['err']
                              as int
                          : beatsData[2][j]['err'] + beatsData[3][j]['err']
                              as int,
                      "pt": i == 4
                          ? beatsData[0][j]['pt'] + beatsData[1][j]['pt'] as int
                          : beatsData[2][j]['pt'] + beatsData[3][j]['pt']
                              as int,
                    };
                    changeBallData[i][j] = {
                      "tot": i == 4
                          ? (changeBallData[0][j]['tot'] as num) +
                              (changeBallData[1][j]['tot'] as num)
                          : (changeBallData[2][j]['tot'] as num) +
                              (changeBallData[3][j]['tot'] as num),
                      "plus": i == 4
                          ? (changeBallData[0][j]['plus'] as num) +
                              (changeBallData[1][j]['plus'] as num)
                          : (changeBallData[2][j]['plus'] as num) +
                              (changeBallData[3][j]['plus'] as num),
                      "minus": i == 4
                          ? (changeBallData[0][j]['minus'] as num) +
                              (changeBallData[1][j]['minus'] as num)
                          : (changeBallData[2][j]['minus'] as num) +
                              (changeBallData[3][j]['minus'] as num),
                      "equal": i == 4
                          ? (changeBallData[0][j]['equal'] as num) +
                              (changeBallData[1][j]['equal'] as num)
                          : (changeBallData[2][j]['equal'] as num) +
                              (changeBallData[3][j]['equal'] as num),
                      "hashtag": i == 4
                          ? (changeBallData[0][j]['hashtag'] as num) +
                              (changeBallData[1][j]['hashtag'] as num)
                          : (changeBallData[2][j]['hashtag'] as num) +
                              (changeBallData[3][j]['hashtag'] as num),
                      "eff%": i == 4
                          ? ((changeBallData[0][j]['eff%'] as num).toDouble() +
                                  (changeBallData[1][j]['eff%'] as num)
                                      .toDouble()) /
                              2
                          : ((changeBallData[2][j]['eff%'] as num).toDouble() +
                                  (changeBallData[3][j]['eff%'] as num)
                                      .toDouble()) /
                              2
                    };

                    attackData[i][j] = {
                      "tot": i == 4
                          ? attackData[0][j]['tot'] + attackData[1][j]['tot']
                          : attackData[2][j]['tot'] + attackData[3][j]['tot'],
                      "cp": i == 4
                          ? attackData[0][j]['cp'] + attackData[1][j]['cp']
                          : attackData[2][j]['cp'] + attackData[3][j]['cp'],
                      "bp": i == 4
                          ? attackData[0][j]['bp'] + attackData[1][j]['bp']
                          : attackData[2][j]['bp'] + attackData[3][j]['bp'],
                      "err": i == 4
                          ? attackData[0][j]['err'] + attackData[1][j]['err']
                          : attackData[2][j]['err'] + attackData[3][j]['err'],
                      "mur": i == 4
                          ? attackData[0][j]['mur'] + attackData[1][j]['mur']
                          : attackData[2][j]['mur'] + attackData[3][j]['mur'],
                      "pt": i == 4
                          ? attackData[0][j]['pt'] + attackData[1][j]['pt']
                          : attackData[2][j]['pt'] + attackData[3][j]['pt'],
                      "eff%": i == 4
                          ? (attackData[0][j]['eff%'] +
                                  attackData[1][j]['eff%']) /
                              2
                          : (attackData[2][j]['eff%'] +
                                  attackData[3][j]['eff%']) /
                              2,
                    };
                  }
                }
                print(beatsData[4]);
                Positioned myTable(double top, double left, int player) {
                  return Positioned(
                      top: top,
                      left: left,
                      child: Container(
                        width: 1200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player == 4
                                  ? "${matchState.aMatch.player1.name} ${matchState.aMatch.player1.surname} - ${matchState.aMatch.player2.name} ${matchState.aMatch.player2.surname}"
                                  : player == 5
                                      ? "${matchState.aMatch.player3.name} ${matchState.aMatch.player3.surname} - ${matchState.aMatch.player4.name} ${matchState.aMatch.player4.surname}"
                                      : (player == 0
                                          ? "${matchState.aMatch.player1.name} ${matchState.aMatch.player1.surname}"
                                          : player == 1
                                              ? "${matchState.aMatch.player2.name} ${matchState.aMatch.player2.surname}"
                                              : player == 2
                                                  ? "${matchState.aMatch.player3.name} ${matchState.aMatch.player3.surname}"
                                                  : "${matchState.aMatch.player4.name} ${matchState.aMatch.player4.surname}"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Table(
                              border: TableBorder.all(
                                  color: Colors.black, width: 3),
                              columnWidths: const {
                                0: FlexColumnWidth(0.1),
                                1: FlexColumnWidth(0.1),
                                2: FlexColumnWidth(0.3),
                                3: FlexColumnWidth(0.6),
                                4: FlexColumnWidth(0.7),
                              },
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.black)),
                                    children: [
                                      TableCell(
                                          child: Center(
                                        child: Text(
                                          "Set",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      TableCell(
                                          child: Center(
                                        child: Text(
                                          lang!.point,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      TableCell(
                                          child: Container(
                                        height: 40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              lang.beat,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "tot",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "err=",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "pt#",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                      TableCell(
                                          child: Container(
                                        height: 40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              lang.changeBall,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "tot",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "+",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "=",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "pt#",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "eff%",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                      TableCell(
                                          child: Container(
                                        height: 40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              lang.attack,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "tot",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "cp",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "bp",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "err=",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "mur#",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "pt#",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "pt%",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                    ]),
                                //TODO: set 1
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2)),
                                          child: Text(
                                            '1',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2)),
                                          child: Text(
                                            totalPoints[player][0]['tot']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),
                                  //? batutta
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            beatsData[player][0]['tot']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          beatsData[player][0]['err']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          beatsData[player][0]['pt'].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                  // *cambio palla
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][0]['tot']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][0]['plus']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][0]['minus']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][0]['equal']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][0]['hashtag']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][0]['eff%']
                                                  .toString() +
                                              '%',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                  // attacco
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][0]['tot']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][0]['cp']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][0]['bp']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][0]['err']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][0]['mur']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][0]['pt']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][0]['eff%']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                ]),
                                //TODO: set 2
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2)),
                                          child: Text(
                                            '2',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2)),
                                          child: Text(
                                            totalPoints[player][1]['tot']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),

                                  //? batutta
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            beatsData[player][1]['tot']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          beatsData[player][1]['err']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          beatsData[player][1]['pt'].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                  // *cambio palla
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][1]['tot']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][1]['plus']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][1]['minus']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][1]['equal']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][1]['hashtag']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][1]['eff%']
                                                  .toString() +
                                              '%',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                  // attacco
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][1]['tot']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][1]['cp']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][1]['bp']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][1]['err']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][1]['mur']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][1]['pt']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][1]['eff%']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                ]),
                                //TODO: set 3
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2)),
                                          child: Text(
                                            '3',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2)),
                                          child: Text(
                                            totalPoints[player][2]['tot']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))),

                                  //? batutta
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            beatsData[player][2]['tot']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          beatsData[player][2]['err']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          beatsData[player][2]['pt'].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                  // *cambio palla
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][2]['tot']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][2]['plus']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][2]['minus']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][2]['equal']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][2]['hashtag']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          changeBallData[player][2]['eff%']
                                                  .toString() +
                                              '%',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                  // attacco
                                  TableCell(
                                      child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][2]['tot']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][2]['cp']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][2]['bp']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][2]['err']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][2]['mur']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][2]['pt']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attackData[player][2]['eff%']
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                    ],
                                  )),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ));
                }

                Future<String> generatePdf() async {
                  final screenshot = await screenshotController.capture();
                  final img = pw.MemoryImage(screenshot!.buffer.asUint8List());

                  // Calculate the aspect ratio of the screenshot
                  final aspectRatio = 2000 / 1400;

                  // Set the width and height of the PDF page based on the aspect ratio
                  final pdfWidth = 2000;
                  final pdfHeight = (pdfWidth / aspectRatio).round();

                  final pdf = pw.Document();

                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat(
                          pdfWidth.toDouble(), pdfHeight.toDouble()),
                      build: (pw.Context context) =>
                          pw.Image(img, height: 1400, width: 2000),
                    ),
                  );

                  final output = await getTemporaryDirectory();
                  final file = File(
                      '${output.path}/${matchState.aMatch.date.replaceAll('/', '-')}-${matchState.aMatch.location}-${matchState.aMatch.description}.pdf');
                  await file.writeAsBytes(await pdf.save());

                  return file.path;
                }

                return WillPopScope(
                  onWillPop: () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartMatch(
                              fromChoosePage: false, account: widget.account),
                        ));
                    return true;
                  },
                  child: SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async =>
                                    false, // Ignore the back button press
                                child: FutureBuilder(
                                  future: generatePdf(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              lang!.pdfgeneration + "...",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                      // Open the PDF file with the default PDF viewer
                                      OpenFile.open(snapshot.data);
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                        backgroundColor: theme.colorScheme.secondary,
                        child: Icon(
                          Icons.save,
                          color: theme.primaryColor,
                        ),
                      ),
                      body: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Screenshot(
                              controller: screenshotController,
                              child: Container(
                                color: Colors.white,
                                width: 2000,
                                padding: EdgeInsets.all(10),
                                height: 1600,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        height: 25,
                                        width: 150,
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                            child: Text(
                                          '${lang!.tournamentTitle} : ${matchState.aMatch.description}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                      ),
                                    ),
                                    Positioned(
                                      top: 25,
                                      left: 0,
                                      child: Container(
                                        height: 25,
                                        width: 150,
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                            child: Text(
                                          '${lang!.date} : ${matchState.aMatch.date}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                      ),
                                    ),
                                    Positioned(
                                      top: 60,
                                      left: 0,
                                      child: Container(
                                        height: 25,
                                        width: 150,
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                            child: Text(
                                          '${matchState.aMatch.player1.surname} - ${matchState.aMatch.player2.surname}:\t$homeScoore',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                      ),
                                    ),
                                    Positioned(
                                      top: 85,
                                      left: 0,
                                      child: Container(
                                        height: 25,
                                        width: 150,
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                            child: Text(
                                          '${matchState.aMatch.player3.surname} - ${matchState.aMatch.player4.surname}:\t$awayScoore',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        )),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: SizedBox(
                                        width: 200,
                                        height: 50,
                                        child: FittedBox(
                                          child: Text(
                                            '${lang.description} : ${matchState.aMatch.description}\n${lang.location} : ${matchState.aMatch.location}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        height: 50 * 6 + 100,
                                        width: 300,
                                        alignment: Alignment.topCenter,
                                        child: Table(
                                          border: TableBorder.all(
                                              color: Colors.black, width: 2),
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                  child: SizedBox(
                                                height: 100,
                                                width: 300,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                        top: 20,
                                                        left: 20,
                                                        child: Container(
                                                            width: 100,
                                                            height: 30,
                                                            alignment: Alignment
                                                                .center,
                                                            child: FittedBox(
                                                                child: Text(
                                                              matchState
                                                                  .aMatch
                                                                  .player1
                                                                  .surname,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )))),
                                                    Positioned(
                                                        top: 50,
                                                        left: 20,
                                                        child: Container(
                                                            width: 100,
                                                            height: 30,
                                                            alignment: Alignment
                                                                .center,
                                                            child: FittedBox(
                                                                child: Text(
                                                              matchState
                                                                  .aMatch
                                                                  .player2
                                                                  .surname,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )))),
                                                    Positioned(
                                                        top: 20,
                                                        right: 20,
                                                        child: Container(
                                                            width: 100,
                                                            height: 30,
                                                            alignment: Alignment
                                                                .center,
                                                            child: FittedBox(
                                                                child: Text(
                                                              matchState
                                                                  .aMatch
                                                                  .player3
                                                                  .surname,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )))),
                                                    Positioned(
                                                        top: 50,
                                                        right: 20,
                                                        child: Container(
                                                            width: 100,
                                                            height: 30,
                                                            alignment: Alignment
                                                                .center,
                                                            child: FittedBox(
                                                                child: Text(
                                                              matchState
                                                                  .aMatch
                                                                  .player4
                                                                  .surname,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )))),
                                                    Center(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 50,
                                                      child: const Text(
                                                        'vs',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      height: 30,
                                                    ))
                                                  ],
                                                ),
                                              )),
                                            ]),
                                            TableRow(children: [
                                              myCell(
                                                  (attackData[4][0]['pt'] +
                                                          attackData[4][1]
                                                              ['pt'] +
                                                          attackData[4][2]
                                                              ['pt'])
                                                      .toString(),
                                                  (attackData[5][0]['pt'] +
                                                          attackData[5][1]
                                                              ['pt'] +
                                                          attackData[5][2]
                                                              ['pt'])
                                                      .toString(),
                                                  lang.attack)
                                            ]),
                                            TableRow(children: [
                                              myCell(
                                                  (wallData[0][3]['wall'] +
                                                          wallData[1][3]
                                                              ['wall'])
                                                      .toString(),
                                                  (wallData[2][3]['wall'] +
                                                          wallData[3][3]
                                                              ['wall'])
                                                      .toString(),
                                                  lang.wall)
                                            ]),
                                            TableRow(children: [
                                              myCell(
                                                  (beatsData[4][0]['pt'] +
                                                          beatsData[4][1]
                                                              ['pt'] +
                                                          beatsData[4][2]['pt'])
                                                      .toString(),
                                                  (beatsData[5][0]['pt'] +
                                                          beatsData[5][1]
                                                              ['pt'] +
                                                          beatsData[5][2]['pt'])
                                                      .toString(),
                                                  lang.beat)
                                            ]),
                                            TableRow(children: [
                                              myCell(
                                                  (beatsData[4][0]['err'] +
                                                          beatsData[4][1]
                                                              ['err'] +
                                                          beatsData[4][2]
                                                              ['err'] +
                                                          attackData[4][0]
                                                              ['err'] +
                                                          attackData[4][1]
                                                              ['err'] +
                                                          attackData[4][2]
                                                              ['err'])
                                                      .toString(),
                                                  (beatsData[5][0]['err'] +
                                                          beatsData[5][1]
                                                              ['err'] +
                                                          beatsData[5][2]
                                                              ['err'] +
                                                          attackData[5][0]
                                                              ['err'] +
                                                          attackData[5][1]
                                                              ['err'] +
                                                          attackData[5][2]
                                                              ['err'])
                                                      .toString(),
                                                  '${lang.errors} ${lang.opponent}')
                                            ]),
                                            TableRow(children: [
                                              myCell(
                                                  ((attackData[4][0]['pt'] +
                                                              attackData[4][1]
                                                                  ['pt'] +
                                                              attackData[4][2]
                                                                  ['pt']) +
                                                          (wallData[0][3]['wall'] +
                                                              wallData[1][3]
                                                                  ['wall']) +
                                                          (beatsData[4][0]['pt'] +
                                                              beatsData[4][1]
                                                                  ['pt'] +
                                                              beatsData[4][2]
                                                                  ['pt']) +
                                                          (beatsData[4][0]['err'] +
                                                              beatsData[4][1]
                                                                  ['err'] +
                                                              beatsData[4][2]
                                                                  ['err'] +
                                                              attackData[4][0]
                                                                  ['err'] +
                                                              attackData[4][1]
                                                                  ['err'] +
                                                              attackData[4][2]
                                                                  ['err']))
                                                      .toString(),
                                                  ((attackData[5][0]['pt'] +
                                                              attackData[5][1]
                                                                  ['pt'] +
                                                              attackData[5][2]
                                                                  ['pt']) +
                                                          (wallData[2][3]['wall'] + wallData[3][3]['wall']) +
                                                          (beatsData[5][0]['pt'] + beatsData[5][1]['pt'] + beatsData[5][2]['pt']) +
                                                          (beatsData[5][0]['err'] + beatsData[5][1]['err'] + beatsData[5][2]['err'] + attackData[5][0]['err'] + attackData[5][1]['err'] + attackData[5][2]['err']))
                                                      .toString(),
                                                  lang.total)
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 150,
                                      child: Container(
                                        width: 800,
                                        height: 100,
                                        child: Table(
                                          columnWidths: {
                                            0: FlexColumnWidth(0.2),
                                            2: FlexColumnWidth(0.2),
                                          },
                                          border: TableBorder.all(
                                              color: Colors.black, width: 2),
                                          children: [
                                            TableRow(children: [
                                              const TableCell(
                                                  child: Center(
                                                      child: Text(
                                                'Set',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))),
                                              TableCell(
                                                  child: Center(
                                                child: Text(lang.partialscore,
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              )),
                                              TableCell(
                                                  child: Center(
                                                child: Text(lang.finalpoints,
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              )),
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                  child: Center(
                                                      child: Text("1",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet1
                                                                        .length >=
                                                                    1)
                                                                ? ""
                                                                : " ${partialScooreSet1[0]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet1
                                                                        .length >=
                                                                    2)
                                                                ? ""
                                                                : " ${partialScooreSet1[1]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet1
                                                                        .length >=
                                                                    3)
                                                                ? ""
                                                                : " ${partialScooreSet1[2]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet1
                                                                        .length >=
                                                                    4)
                                                                ? ""
                                                                : " ${partialScooreSet1[3]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet1
                                                                        .length >=
                                                                    5)
                                                                ? ""
                                                                : " ${partialScooreSet1[4]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet1
                                                                        .length >=
                                                                    6)
                                                                ? ""
                                                                : " ${partialScooreSet1[5]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TableCell(
                                                  child: Center(
                                                      child: Text(
                                                          "${matchState.aMatch.rouands![0].home}-${matchState.aMatch.rouands![0].away}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))),
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                  child: Center(
                                                      child: Text("2",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet2
                                                                        .length >=
                                                                    1)
                                                                ? ""
                                                                : " ${partialScooreSet2[0]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet2
                                                                        .length >=
                                                                    2)
                                                                ? ""
                                                                : " ${partialScooreSet2[1]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet2
                                                                        .length >=
                                                                    3)
                                                                ? ""
                                                                : " ${partialScooreSet2[2]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet2
                                                                        .length >=
                                                                    4)
                                                                ? ""
                                                                : " ${partialScooreSet2[3]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet2
                                                                        .length >=
                                                                    5)
                                                                ? ""
                                                                : " ${partialScooreSet2[4]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet2
                                                                        .length >=
                                                                    6)
                                                                ? ""
                                                                : " ${partialScooreSet2[5]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TableCell(
                                                  child: Center(
                                                      child: Text(
                                                          "${matchState.aMatch.rouands![1].home}-${matchState.aMatch.rouands![1].away}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                  child: Center(
                                                      child: Text("3",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet3
                                                                        .length >=
                                                                    1)
                                                                ? ""
                                                                : " ${partialScooreSet3[0]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet3
                                                                        .length >=
                                                                    2)
                                                                ? ""
                                                                : " ${partialScooreSet3[1]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet3
                                                                        .length >=
                                                                    3)
                                                                ? ""
                                                                : " ${partialScooreSet3[2]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet3
                                                                        .length >=
                                                                    4)
                                                                ? ""
                                                                : " ${partialScooreSet3[3]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet3
                                                                        .length >=
                                                                    5)
                                                                ? ""
                                                                : " ${partialScooreSet3[4]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: FittedBox(
                                                          child: Text(
                                                            !(partialScooreSet3
                                                                        .length >=
                                                                    6)
                                                                ? ""
                                                                : " ${partialScooreSet3[5]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TableCell(
                                                  child: Center(
                                                      child: Text(
                                                          "${matchState.aMatch.rouands![2].home}-${matchState.aMatch.rouands![2].away}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //1
                                    Positioned(
                                      right: 20,
                                      top: 350,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    //2
                                    Positioned(
                                      right: 350,
                                      top: 350,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    //3
                                    Positioned(
                                      right: 350,
                                      top: 550,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    //4
                                    Positioned(
                                      right: 20,
                                      top: 550,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    //5
                                    Positioned(
                                      right: 350,
                                      top: 950,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    //6
                                    Positioned(
                                      right: 20,
                                      top: 950,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    //7
                                    Positioned(
                                      right: 350,
                                      top: 950 + 200,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    //8
                                    Positioned(
                                      right: 20,
                                      top: 950 + 200,
                                      child: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: VolleyballField(
                                          isShowStatics: true,
                                        ),
                                      ),
                                    ),
                                    myTable(350, 0, 0),
                                    myTable(550, 0, 1),
                                    myTable(750, 0, 4),
                                    myTable(950, 0, 2),
                                    myTable(1150, 0, 3),
                                    myTable(1350, 0, 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }
      },
    );
  }
}

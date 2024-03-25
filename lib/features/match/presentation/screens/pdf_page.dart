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
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/scoore_cubit/scoore_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:screenshot/screenshot.dart';

class PdfStatistics extends StatefulWidget {
  const PdfStatistics({super.key});

  @override
  State<PdfStatistics> createState() => _PdfStatisticsState();
}

class _PdfStatisticsState extends State<PdfStatistics> {
  int totHomeScoore = 0;
  int totAwayScoore = 0;
  int homeScoore = 0;
  int awayScoore = 0;
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
                totHomeScoore = 0;
                totAwayScoore = 0;
                homeScoore = 0;
                awayScoore = 0;
                List<BeatAction> beats = beatsState.beats;

                List.generate(beats.length, (index) {
                  if (index == 0) {
                    totHomeScoore = 0;
                    totAwayScoore = 0;
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
                      print("cheak manual :${beats[index].playerTeam} ");
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
                      } else {
                        awayScoore++;
                      }
                    }
                  }
                });
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        final img = pw.MemoryImage(
                          (await screenshotController.capture())!
                              .buffer
                              .asUint8List(),
                        );

                        final pdf = pw.Document();

                        pdf.addPage(
                          pw.Page(
                            build: (pw.Context context) => pw.Image(img),
                          ),
                        );

                        final output = await getTemporaryDirectory();
                        final file = File(
                            '${output.path}/${matchState.aMatch.date.replaceAll('/', '-')}-${matchState.aMatch.location}-${matchState.aMatch.description}.pdf');
                        print(file.path);
                        await file.writeAsBytes(await pdf.save());

                        // Open the PDF file with the default PDF viewer
                        OpenFile.open(file.path);
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
                              color: Colors.black12,
                              width: 2000,
                              height: 9000,
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
                                        '${matchState.aMatch.player1.surname} - ${matchState.aMatch.player2.surname}:\t${homeScoore}',
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
                                        '${matchState.aMatch.player3.surname} - ${matchState.aMatch.player4.surname}:\t${awayScoore}',
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
                                          style: TextStyle(
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
                                                          alignment:
                                                              Alignment.center,
                                                          child: FittedBox(
                                                              child: Text(
                                                            matchState
                                                                .aMatch
                                                                .player1
                                                                .surname,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          )))),
                                                  Positioned(
                                                      top: 50,
                                                      left: 20,
                                                      child: Container(
                                                          width: 100,
                                                          height: 30,
                                                          alignment:
                                                              Alignment.center,
                                                          child: FittedBox(
                                                              child: Text(
                                                            matchState
                                                                .aMatch
                                                                .player2
                                                                .surname,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          )))),
                                                  Positioned(
                                                      top: 20,
                                                      right: 20,
                                                      child: Container(
                                                          width: 100,
                                                          height: 30,
                                                          alignment:
                                                              Alignment.center,
                                                          child: FittedBox(
                                                              child: Text(
                                                            matchState
                                                                .aMatch
                                                                .player3
                                                                .surname,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          )))),
                                                  Positioned(
                                                      top: 50,
                                                      right: 20,
                                                      child: Container(
                                                          width: 100,
                                                          height: 30,
                                                          alignment:
                                                              Alignment.center,
                                                          child: FittedBox(
                                                              child: Text(
                                                            matchState
                                                                .aMatch
                                                                .player4
                                                                .surname,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          )))),
                                                  Center(
                                                      child: Container(
                                                    alignment: Alignment.center,
                                                    width: 50,
                                                    child: Text(
                                                      'vs',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    height: 30,
                                                  ))
                                                ],
                                              ),
                                            )),
                                          ]),
                                          TableRow(children: [
                                            myCell('0', '0', lang.attack)
                                          ]),
                                          TableRow(children: [
                                            myCell('0', '0', lang.wall)
                                          ]),
                                          TableRow(children: [
                                            myCell('0', '0', lang.beat)
                                          ]),
                                          TableRow(children: [
                                            myCell('0', '0',
                                                '${lang.errors} ${lang.opponent}')
                                          ]),
                                          TableRow(children: [
                                            myCell('0', '0', lang.total)
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 110,
                                    child: Container(
                                      width: 500,
                                      color: Colors.blueAccent,
                                      height: 200,
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
                                    top: 950+200,
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
                                    top: 950+200,
                                    child: SizedBox(
                                      width: 300,
                                      height: 150,
                                      child: VolleyballField(
                                        isShowStatics: true,
                                      ),
                                    ),
                                  ),
                                 
                                ],
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

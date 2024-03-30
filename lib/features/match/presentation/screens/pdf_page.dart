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
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/start_match.dart';
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
                      } else {
                        awayScoore++;

                        int somma = homeScoore + awayScoore;
                        if (somma % 6 == 0) {
                          print("$homeScoore | $awayScoore");
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
                print("lenght = ${partialScooreSet1.length}");
                print("lenght = ${partialScooreSet2.length}");
                print("lenght = ${partialScooreSet3.length}");
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
                  print(file.path);
                  await file.writeAsBytes(await pdf.save());

                  return file.path;
                }

                return WillPopScope(
                  onWillPop: () async {
                    print("WillPopScope");
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
                                height: 1400,
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
                                              myCell('er', 'er', lang.attack)
                                            ]),
                                            TableRow(children: [
                                              myCell('er', 'er', lang.wall)
                                            ]),
                                            TableRow(children: [
                                              myCell('er', 'er', lang.beat)
                                            ]),
                                            TableRow(children: [
                                              myCell('er', 'er',
                                                  '${lang.errors} ${lang.opponent}')
                                            ]),
                                            TableRow(children: [
                                              myCell('er', 'er', lang.total)
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
                                        child: (partialScooreSet1.isEmpty)
                                            ? Container() // Display an empty Container or any other widget when partialScoore is empty.
                                            : Table(
                                                columnWidths: {
                                                  0: FlexColumnWidth(0.2),
                                                  2: FlexColumnWidth(0.2),
                                                },
                                                border: TableBorder.all(
                                                    color: Colors.black,
                                                    width: 2),
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
                                                      child: Text(
                                                          lang.partialscore,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    )),
                                                    TableCell(
                                                        child: Center(
                                                      child: Text(
                                                          lang.finalpoints,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
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

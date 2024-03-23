import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:path_provider/path_provider.dart';
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
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      title: InkWell(
                          onTap: () async {
                            final pdf = pw.Document();

                            final image = pw.MemoryImage(
                              (await screenshotController.capture())!
                                  .buffer
                                  .asUint8List(),
                            );

                            pdf.addPage(pw.Page(
                              build: (pw.Context context) => pw.Center(
                                child: pw.Image(image),
                              ),
                            ));

                            final output = await getTemporaryDirectory();
                            final file = File('${output.path}/example.pdf');
                            await file.writeAsBytes(await pdf.save());

                            Printing.sharePdf(
                                bytes: await pdf.save(),
                                filename: 'example.pdf');
                          },
                          child: Text('Generate PDF'))),
                  body: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(100),
                    child: Screenshot(
                      controller: screenshotController,
                      child: Center(
                          child: Container(
                        color: Colors.black12,
                        width: size.width,
                        height: size.height,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                height: size.height * .03,
                                width: size.width * 0.1,
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                    child: Text(
                                  lang!.tournamentTitle +
                                      ' : ' +
                                      '${matchState.aMatch.description}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )),
                              ),
                            ),
                            Positioned(
                              top: size.height * 0.03,
                              left: 0,
                              child: Container(
                                height: size.height * .03,
                                width: size.width * 0.1,
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                    child: Text(
                                  lang!.date +
                                      ' : ' +
                                      '${matchState.aMatch.date}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )),
                              ),
                            ),
                            Positioned(
                              top: size.height * 0.09,
                              left: 0,
                              child: Container(
                                height: size.height * .03,
                                width: size.width * 0.1,
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                    child: Text(
                                  matchState.aMatch.player1.surname +
                                    
                                      ' - ' +
                                      matchState.aMatch.player2.surname +
                                      '\t${homeScoore}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )),
                              ),
                            ),
                            Positioned(
                              top: size.height * 0.12,
                              left: 0,
                              child: Container(
                                height: size.height * .03,
                                width: size.width * 0.1,
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                    child: Text(
                                  matchState.aMatch.player3.surname +
                                    
                                      ' - ' +
                                      matchState.aMatch.player4.surname +
                                      '\t${awayScoore}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                );
              } else {
                return Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(lang!.beat),
                  ),
                );
              }
            },
          );
        } else {
          return Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(lang!.noMatches),
            ),
          );
        }
      },
    );
  }
}

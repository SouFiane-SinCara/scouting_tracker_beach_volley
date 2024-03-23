// ignore_for_file: unnecessary_type_check, use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/my_field.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/login_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/repository/repository_imp.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/pdf_api.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/pdf_page.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_type_cubit/attack_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/invert_cubit/invert_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/rouand_cubit/rouand_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/scoore_cubit/scoore_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/show_player_on_field_cubit/show_player_on_field_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/team_cubit/team_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/confirmation_dialog.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/player_on_field.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/rouand_card.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/surname_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';

class StartMatch extends StatelessWidget {
  Account account;
  int? directionWind;
  bool? fromChoosePage;
  StartMatch(
      {Key? key,
      this.fromChoosePage,
      required this.account,
      this.directionWind})
      : super(key: key);

  showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: themeDevice(context).colorScheme.secondary,
        content: Align(
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              message,
              style: TextStyle(
                  color: themeDevice(context).primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )));
  }

  Future<void> addPoint(
      BuildContext context, bool isBlueTeam, bool isManual) async {
    RepositoryMatchImp? repositoryMatchImp = RepositoryMatchImp();
    print("is manual $isManual");

    isManual == true
        ? await repositoryMatchImp.addBeat(
            beatAction: BeatAction(
                breackpointNum: -1,
                currentSet: 1,
                playerNumber: 2,
                deletable: true,
                playerTeam: 1,
                state: '',
                method: "manual",
                player: Player(
                    name: 'name',
                    surname: 'surname',
                    image: 'image',
                    gender: 'm',
                    strongHand: 'l',
                    tournamentTitle: 'tournamentTitle',
                    dateLocation: 'dateLocation',
                    team: '1',
                    player: '1',
                    account: account,
                    note: 'note'),
                continued: false,
                p2: Offset.zero,
                attackOption: '',
                playersurname: '',
                p1: Offset.zero,
                type: 'type'))
        : null;

    BlocProvider.of<ScooreCubit>(context).getSccore(
      rouandSet: currentSet,
      awayset1: awaySet1,
      awayset2: awaySet2,
      awayset3: awaySet3,
      homeset1: homeSet1,
      homeset2: homeSet2,
      currentSet: currentSet,
      homeset3: homeSet3,
      homeScoore: currentSet == 1
          ? homeSet1
          : currentSet == 2
              ? homeSet2
              : homeSet3,
      awayScoore: currentSet == 1
          ? awaySet1
          : currentSet == 2
              ? awaySet2
              : awaySet3,
      home: isBlueTeam,
    );

    if (isBlueTeam) {
      home++;
      currentSet == 1 ? homeSet1++ : null;
      currentSet == 2 ? homeSet2++ : null;
      currentSet == 3 ? homeSet3++ : null;
    } else {
      away++;
      currentSet == 1 ? awaySet1++ : null;
      currentSet == 2 ? awaySet2++ : null;
      currentSet == 3 ? awaySet3++ : null;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? lastPoints = sharedPreferences.getStringList('lastPoint');
    lastPoints == null
        ? lastPoints = [isBlueTeam ? 'home' : 'away']
        : lastPoints.add(isBlueTeam ? 'home' : 'away');
    sharedPreferences.setStringList('lastPoint', lastPoints);
  }

  int away = 0;

  int home = 0;

  int homeSet1 = 0;

  int homeSet2 = 0;

  int homeSet3 = 0;

  int awaySet1 = 0;

  int awaySet2 = 0;

  int awaySet3 = 0;

  int currentSet = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    print("build :");
    // want to do this function when i don't came to this page from the choose page
    if (fromChoosePage == false) {
      print("build : fromChoosePage is null");
      BlocProvider.of<LastMatchCubit>(context).getLastMatch(account: account);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: BlocBuilder<LastMatchCubit, LastMatchState>(
        builder: (context, state) {
          if (state is StartedMatchState) {
            state.aMatch.rouands!.forEach((element) {
              away += element.away;
              home += element.home;
            });
            homeSet1 = state.aMatch.rouands![0].home;
            homeSet2 = state.aMatch.rouands![1].home;
            homeSet3 = state.aMatch.rouands![2].home;
            awaySet1 = state.aMatch.rouands![0].away;
            awaySet2 = state.aMatch.rouands![1].away;
            awaySet3 = state.aMatch.rouands![2].away;
            state.aMatch.rouands!.forEach((element) =>
                element.state == true ? currentSet = element.roundSet : null);
            currentSet = state.aMatch.rouands!
                .where((element) => element.state == true)
                .first
                .roundSet;
            BlocProvider.of<ScooreCubit>(context).getSccore(
                awayset1: awaySet1,
                awayset2: awaySet2,
                awayset3: awaySet3,
                homeset1: homeSet1,
                homeset2: homeSet2,
                homeset3: homeSet3,
                currentSet: currentSet,
                rouandSet: currentSet,
                homeScoore: home,
                awayScoore: away,
                home: null);
            BlocProvider.of<RouandCubit>(context).nextRouand(currentSet);

            return BlocBuilder<RouandCubit, RouandState>(
              builder: (context, rouandnum) {
                if (rouandnum is NextRouandState) {
                  return Column(
                    children: [
                      AppBar(
                        backgroundColor: theme.colorScheme.primary,
                        elevation: 0,
                        leading: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              showSnackBar(lang!.longpressdeletematch, context);
                            },
                            onLongPress: () async {
                              showDialogConfirmation(
                                  context: context,
                                  fun: () async {
                                    RemoteDataSourceGetLastMatchFB
                                        remoteDataSourceGetLastMatchFB =
                                        RemoteDataSourceGetLastMatchFB();
                                    remoteDataSourceGetLastMatchFB
                                        .deleteMAtch();

                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();

                                    await sharedPreferences.remove('match');
                                    await sharedPreferences.remove('lastPoint');
                                    Navigator.pop(context);

                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            choosePageName,
                                            arguments: account,
                                            (Route<dynamic> route) => false);
                                  },
                                  dialogmessage:
                                      lang!.dialoglongpressdeletematch);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        title: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {},
                          child: Text(
                            state.aMatch.description,
                            style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        centerTitle: true,
                      ),
                      Expanded(
                        child: BlocBuilder<ScooreCubit, ScooreState>(
                          builder: (context, sccore) {
                            if (sccore is NewSccoreState) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: size.width * 0.4,
                                      height: size.height * 0.04,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: theme.colorScheme.secondary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: FittedBox(
                                          child: Text(
                                        rouandnum.rouandNum.toString() + ' set',
                                        style: TextStyle(
                                            color: theme.primaryColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            SurnamePic(
                                                redteam: false,
                                                surname: state
                                                    .aMatch.player1.surname,
                                                image:
                                                    state.aMatch.player1.image),
                                            SizedBox(
                                              height: size.height * 0.05,
                                            ),
                                            SurnamePic(
                                                redteam: false,
                                                surname: state
                                                    .aMatch.player2.surname,
                                                image:
                                                    state.aMatch.player2.image),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                showSnackBar(
                                                    lang!.longpressaddpoind,
                                                    context);
                                              },
                                              onLongPress: () {
                                                showDialogConfirmation(
                                                  context: context,
                                                  fun: () async {
                                                    addPoint(
                                                        context, true, true);
                                                    Navigator.pop(context);
                                                  },
                                                  dialogmessage: lang!
                                                      .dialoglongpressaddpoind,
                                                );
                                              },
                                              child: Container(
                                                  width: size.width * 0.09,
                                                  decoration: BoxDecoration(
                                                    color: theme.brightness ==
                                                            Brightness.dark
                                                        ? Colors.blue[400]
                                                        : Colors.blue[900],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  height: size.height * 0.05,
                                                  alignment: Alignment.center,
                                                  child: FittedBox(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: size.height * 0.3,
                                          width: size.width * 0.32,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: size.width * 0.3,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            theme.primaryColor,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                height: size.height * 0.07,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: size.width * 0.1,
                                                      height: size.height * 0.1,
                                                      alignment:
                                                          Alignment.center,
                                                      child: FittedBox(
                                                        child: Text(
                                                          '${sccore.homeSet1 + sccore.homeSet2 + sccore.homeSet3} ',
                                                          style: TextStyle(
                                                              color: theme.brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors
                                                                      .blue[400]
                                                                  : Colors.blue[
                                                                      900],
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: AutoSizeText(
                                                        "vs",
                                                        style: TextStyle(
                                                            color: theme
                                                                .primaryColor,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: size.width * 0.1,
                                                      height: size.height * 0.1,
                                                      alignment:
                                                          Alignment.center,
                                                      child: FittedBox(
                                                        child: Text(
                                                          '${sccore.awaySet1 + sccore.awaySet2 + sccore.awaySet3}',
                                                          style: TextStyle(
                                                              color: theme.brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors
                                                                      .red[400]
                                                                  : Colors
                                                                      .red[900],
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.05,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: size.height * 0.05,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SurnamePic(
                                                redteam: true,
                                                surname: state
                                                    .aMatch.player4.surname,
                                                image:
                                                    state.aMatch.player4.image),
                                            SizedBox(
                                              height: size.height * 0.05,
                                            ),
                                            SurnamePic(
                                                redteam: true,
                                                surname: state
                                                    .aMatch.player3.surname,
                                                image:
                                                    state.aMatch.player3.image),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                showSnackBar(
                                                    lang!.longpressaddpoind,
                                                    context);
                                              },
                                              onLongPress: () {
                                                showDialogConfirmation(
                                                  context: context,
                                                  fun: () async {
                                                    addPoint(
                                                        context, false, true);
                                                    Navigator.pop(context);
                                                  },
                                                  dialogmessage: lang!
                                                      .dialoglongpressaddpoind,
                                                );
                                              },
                                              child: Container(
                                                  width: size.width * 0.09,
                                                  decoration: BoxDecoration(
                                                    color: theme.brightness ==
                                                            Brightness.dark
                                                        ? Colors.red[400]
                                                        : Colors.red[900],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  height: size.height * 0.05,
                                                  alignment: Alignment.center,
                                                  child: FittedBox(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.00,
                                    ),
                                    RouandCard(
                                      state: currentSet == 1,
                                      away: sccore.awaySet1,
                                      home: sccore.homeSet1,
                                      rouand: 1,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    RouandCard(
                                      state: currentSet == 2,
                                      away: sccore.awaySet2,
                                      home: sccore.homeSet2,
                                      rouand: 2,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    RouandCard(
                                      state: currentSet == 3,
                                      away: sccore.awaySet3,
                                      home: sccore.homeSet3,
                                      rouand: 3,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.04,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            showSnackBar(
                                                lang!.longpressnextrouand,
                                                context);
                                          },
                                          onLongPress: () async {
                                            if (currentSet < 3) {
                                              showDialogConfirmation(
                                                  context: context,
                                                  fun: () async {
                                                    RemoteDataSourceGetLastMatchFB()
                                                        .nextSet(
                                                            rouand: currentSet);
                                                    currentSet++;

                                                    BlocProvider.of<
                                                                RouandCubit>(
                                                            context)
                                                        .nextRouand(currentSet);
                                                    SharedPreferences
                                                        sharedPreferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    sharedPreferences
                                                        .remove("lastPoint");

                                                    Navigator.pop(context);
                                                  },
                                                  dialogmessage: lang!
                                                      .dialoglongpressnextrouand);
                                            } else {
                                              showSnackBar(
                                                  lang!.noSet, context);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: theme.shadowColor,
                                                  blurRadius: 5,
                                                )
                                              ],
                                              color:
                                                  theme.colorScheme.secondary,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            width: size.width * 0.25,
                                            height: size.height * 0.06,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.02),
                                            child: FittedBox(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "fine set",
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.05,
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            showSnackBar(
                                                lang.longpressfinematch,
                                                context);
                                          },
                                          onLongPress: () async {
                                            showDialogConfirmation(
                                                context: context,
                                                fun: () async {
                                                  RemoteDataSourceGetLastMatchFB
                                                      remoteDataSourceGetLastMatchFB =
                                                      RemoteDataSourceGetLastMatchFB();
                                                  remoteDataSourceGetLastMatchFB
                                                      .fineMatch();
                                                  SharedPreferences
                                                      sharedPreferences =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  await sharedPreferences
                                                      .remove('match');
                                                  await sharedPreferences
                                                      .remove('lastPoint');
                                                  Navigator.pop(context);

                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          choosePageName,
                                                          arguments: account,
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                dialogmessage: lang
                                                    .dialoglongpressfinematch);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: theme.shadowColor,
                                                  blurRadius: 5,
                                                )
                                              ],
                                              color:
                                                  theme.colorScheme.secondary,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            width: size.width * 0.25,
                                            height: size.height * 0.06,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.02),
                                            child: FittedBox(
                                              alignment: Alignment.center,
                                              child: Text(
                                                lang!.fineMatch,
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.05,
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onLongPress: () async {
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            List<String>? lastPoints =
                                                sharedPreferences
                                                    .getStringList('lastPoint');
                                            if (lastPoints == null ||
                                                lastPoints.isEmpty) {
                                              showSnackBar(
                                                  lang.noPointtoDel, context);
                                            } else {
                                              showDialogConfirmation(
                                                  context: context,
                                                  fun: () async {
                                                    BlocProvider.of<
                                                                ScooreCubit>(
                                                            context)
                                                        .getSccore(
                                                            awayset1: awaySet1,
                                                            awayset2: awaySet2,
                                                            awayset3: awaySet3,
                                                            homeset1: homeSet1,
                                                            homeset2: homeSet2,
                                                            homeset3: homeSet3,
                                                            currentSet:
                                                                currentSet,
                                                            rouandSet:
                                                                currentSet,
                                                            homeScoore: currentSet ==
                                                                    1
                                                                ? homeSet1
                                                                : currentSet ==
                                                                        2
                                                                    ? homeSet2
                                                                    : homeSet3,
                                                            awayScoore: currentSet ==
                                                                    1
                                                                ? awaySet1
                                                                : currentSet ==
                                                                        2
                                                                    ? awaySet2
                                                                    : awaySet3,
                                                            isDelete: true,
                                                            home: lastPoints
                                                                        .last !=
                                                                    'home'
                                                                ? false
                                                                : true);
                                                    Navigator.pop(context);
                                                    lastPoints.last == "away"
                                                        ? away--
                                                        : home--;
                                                    if (lastPoints.last ==
                                                        'away') {
                                                      currentSet == 1
                                                          ? awaySet1--
                                                          : null;
                                                      currentSet == 2
                                                          ? awaySet2--
                                                          : null;
                                                      currentSet == 3
                                                          ? awaySet3--
                                                          : null;
                                                    } else {
                                                      currentSet == 1
                                                          ? homeSet1--
                                                          : null;
                                                      currentSet == 2
                                                          ? homeSet2--
                                                          : null;
                                                      currentSet == 3
                                                          ? homeSet3--
                                                          : null;
                                                    }
                                                    if (lastPoints.length <=
                                                        1) {
                                                      sharedPreferences
                                                          .remove('lastPoint');

                                                      lastPoints.clear();
                                                    } else {
                                                      lastPoints.removeLast();
                                                    }
                                                    sharedPreferences
                                                        .setStringList(
                                                            'lastPoint',
                                                            lastPoints);
                                                    RemoteDataSourceGetLastMatch
                                                        remoteDataSourceGetLastMatch =
                                                        RemoteDataSourceGetLastMatchFB();
                                                    await remoteDataSourceGetLastMatch
                                                        .removeLastPointFromStatics();
                                                  },
                                                  dialogmessage: lang
                                                      .dialoglongpressdeletelastpoint);
                                              sharedPreferences.setStringList(
                                                  'lastPoint', lastPoints);
                                            }
                                          },
                                          onTap: () {
                                            showSnackBar(
                                                lang.longpressdeletelastpoint,
                                                context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: theme.shadowColor,
                                                  blurRadius: 5,
                                                )
                                              ],
                                              color:
                                                  theme.colorScheme.secondary,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            width: size.width * 0.25,
                                            height: size.height * 0.06,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.02),
                                            alignment: Alignment.center,
                                            child: FittedBox(
                                              alignment: Alignment.center,
                                              child: Text(
                                                lang.dellastPoint,
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        final data = await Navigator.pushNamed(
                                            context, windDirectionPageName);
                                        directionWind = data as int?;
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: size.width * 0.18,
                                        height: size.height * 0.08,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                              color: theme.primaryColor),
                                        ),
                                        child: BlocBuilder<DirectionCubit,
                                            DirectionState>(
                                          builder: (context, wind) {
                                            if (wind is NewDirectionState) {
                                              state.aMatch.wind =
                                                  wind.direction;
                                              return SvgPicture.asset(
                                                'lib/core/assets/icons/wind_direction_icons/${wind.direction}.svg',
                                                color: theme.primaryColor,
                                              );
                                            } else {
                                              return SvgPicture.asset(
                                                'lib/core/assets/icons/wind_direction_icons/${state.aMatch.wind}.svg',
                                                color: theme.primaryColor,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Navigator.pushNamed(
                                                context, matchStoryPageName,
                                                arguments: account);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.secondary,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            alignment: Alignment.center,
                                            height: size.height * 0.05,
                                            width: size.width * 0.3,
                                            child: FittedBox(
                                                child: Text(
                                              lang.matchstory,
                                              style: TextStyle(
                                                  color: theme.primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            // File file = await PdfApi
                                            //     .generateMatchStatic(
                                            //         state.aMatch);
                                            // OpenFile.open(file.path);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfStatistics(),
                                                ));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.secondary,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            alignment: Alignment.center,
                                            height: size.height * 0.05,
                                            width: size.width * 0.3,
                                            child: FittedBox(
                                                child: Text(
                                              " ",
                                              style: TextStyle(
                                                  color: theme.primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            AMatch aMatch = state.aMatch;

                                            await BlocProvider.of<
                                                    GetBeatsCubit>(context)
                                                .getBeats(aMatch: aMatch);

                                            Navigator.pushNamed(
                                                context, staticMatchPageName,
                                                arguments: account);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.secondary,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            alignment: Alignment.center,
                                            height: size.height * 0.05,
                                            width: size.width * 0.3,
                                            child: FittedBox(
                                                child: Text(
                                              lang.matchstatic,
                                              style: TextStyle(
                                                  color: theme.primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    BlocBuilder<InvertCubit, InvertState>(
                                      builder: (context, invertstate) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                BlocProvider.of<InvertCubit>(
                                                                context)
                                                            .inverted ==
                                                        false
                                                    ? BlocProvider.of<
                                                                InvertCubit>(
                                                            context)
                                                        .invertBlueTeam()
                                                    : BlocProvider.of<
                                                                InvertCubit>(
                                                            context)
                                                        .invertRedTeam();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: theme.shadowColor,
                                                      blurRadius: 5,
                                                    )
                                                  ],
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  shape: BoxShape.circle,
                                                ),
                                                width: size.width * 0.25,
                                                height: size.height * 0.06,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.02),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FittedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                            Icons.arrow_upward,
                                                            color: invertstate
                                                                    is InvertNewState
                                                                ? invertstate
                                                                            .inverted ==
                                                                        true
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue
                                                                : Colors.blue)),
                                                    FittedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                            Icons
                                                                .arrow_downward,
                                                            color: invertstate
                                                                    is InvertNewState
                                                                ? invertstate
                                                                            .inverted ==
                                                                        true
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue
                                                                : Colors.blue)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                BlocProvider.of<InvertCubit>(
                                                        context)
                                                    .invertMatch();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: theme.shadowColor,
                                                      blurRadius: 5,
                                                    )
                                                  ],
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                width: size.width * 0.25,
                                                height: size.height * 0.06,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.02),
                                                alignment: Alignment.center,
                                                child: FittedBox(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    lang!.fieldchange,
                                                    style: TextStyle(
                                                        color:
                                                            theme.primaryColor,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                BlocProvider.of<InvertCubit>(
                                                                context)
                                                            .inverted ==
                                                        false
                                                    ? BlocProvider.of<
                                                                InvertCubit>(
                                                            context)
                                                        .invertRedTeam()
                                                    : BlocProvider.of<
                                                                InvertCubit>(
                                                            context)
                                                        .invertBlueTeam();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: theme.shadowColor,
                                                      blurRadius: 5,
                                                    )
                                                  ],
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  shape: BoxShape.circle,
                                                ),
                                                width: size.width * 0.25,
                                                height: size.height * 0.06,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.02),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FittedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                            Icons.arrow_upward,
                                                            color: invertstate
                                                                    is InvertNewState
                                                                ? invertstate
                                                                            .inverted ==
                                                                        false
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue
                                                                : Colors.red)),
                                                    FittedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                            Icons
                                                                .arrow_downward,
                                                            color: invertstate
                                                                    is InvertNewState
                                                                ? invertstate
                                                                            .inverted ==
                                                                        false
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue
                                                                : Colors.red)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    BlocBuilder<InvertCubit, InvertState>(
                                      builder: (context, invert) {
                                        bool inverted = invert is InvertNewState
                                            ? invert.inverted
                                            : false;
                                        bool blueInverted =
                                            invert is InvertNewState
                                                ? invert.blueInverted
                                                : false;
                                        bool redInverted =
                                            invert is InvertNewState
                                                ? invert.redInverted
                                                : false;

                                        return Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.1),
                                              child: AspectRatio(
                                                aspectRatio: 16 / 8,
                                                child: VolleyballField(
                                                  isShowStatics: true,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                top: redInverted == false
                                                    ? size.width * 0.05
                                                    : null,
                                                bottom: redInverted == true
                                                    ? size.width * 0.05
                                                    : null,
                                                right: inverted == false
                                                    ? size.width * 0.2
                                                    : null,
                                                left: inverted == true
                                                    ? size.width * 0.2
                                                    : null,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .changeTeam(1);
                                                    Map? data;
                                                    BlocProvider.of<
                                                                GetBeatsCubit>(
                                                            context)
                                                        .beats
                                                        .clear();
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .team = 2;
                                                    BlocProvider.of<
                                                                ShowPlayerOnFieldCubit>(
                                                            context)
                                                        .showPlayer(
                                                            firstPlayer: true,
                                                            redTeam: true);
                                                    BlocProvider.of<
                                                                ShowPlayerOnFieldCubit>(
                                                            context)
                                                        .showPlayer(
                                                            firstPlayer: true,
                                                            redTeam: true);
                                                    state is StartedMatchState
                                                        ? data = await Navigator
                                                            .pushNamed(context,
                                                                beatPageName,
                                                                arguments: {
                                                                'player': 1,
                                                                "team": 2,
                                                                "match": state
                                                                    .aMatch,
                                                                "currentSet":
                                                                    currentSet
                                                              }) as Map?
                                                        : null;
                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .breackpointNum = -1;
                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .newAttack(
                                                            ReceptionState(
                                                                player: 1,
                                                                team: 1));
                                                    if (data != null) {
                                                      if (data['team'] == 2) {
                                                        addPoint(context, false,
                                                            false);
                                                      } else {
                                                        addPoint(context, true,
                                                            false);
                                                      }
                                                    }
                                                  },
                                                  child: PlayerOnField(
                                                    isBlueTeam: false,
                                                    inverse: inverted == true
                                                        ? true
                                                        : null,
                                                    playerName: state.aMatch
                                                            .player3.name[0] +
                                                        "." +
                                                        state.aMatch.player3
                                                            .surname,
                                                  ),
                                                )),
                                            Positioned(
                                                bottom: redInverted == false
                                                    ? size.width * 0.05
                                                    : null,
                                                top: redInverted == true
                                                    ? size.width * 0.05
                                                    : null,
                                                right: inverted == false
                                                    ? size.width * 0.2
                                                    : null,
                                                left: inverted == true
                                                    ? size.width * 0.2
                                                    : null,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .changeTeam(1);
                                                    Map? data;
                                                    BlocProvider.of<
                                                                GetBeatsCubit>(
                                                            context)
                                                        .beats
                                                        .clear();
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .team = 2;
                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .breackpointNum = -1;
                                                    BlocProvider.of<
                                                                ShowPlayerOnFieldCubit>(
                                                            context)
                                                        .showPlayer(
                                                            firstPlayer: false,
                                                            redTeam: true);
                                                    data = await Navigator
                                                        .pushNamed(context,
                                                            beatPageName,
                                                            arguments: {
                                                          'player': 2,
                                                          "team": 2,
                                                          "match": state.aMatch,
                                                          "currentSet":
                                                              currentSet
                                                        }) as Map?;

                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .breackpointNum = -1;
                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .newAttack(
                                                            ReceptionState(
                                                                player: 1,
                                                                team: 1));
                                                    if (data != null) {
                                                      if (data['team'] == 2) {
                                                        addPoint(context, false,
                                                            false);
                                                      } else {
                                                        addPoint(context, true,
                                                            false);
                                                      }
                                                    }
                                                  },
                                                  child: PlayerOnField(
                                                    isBlueTeam: false,
                                                    inverse: inverted == true
                                                        ? true
                                                        : null,
                                                    playerName: state.aMatch
                                                            .player4.name[0] +
                                                        "." +
                                                        state.aMatch.player4
                                                            .surname,
                                                  ),
                                                )),
                                            Positioned(
                                                bottom: blueInverted == false
                                                    ? size.width * 0.05
                                                    : null,
                                                top: blueInverted == true
                                                    ? size.width * 0.05
                                                    : null,
                                                left: inverted == false
                                                    ? size.width * 0.2
                                                    : null,
                                                right: inverted == true
                                                    ? size.width * 0.2
                                                    : null,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .changeTeam(1);
                                                    Map? data;
                                                    BlocProvider.of<
                                                                GetBeatsCubit>(
                                                            context)
                                                        .beats
                                                        .clear();
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .team = 1;
                                                    BlocProvider.of<
                                                                ShowPlayerOnFieldCubit>(
                                                            context)
                                                        .showPlayer(
                                                            firstPlayer: false,
                                                            redTeam: false);
                                                    state is StartedMatchState
                                                        ? data = await Navigator
                                                            .pushNamed(context,
                                                                beatPageName,
                                                                arguments: {
                                                                'player': 2,
                                                                "team": 1,
                                                                "match": state
                                                                    .aMatch,
                                                                "currentSet":
                                                                    currentSet
                                                              }) as Map?
                                                        : null;
                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .breackpointNum = -1;
                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .newAttack(
                                                            ReceptionState(
                                                                player: 1,
                                                                team: 1));
                                                    if (data != null) {
                                                      if (data['team'] == 2) {
                                                        addPoint(context, false,
                                                            false);
                                                      } else {
                                                        addPoint(context, true,
                                                            false);
                                                      }
                                                    }
                                                  },
                                                  child: PlayerOnField(
                                                    isBlueTeam: true,
                                                    inverse: inverted == true
                                                        ? null
                                                        : true,
                                                    playerName: state.aMatch
                                                            .player2.name[0] +
                                                        "." +
                                                        state.aMatch.player2
                                                            .surname,
                                                  ),
                                                )),
                                            Positioned(
                                                top: blueInverted == false
                                                    ? size.width * 0.05
                                                    : null,
                                                bottom: blueInverted == true
                                                    ? size.width * 0.05
                                                    : null,
                                                left: inverted == false
                                                    ? size.width * 0.2
                                                    : null,
                                                right: inverted == true
                                                    ? size.width * 0.2
                                                    : null,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .changeTeam(1);
                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .breackpointNum = -1;
                                                    Map? data;
                                                    BlocProvider.of<
                                                                GetBeatsCubit>(
                                                            context)
                                                        .beats
                                                        .clear();
                                                    BlocProvider.of<TeamCubit>(
                                                            context)
                                                        .team = 1;
                                                    BlocProvider.of<
                                                                ShowPlayerOnFieldCubit>(
                                                            context)
                                                        .showPlayer(
                                                            firstPlayer: true,
                                                            redTeam: false);
                                                    state is StartedMatchState
                                                        ? data = await Navigator
                                                            .pushNamed(context,
                                                                beatPageName,
                                                                arguments: {
                                                                'player': 1,
                                                                "team": 1,
                                                                "match": state
                                                                    .aMatch,
                                                                "currentSet":
                                                                    currentSet
                                                              }) as Map?
                                                        : null;

                                                    BlocProvider.of<
                                                                AttackTypeCubit>(
                                                            context)
                                                        .newAttack(
                                                            ReceptionState(
                                                                player: 1,
                                                                team: 1));
                                                    if (data != null) {
                                                      if (data['team'] == 2) {
                                                        addPoint(context, false,
                                                            false);
                                                      } else {
                                                        addPoint(context, true,
                                                            false);
                                                      }
                                                    }
                                                  },
                                                  child: PlayerOnField(
                                                    inverse: inverted == true
                                                        ? null
                                                        : true,
                                                    isBlueTeam: true,
                                                    playerName: state.aMatch
                                                            .player1.name[0] +
                                                        "." +
                                                        state.aMatch.player1
                                                            .surname,
                                                  ),
                                                )),
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.1,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: theme.primaryColor,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                }
              },
            );
          } else if (state is ErrorLoginState) {
            return Container(
              width: size.width,
              height: size.height,
              color: theme.colorScheme.primary,
              child: Center(child: Text(lang!.serverFailure)),
            );
          } else {
            return Container(
              width: size.width,
              height: size.height,
              color: theme.colorScheme.primary,
              child: Center(
                  child: CircularProgressIndicator(
                color: theme.primaryColor,
              )),
            );
          }
        },
      ),
    );
  }
}

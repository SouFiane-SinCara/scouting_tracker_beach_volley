import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/match_cubit/match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/add_player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/my_field.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/player_card.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/rouand.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewMatchPage extends StatefulWidget {
 final Map data;

  NewMatchPage({
    required this.data,
  });

  @override
  State<NewMatchPage> createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> {
  TextEditingController locationController = TextEditingController();
  bool tournamentSelected = true;
  Player? player1;
  Player? player2;
  Player? player3;
  Player? player4;
  ScrollController _scrollController = ScrollController();
  TextEditingController descriptionController = TextEditingController();
  DateTime dateATime = DateTime.now();
  String? error;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);

    AppLocalizations? lang = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(lang!.newMatch),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme.primaryColor,
            )),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              error == null
                  ? tournamentSelected == false
                      ? AutoSizeText(
                          lang.noTournamentSelected,
                          style: TextStyle(
                              color: Colors.red[300],
                              fontWeight: FontWeight.bold),
                        )
                      : SizedBox()
                  : AutoSizeText(
                      error!,
                      style: TextStyle(
                          color: Colors.red[300], fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: size.height * 0.01,
              ),
              InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                onTap: () async {
                  widget.data['location'] = '';
                  widget.data['date'] = '';
        
                  var data = await Navigator.pushNamed(
                      context, tournamentsPageName,
                      arguments: {
                        "account": widget.data['account'],
                        "title": widget.data['title'],
                        "location": widget.data['location'],
                        "date": widget.data['date']
                      });
                  if (data is Map) {
                    widget.data['title'] = data['title'];
                    setState(() {});
                  }
                },
                child: Container(
                  width: size.width * 0.8,
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: theme.shadowColor)
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: AutoSizeText(
                    widget.data['title'] ?? lang.selecttournament,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                onTap: () async {
                  if (widget.data['title'] == '' ||
                      widget.data['title'] == lang.selecttournament) {
                    tournamentSelected = false;
                    setState(() {});
                  } else {
                    final data = await Navigator.pushNamed(
                        context, getDateLocationPageName, arguments: {
                      "account": widget.data['account'],
                      "title": widget.data['title']
                    });
                    if (data is Map) {
                      widget.data['date'] = data['date'];
                      widget.data['location'] = data['location'];
                      setState(() {});
                    }
                  }
                },
                child: Container(
                  width: size.width * 0.8,
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: theme.shadowColor)
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: AutoSizeText(
                    widget.data['location'] == '' ||
                            widget.data['location'] == null ||
                            widget.data['date'] == ''
                        ? lang.selectdateandLocation
                        : "${widget.data['location']}  |  ${widget.data['date']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Myfield(
                controller: descriptionController,
                textInputAction: TextInputAction.done,
                enable: true,
                icon: Icon(
                  Icons.description,
                  color: theme.primaryColor,
                ),
                text: lang.matchDetails,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                height: size.height * 0.55,
                width: size.width * 0.9,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.006),
                child: Stack(
                  children: [
                    player1 == null
                        ? Positioned(
                            top: 0,
                            left: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                              onTap: () async {
                                final data = await Navigator.pushNamed(
                                    context, allPlayersLVPageName,
                                    arguments: Player(
                                        name: '',
                                        surname: '',
                                        image: '',
                                        gender: '',
                                        strongHand: '',
                                        tournamentTitle: '',
                                        dateLocation: '',
                                        team: '1',
                                        player: '1',
                                        account: widget.data['account'],
                                        note: ''));
                                if (data is Map) {
                                  player1 = data['p11'];
                                  setState(() {});
                                }
                              },
                              child: AddPlayer(
                                  player: Player(
                                      name: '',
                                      surname: '',
                                      image: '',
                                      gender: '',
                                      strongHand: '',
                                      tournamentTitle: '',
                                      dateLocation: '',
                                      team: '1',
                                      player: '1',
                                      account: widget.data['account'],
                                      note: '')),
                            ))
                        : Positioned(
                            top: 0,
                            left: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                onTap: () async {
                                  final data = await Navigator.pushNamed(
                                      context, allPlayersLVPageName,
                                      arguments: player1);
                                  if (data is Map) {
                                    player1 = data['p11'];
        
                                    setState(() {});
                                  }
                                },
                                child: Playercard(player: player1!))),
                    player2 == null
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                              onTap: () async {
                                final data = await Navigator.pushNamed(
                                    context, allPlayersLVPageName,
                                    arguments: Player(
                                        name: '',
                                        surname: '',
                                        image: '',
                                        gender: '',
                                        strongHand: '',
                                        tournamentTitle: '',
                                        dateLocation: '',
                                        team: '1',
                                        player: '2',
                                        account: widget.data['account'],
                                        note: ''));
                                if (data is Map) {
                                  player2 = data['p21'];
                                  setState(() {});
                                }
                              },
                              child: AddPlayer(
                                  player: Player(
                                      name: '',
                                      surname: '',
                                      image: '',
                                      gender: '',
                                      strongHand: '',
                                      tournamentTitle: '',
                                      dateLocation: '',
                                      team: '1',
                                      player: '2',
                                      account: widget.data['account'],
                                      note: '')),
                            ))
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                onTap: () async {
                                  final data = await Navigator.pushNamed(
                                      context, allPlayersLVPageName,
                                      arguments: player2);
                                  if (data is Map) {
                                    player2 = data['p21'];
        
                                    setState(() {});
                                  }
                                },
                                child: Playercard(player: player2!))),
                    player3 == null
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                              onTap: () async {
                                final data = await Navigator.pushNamed(
                                    context, allPlayersLVPageName,
                                    arguments: Player(
                                        name: '',
                                        surname: '',
                                        image: '',
                                        gender: '',
                                        strongHand: '',
                                        tournamentTitle: '',
                                        dateLocation: '',
                                        team: '2',
                                        player: '1',
                                        account: widget.data['account'],
                                        note: ''));
                                if (data is Map) {
                                  player3 = data['p12'];
                                  setState(() {});
                                }
                              },
                              child: AddPlayer(
                                  player: Player(
                                      name: '',
                                      surname: '',
                                      image: '',
                                      gender: '',
                                      strongHand: '',
                                      tournamentTitle: '',
                                      dateLocation: '',
                                      team: '2',
                                      player: '1',
                                      account: widget.data['account'],
                                      note: '')),
                            ))
                        : Positioned(
                            bottom: 0,
                            left: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                onTap: () async {
                                  final data = await Navigator.pushNamed(
                                      context, allPlayersLVPageName,
                                      arguments: player3);
                                  if (data is Map) {
                                    player3 = data['p12'];
        
                                    setState(() {});
                                  }
                                },
                                child: Playercard(player: player3!))),
                    player4 == null
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                              onTap: () async {
                                final data = await Navigator.pushNamed(
                                    context, allPlayersLVPageName,
                                    arguments: Player(
                                        name: '',
                                        surname: '',
                                        image: '',
                                        gender: '',
                                        strongHand: '',
                                        tournamentTitle: '',
                                        dateLocation: '',
                                        team: '2',
                                        player: '2',
                                        account: widget.data['account'],
                                        note: ''));
                                if (data is Map) {
                                  player4 = data['p22'];
                                  setState(() {});
                                }
                              },
                              child: AddPlayer(
                                  player: Player(
                                      name: '',
                                      surname: '',
                                      image: '',
                                      gender: '',
                                      strongHand: '',
                                      tournamentTitle: '',
                                      dateLocation: '',
                                      team: '2',
                                      player: '2',
                                      account: widget.data['account'],
                                      note: '')),
                            ))
                        : Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                onTap: () async {
                                  final data = await Navigator.pushNamed(
                                      context, allPlayersLVPageName,
                                      arguments: player4);
                                  if (data is Map) {
                                    player4 = data['p22'];
        
                                    setState(() {});
                                  }
                                },
                                child: Playercard(player: player4!))),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                onTap: () async {
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 1),
                    curve: Curves.easeInOut,
                  );
                  if (widget.data['title'] == 'Select tournament') {
                    setState(() {
                      error = lang.selecttournament;
                    });
                  } else if (widget.data['date'] == null) {
                    setState(() {
                      error = lang.selectdateandLocation;
                    });
                  } else if (player1 == null ||
                      player2 == null ||
                      player3 == null ||
                      player4 == null) {
                    setState(() {
                      error = lang.selectAllPlayers;
                    });
                  } else if (descriptionController.text.isEmpty) {
                    setState(() {
                      error = lang.typeDiscription;
                    });
                  } else if (widget.data['date'] == null || widget.data['date'] =='') {
                    setState(() {
                      error = lang.selectdateandLocation;
                    });
                  } else if (player1 == player2 ||
                      player1 == player3 ||
                      player1 == player4 ||
                      player2 == player3 ||
                      player2 == player1 ||
                      player2 == player4 ||
                      player3 == player4 ||
                      player3 == player1 ||
                      player3 == player2 ||
                      player4 == player1 ||
                      player4 == player2 ||
                      player4 == player3) {
                    setState(() {
                      error = lang.playerAlreadySelected;
                    });
                  } else {
                    await BlocProvider.of<MatchCubit>(context).addMatch(
                        match: AMatch(
                            finished: false,
                            rouands: [
                              Rouand(
                                  roundSet: 1, state: true, home: 0, away: 0),
                              Rouand(
                                  roundSet: 2, state: false, home: 0, away: 0),
                              Rouand(
                                  roundSet: 3, state: false, home: 0, away: 0),
                            ],
                            date: widget.data['date'],
                            description: descriptionController.text,
                            location: widget.data['location'],
                            title: widget.data['title'],
                            player1: player1!,
                            player2: player2!,
                            player3: player3!,
                            player4: player4!,
                            account: widget.data['account']),
                        context: context);
                    LocalDataSourceMatchSharedPereference
                        localDataSharedPereference =
                        LocalDataSourceMatchSharedPereference(
                            sharedPreferences:
                                await SharedPreferences.getInstance());
                    Account account = widget.data['account'];
                    localDataSharedPereference.storageCurentMatchData(
                        email: account.email,
                        titlematch: descriptionController.text,
                        tournamentTitle: widget.data['title'],
                        location: widget.data['location'],
                        date: widget.data['date']);
                    Navigator.pushNamedAndRemoveUntil(
                        context, startMatchPageName, (route) => false,
                        arguments: account);
                    BlocProvider.of<LastMatchCubit>(context)
                        .getLastMatch(account: account);
                  }
                },
                child: Container(
                  width: size.width * 0.35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: theme.shadowColor)
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: size.height * 0.065,
                  padding: EdgeInsets.only(left: size.width * 0.0),
                  child: AutoSizeText(
                    lang.add + ' ' + lang.newMatch,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

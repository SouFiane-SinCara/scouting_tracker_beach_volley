// ignore_for_file: unnecessary_null_comparison

import 'package:auto_size_text/auto_size_text.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/data/models/az_players.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/players_cubit/getplayer_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/error_server.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/lv_player_card.dart';

class AllPlayers extends StatefulWidget {
  final Player player;

  AllPlayers({super.key, required this.player});

  @override
  State<AllPlayers> createState() => _AllPlayersState();
}

class _AllPlayersState extends State<AllPlayers> {
  TextEditingController name = TextEditingController();

  TextEditingController surname = TextEditingController();

  TextEditingController note = TextEditingController();

  bool? righhand;
  bool? lefthand;
  List<AZPlayers> azplayer = [];

  @override
  void initState() {
    BlocProvider.of<GetplayerCubit>(context).getPlayers(player: widget.player);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(
                    context, widget.player != null ? widget.player : null);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.primaryColor,
              )),
          elevation: 0,
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            lang!.players,
            style: TextStyle(
                color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
              onTap: () {
                Navigator.pushNamed(context, addPlayerPageName, arguments: {
                  "account": widget.player.account,
                  "allPlayers": azplayer
                });
              },
              child: Container(
                width: size.width * 0.3,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: theme.colorScheme.shadow,
                          blurRadius: 10,
                          spreadRadius: 0.05,
                          offset: Offset(1, 3))
                    ],
                    color: theme.colorScheme.onSecondaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    lang.addplayer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          width: size.width,
          height: size.height,
          color: theme.colorScheme.primary,
          child: BlocBuilder<GetplayerCubit, GetplayerState>(
            builder: (context, state) {
              if (state is LoadedPlayerState) {
                azplayer = [];

                state.players.forEach((e) {
                  azplayer.add(AZPlayers(player: e, tag: e.name[0]));
                });

                azplayer.sort((a, b) =>
                    a.tag.toLowerCase().compareTo(b.tag.toLowerCase()));
                return AzListView(
                  data: azplayer,
                  indexBarItemHeight: size.height * 0.024,
                  indexBarAlignment: Alignment.topRight,
                  indexBarOptions: IndexBarOptions(
                    indexHintAlignment: Alignment.centerRight,
                  ),
                  indexHintBuilder: (context, tag) => Container(
                    decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: size.width * 0.1,
                    height: size.height * 0.05,
                    alignment: Alignment.center,
                    child: Text(
                      tag,
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 24),
                    ),
                  ),
                  indexBarHeight: size.height * 0.8,
                  itemCount: azplayer.length,
                  itemBuilder: (context, index) => PlayerCardLV(
                      isMatchSaved: widget.player.gender == 'null' &&
                              widget.player.image == 'null'
                          ? true
                          : null,
                      player: Player(
                          name: azplayer[index].player.name,
                          surname: azplayer[index].player.surname,
                          image: azplayer[index].player.image,
                          gender: azplayer[index].player.gender,
                          strongHand: azplayer[index].player.strongHand,
                          tournamentTitle: '',
                          dateLocation: 'dateLocation',
                          team: widget.player.team,
                          player: widget.player.player,
                          account: widget.player.account,
                          note: azplayer[index].player.note)),
                );
              } else if (state is EmpityPlayerState) {
                return Center(
                  child: AutoSizeText(
                    lang.noplayer,
                    style: TextStyle(
                        color: theme.primaryColor, fontWeight: FontWeight.bold),
                  ),
                );
              } else if (state is ErrorPlayerState) {
                return ErrorServerText();
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
      ),
    );
  }
}

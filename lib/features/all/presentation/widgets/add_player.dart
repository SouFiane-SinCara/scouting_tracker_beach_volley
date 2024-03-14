import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/player_card.dart';

class AddPlayer extends StatefulWidget {
  Player? player;
  AddPlayer({Key? key, required this.player}) : super(key: key);

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations? lang = AppLocalizations.of(context);
    Size size = device(context);
    ThemeData theme = Theme.of(context);
    return Container(
        width: size.width * 0.4,
        alignment: Alignment.center,
        height: size.height * 0.25,
        decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            boxShadow: [BoxShadow(blurRadius: 5, color: theme.shadowColor)],
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.1,
              width: size.width * 0.37,
              child: AutoSizeText(  
                "${lang!.addplayer} ${widget.player!.player} ${lang.toteam} ${widget.player!.team}",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    color: theme.primaryColor, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.person_add_alt_rounded,
              color: theme.primaryColor,
            )
          ],
        ));
  }
}

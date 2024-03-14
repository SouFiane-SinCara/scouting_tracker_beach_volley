import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';

class PlayerCardLV extends StatelessWidget {
  final Player player;
  final bool ?isMatchSaved;
  const PlayerCardLV({super.key, required this.player,this.isMatchSaved});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);
    
    return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
      onTap: () {
        print("p${player.image}${player.team}");
          isMatchSaved!=null
            ? null
            : Navigator.pop(
                context, {"p${player.player}${player.team}": player});
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 5, color: theme.shadowColor)],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: theme.colorScheme.secondary,
        ),
        width: size.width,
        padding: EdgeInsets.only(left: size.width * 0.03),
        height: size.height * 0.13,
        margin: EdgeInsets.symmetric(
            vertical: size.height * 0.02, horizontal: size.width * 0.06),
        child: Row(
          children: [
            Container(
                width: size.width * 0.2,
                height: size.height * 0.1,
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                    backgroundImage: NetworkImage(
                  player.image,
                ))),
            Container(
              width: size.width * 0.35,
              height: size.height * 0.2,
              padding: EdgeInsets.only(left: size.width * 0.031),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size.width * 0.30,
                    height: size.height*0.03,

                    child: AutoSizeText(
                     player.name,
                      
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    width: size.width * 0.30,
                    height: size.height*0.03,
                    child: AutoSizeText(
                      player.surname,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: theme.primaryColor,
              width: size.width * 0,
              indent: size.height * 0.02,
              endIndent: size.height * 0.02,
            ),
            Container(
              height: size.height,
              width: size.width * 0.3,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.012,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.08,
                        height: size.height * 0.04,
                        child: Transform.scale(
                          scaleX: -1,
                          child: SvgPicture.asset(
                            "lib/core/assets/icons/hand-icon.svg",
                            color: player.strongHand == "r"
                                ? Colors.black
                                : Colors.black26,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.08,
                        height: size.height * 0.04,
                        child: SvgPicture.asset(
                          'lib/core/assets/icons/hand-icon.svg',
                          color: player.strongHand == "l"
                              ? Colors.black
                              : Colors.black26,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: theme.primaryColor,
                    endIndent: size.width * 0.04,
                    indent: size.width * 0.04,
                    height: size.height * 0.03,
                  ),
                  player.gender == 'm'
                      ? Icon(
                          Icons.male,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.female,
                          color: Colors.pink,
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

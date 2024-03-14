// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

class PlayerOnField extends StatelessWidget {
  final String playerName;
  final bool isBlueTeam;
  final bool ?inverse;
  const PlayerOnField({
    Key? key,
    this.inverse,
    required this.playerName,
    required this.isBlueTeam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = device(context);
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
         inverse==null ?SizedBox():   Container(
          width: size.width * 0.05,
          height: size.height * 0.05,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isBlueTeam ? Colors.blue : Colors.red,
          ),
        ),
        inverse == null  ? SizedBox(): SizedBox(
          width: size.width * 0.02,
        ),
        Container(
          width: size.width * 0.2,
          height: size.height * 0.03,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: theme.colorScheme.secondary),
          alignment: Alignment.center,
          child: FittedBox(
              child: Text(
            playerName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          )),
        ),
      inverse!=null  ? SizedBox(): SizedBox(
          width: size.width * 0.02,
        ),
     inverse!=null ?SizedBox():   Container(
          width: size.width * 0.05,
          height: size.height * 0.05,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isBlueTeam ? Colors.blue : Colors.red,
          ),
        ),
      ],
    );
  }
}

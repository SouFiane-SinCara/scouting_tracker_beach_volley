import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';

class TournamentCard extends StatelessWidget {
  final String title;
  const TournamentCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.04),
      decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          boxShadow: [
            BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(2, 3))
          ],
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      height: size.height * 0.085,
      padding: EdgeInsets.only(left: size.width * 0.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            title,
            style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          )
        ],
      ),
    );
  }
}

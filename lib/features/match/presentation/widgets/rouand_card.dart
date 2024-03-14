// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

class RouandCard extends StatelessWidget {
  final bool state;
  final int home;
  final int rouand;
  final int away;
  const RouandCard({
    Key? key,
    required this.state,
    required this.home,
    required this.rouand,
    required this.away,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);

    AppLocalizations? lang = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: state ? Colors.transparent : theme.primaryColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 5,
          )
        ],
        color: state ? theme.colorScheme.secondary : theme.colorScheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: size.width * 0.3,
      height: size.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: size.width * 0.02,
          ),
          FittedBox(
            child: SizedBox(
              width: size.width * 0.05,
              child: Text(
                home.toString(),
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          FittedBox(
            child: SizedBox(
              width: size.width * 0.1,
              child: Text(
                '${rouand} set',
                style: TextStyle(color: theme.primaryColor, fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          FittedBox(
            child: SizedBox(
              width: size.width * 0.05,
              child: Text(
                away.toString(),
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
        ],
      ),
    );
  }
}

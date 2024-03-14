// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

class SurnamePic extends StatelessWidget {
  final bool redteam;
  final String surname;
  final String image;
  const SurnamePic({
    Key? key,
    required this.redteam,
    required this.surname,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    
    AppLocalizations? lang = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 5,
          )
        ],
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: size.width * 0.3,
      height: size.height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: size.width * 0.1,
              alignment: Alignment.centerLeft,
              height: size.height * 0.055,
              child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    image,
                  ))),
          SizedBox(
            width: size.width * 0.02,
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: size.width * 0.17,
            height: size.height * 0.06,
            child: FittedBox(
              child: Text(
                surname,
                style: TextStyle(
                    color: redteam
                        ? theme.brightness == Brightness.dark
                            ? Colors.red[300]
                            : Colors.red[900]
                        : theme.brightness == Brightness.light
                            ? Colors.blue[900]
                            : Colors.blue[200],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownButton extends StatelessWidget {
  final void Function(String?)? fun;
  final List<DropdownMenuItem<String>>? list;
  final String? value;
  final String hintText;

  const DownButton(
      {required this.list,
      required this.hintText,
      Key? key,
      required this.fun,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          value: value,
          hint: Container(
            width: MediaQuery.of(context).size.width * 0.1,
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                hintText,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          items: list,
          icon: Container(
            child: FittedBox(
                child: Icon(Icons.arrow_drop_down, color: theme.primaryColor)),
          ),
          style: TextStyle(
            color: theme
                .primaryColor, // Adjust the font size based on screen width
          ),
          onChanged: fun,
        ),
      ),
    );
  }
}

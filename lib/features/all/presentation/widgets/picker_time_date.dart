import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/colors/colors.dart';

Future<DateTime> showPicker(DateTime dateATime, BuildContext context) async {
  DateTime? date = await showDatePicker(
    context: context,
    initialDate: dateATime,
    firstDate: DateTime(1000),
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).brightness == Brightness.light
            ? ThemeData(
                brightness: Brightness.light,
                primarySwatch: MaterialColor(Colors.black.value, blackSwatch),
              )
            : ThemeData(
                brightness: Brightness.dark,
                primarySwatch: MaterialColor(Colors.white.value, blackSwatch),
              ),
        child: child!,
      );
    },
  );
  
  DateTime? dateTime;
  date != null
      ? dateTime =
          DateTime(date.year, date.month, date.day, )
      : null;

  if (date != null &&  dateTime != null) {
    return dateTime;
  } else {
    return DateTime.now();
  }
}

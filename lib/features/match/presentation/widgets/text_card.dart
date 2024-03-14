// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

class TextCard extends StatelessWidget {
  final bool taped;
  final String text;
  TextCard({
    Key? key,
    required this.taped,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Size size = device(context);

    final textWidth = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: 16), // Replace with your desired font size
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Container(
      width: size.width * 0.2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(width: 2, color: theme.primaryColor),
        color: taped ? theme.colorScheme.secondary : theme.colorScheme.primary,
      ),
      height: size.height * 0.08,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      margin: EdgeInsets.only(left: size.width * 0.02),
      child: FittedBox(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

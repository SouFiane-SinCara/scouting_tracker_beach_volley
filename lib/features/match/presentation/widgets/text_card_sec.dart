// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';

class TextCardSec extends StatelessWidget {
  final bool taped;
  final bool ?newLine;
  final String text;
  final double? width;
  final double? font;

  final double? height;
  const TextCardSec({
    Key? key,
    this.height,
    this.width,
    this.newLine,
    this.font,
    required this.taped,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? lang = AppLocalizations.of(context);
    ThemeData theme = Theme.of(context);
    Size size = device(context);
    return Container(
      width: width ?? size.width * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(width: 2, color: theme.primaryColor),
        color: taped ? newLine ==null ?theme.colorScheme.secondary:theme.colorScheme.secondary.withOpacity(0.4) : theme.colorScheme.primary,
      ),
      height: height ?? size.height * 0.05,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: size.width * 0.01),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width*0.02),
        child: FittedBox(
          child:newLine==null? AutoSizeText(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: font ?? 20),
          ):Icon(Icons.restart_alt_rounded),
        ),
      ),
    );
  }
}

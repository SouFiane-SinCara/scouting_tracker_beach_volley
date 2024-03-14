import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorServerText extends StatelessWidget {
  const ErrorServerText({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? lang = AppLocalizations.of(context);
    return Center(
      child: AutoSizeText(lang!.serverFailure),
    );
  }
}

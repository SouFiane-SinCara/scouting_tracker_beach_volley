import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/language_cubit/language_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageChangerCard extends StatelessWidget {
  const LanguageChangerCard({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? lang = AppLocalizations.of(context);
    ThemeData theme = themeDevice(context);
    return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
      onTap: () async {
        if (lang.language == "English") {
          BlocProvider.of<LanguageCubit>(context).changeLanguage('it');
        } else {
          BlocProvider.of<LanguageCubit>(context).changeLanguage('en');
        }
      },
      child: Container(
          alignment: Alignment.centerRight,
          child: theme.brightness == Brightness.dark
              ? Image.asset(
                  "lib/core/assets/images/dark_${lang!.flag}",
                )
              : Image.asset(
                  "lib/core/assets/images/light_${lang!.flag}",
                )),
    );
  }
}

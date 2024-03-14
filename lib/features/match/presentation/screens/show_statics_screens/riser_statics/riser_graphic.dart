import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';

class RiserGraphic extends StatelessWidget {
  const RiserGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = device(context);

    ThemeData theme = Theme.of(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: Text(lang!.comingSoon,style: TextStyle(color: theme.primaryColor,fontWeight: FontWeight.bold,fontSize: 30),)
    );
  }
}

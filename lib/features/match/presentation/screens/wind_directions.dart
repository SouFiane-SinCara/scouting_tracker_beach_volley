import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';

class WindDirectionSelectPage extends StatelessWidget {
  const WindDirectionSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = device(context);

    AppLocalizations? lang = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        elevation: 0,
        title: Text(
          lang!.winddirection,
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: Container(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: 33,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
              onTap: () {
                BlocProvider.of<DirectionCubit>(context)
                    .newDirection(newDirection: index);
                Navigator.pop(
                  context,
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.02),
                child: SvgPicture.asset(
                  'lib/core/assets/icons/wind_direction_icons/$index.svg',
                  fit: BoxFit.contain,
                  color: theme.primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

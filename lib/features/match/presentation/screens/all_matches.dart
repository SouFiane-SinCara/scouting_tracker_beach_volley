import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/match_cubit/match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/tournament_card.dart';

class AllMatches extends StatefulWidget {
  Map data;
  AllMatches({super.key, required this.data});

  @override
  State<AllMatches> createState() => _AllMatchesState();
}

class _AllMatchesState extends State<AllMatches> {
  @override
  void initState() {
    
    BlocProvider.of<MatchCubit>(context).getMatches(
        title: widget.data['title'],
        date: widget.data['date'],
        location: widget.data['location'],
        context: context,
        account: widget.data['account']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: theme.colorScheme.primary,
        child: BlocBuilder<MatchCubit, MatchState>(
          builder: (context, state) {
            if (state is LoadedMatchesState) {
              return ListView.builder(
                itemCount: state.matches.length,
                itemBuilder: (BuildContext context, int index) {
                  return TournamentCard(
                      title: state.matches[index].description);
                },
              );
            } else if (state is ErrorMatchesState) {
              return Center(
                child: Text(state.error),
              );
            } else if (state is EmpityMatchesState) {
              return Center(
                child: Text(lang!.noMatches),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/tournaments_cubit/tournaments_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/tournament_card.dart';

class GetLocationDate extends StatefulWidget {
  final Map data;
  const GetLocationDate({super.key, required this.data});

  @override
  State<GetLocationDate> createState() => _GetLocationDateState();
}

class _GetLocationDateState extends State<GetLocationDate> {
  DateTime dateATime = DateTime.now();
  TextEditingController locationController = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<TournamentsCubit>(context).getlocationDate(
        account: widget.data['account'], tournamentTitle: widget.data['title']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = device(context);
    ThemeData theme = themeDevice(context);
    AppLocalizations? lang = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          elevation: 0,
          title: Text('${lang!.location} and ${lang.date}'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.primaryColor,
            ),
            onPressed: () {
              if (widget.data['isLDdetails'] == null) {
                Navigator.pop(context, {'location': '', 'date': ''});
              } else {
                Navigator.pop(context, {
                  'account': widget.data['account'],
                  'istournamentDetails': true
                });

                BlocProvider.of<TournamentsCubit>(context)
                    .getTournaments(account: widget.data['account']);
              }
            },
          )),
      floatingActionButton: widget.data['isLDdetails'] == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pushNamed(context, tournamentGetinfoPageName,
                        arguments: {
                          'account': widget.data['account'],
                          'title': widget.data['title']
                        });
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.07,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: theme.colorScheme.shadow,
                              blurRadius: 10,
                              spreadRadius: 0.05,
                              offset: Offset(1, 3))
                        ],
                        color: theme.colorScheme.onSecondaryContainer,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        lang.addnewtournament,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )
          : SizedBox(),
      body: BlocBuilder<TournamentsCubit, TournamentsState>(
        builder: (context, state) {
          if (state is LoadedLocationState) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: ListView.builder(
                itemCount: state.locationdate.length,
                itemBuilder: (BuildContext context, int index) {
                  state.locationdate
                      .sort((a, b) => a['date'].compareTo(b['date']));

                  return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                    onTap: () {
                      if (widget.data['isLDdetails'] == null) {
                        Navigator.pop(context, {
                          'title': widget.data['title'],
                          'location':
                              "${state.locationdate[index]['location']}",
                          'date': "${state.locationdate[index]['date']}"
                        });
                      } else {
                        Navigator.pushNamed(context, allMatchesPageName,
                            arguments: {
                              'title': widget.data['title'],
                              'account': widget.data['account'],
                              'location':
                                  "${state.locationdate[index]['location']}",
                              'date': "${state.locationdate[index]['date']}"
                            });
                      }
                    },
                    child: TournamentCard(
                        title:
                            "${state.locationdate[index]['location']}  |  ${state.locationdate[index]['date']}"),
                  );
                },
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

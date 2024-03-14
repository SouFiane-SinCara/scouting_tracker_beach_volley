import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/tournaments_cubit/tournaments_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/dialog_error.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/error_server.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/my_field.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/tournament_card.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

class TournamentsPage extends StatefulWidget {
  final Map data;
  final TextEditingController titlecontroller = TextEditingController();
  final bool? isTournamentsDetails;

  TournamentsPage({super.key, required this.data, this.isTournamentsDetails});

  @override
  State<TournamentsPage> createState() => _TournamentsPageState();
}

class _TournamentsPageState extends State<TournamentsPage> {
  @override
  void initState() {
    BlocProvider.of<TournamentsCubit>(context)
        .getTournaments(account: widget.data['account']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = device(context);
    ThemeData theme = themeDevice(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                if (widget.data['istournamentDetails'] == null) {
                  Navigator.pop(context, {
                    "title": widget.data['title'] ?? lang!.selecttournament,
                    "location": widget.data['location'],
                    "date": widget.data['date']
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.primaryColor,
              )),
          elevation: 0,
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            lang!.tournaments,
            style: TextStyle(
                color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: widget.data['istournamentDetails'] == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.transparent,
                          actions: [
                            Container(
                              width: size.width,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Myfield(
                                      textInputAction: TextInputAction.done,
                                      controller: widget.titlecontroller,
                                      text: lang.tournamentTitle,
                                      enable: true,
                                      icon: Icon(
                                        Icons.edit,
                                        color: theme.primaryColor,
                                      )),
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  BlocBuilder<TournamentsCubit,
                                      TournamentsState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () async {
                                          String stringWithoutSpaces = widget
                                              .titlecontroller.text
                                              .replaceAll(' ', '');
                                          bool exist = false;
                                          if (state is LoadedTournamentsState) {
                                            

                                            for (int i = 0;
                                                i < state.tournaments.length;
                                                i++) {
                                              if (state.tournaments[i].trim() ==
                                                  widget.titlecontroller.text
                                                      .trim()) {
                                                exist = true;
                                                break;
                                              }
                                            }
                                          }
                                          if (stringWithoutSpaces.isEmpty) {
                                            Navigator.pop(context);
                                            DialogError(
                                                lang.add +
                                                    ' ' +
                                                    lang.tournamentTitle,
                                                context);
                                          } else if (exist == true) {
                                            Navigator.pop(context);

                                            DialogError(
                                                lang.tournametexsite, context);
                                          } else {
                                            Navigator.of(context).pop();

                                            await BlocProvider.of<
                                                    TournamentsCubit>(context)
                                                .createTournament(
                                                    title: widget
                                                        .titlecontroller.text,
                                                    account:
                                                        widget.data['account']);
                                            widget.titlecontroller.clear();
                                          }
                                        },
                                        child: Container(
                                          width: size.width * 0.25,
                                          decoration: BoxDecoration(
                                              color:
                                                  theme.colorScheme.secondary,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 5,
                                                    color: theme.shadowColor)
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          height: size.height * 0.065,
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AutoSizeText(
                                                lang.add,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Icon(Icons.add)
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
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
        body: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
          onTap: () {},
          child: Container(
            color: theme.colorScheme.primary,
            child: BlocBuilder<TournamentsCubit, TournamentsState>(
              builder: (context, state) {
                if (state is LoadedTournamentsState) {
                  return ListView.builder(
                    itemCount: state.tournaments.length,
                    itemBuilder: (context, index) {
                      state.tournaments.sort((a, b) => a.compareTo(b));
                      return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        onTap: () async {
                          if (widget.data['istournamentDetails'] == null) {
                            
                            Navigator.pop(context, {
                              "title": state.tournaments[index],
                              "account": widget.data['account'] as Account,
                            });
                          } else {
                            final data = await Navigator.pushNamed(
                                context, getDateLocationPageName,
                                arguments: {
                                  "account": widget.data['account'],
                                  "title": state.tournaments[index],
                                  "isLDdetails": true
                                });
                            if (data is Map) {
                              widget.data['account'] = data['account'];
                              widget.data['istournamentDetails'] =
                                  data['istournamentDetails'];
                            }
                          }
                        },
                        child: TournamentCard(
                          title: state.tournaments[index],
                        ),
                      );
                    },
                  );
                } else if (state is EmpityTournamentsState) {
                  return Center(
                    child: AutoSizeText(
                      lang.noTournaments,
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  );
                } else if (state is TournamentsInitial) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                } else if (state is ErrorTournamentsState) {
                  return ErrorServerText();
                } else {
                  return Center(
                    child: AutoSizeText(
                      lang.serverFailure,
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

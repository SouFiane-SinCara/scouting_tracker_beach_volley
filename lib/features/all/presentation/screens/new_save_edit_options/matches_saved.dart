import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/saved_match_cubit/saved_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/login_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/local_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchesSaved extends StatelessWidget {
  const MatchesSaved({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return BlocBuilder<SavedMatchCubit, SavedMatchState>(
          builder: (context, savedMatchState) {
            List<Map> lv = [];
            if (state is LoginDoneState) {
              savedMatchState is TournamentsState
                  ? savedMatchState.tournaments.forEach((element) {
                      lv.add({
                        "nameBox": element,
                        "navigation": () {
                          BlocProvider.of<SavedMatchCubit>(context)
                              .navigateToLocationsDate(state.account, element);
                        },
                      });
                    })
                  : savedMatchState is LocationsDateState
                      ? savedMatchState.locationDate.forEach((element) {
                          lv.add({
                            "nameBox":
                                element['location'] + ' | ' + element['date'],
                            "navigation": () {
                              BlocProvider.of<SavedMatchCubit>(context)
                                  .navigateToMatches(
                                      account: state.account,
                                      title: savedMatchState.tournamentTitle,
                                      date: element['date'],
                                      location: element['location']);
                            },
                          });
                        })
                      : savedMatchState is MatchesState
                          ? savedMatchState.matches.forEach((element) {
                              lv.add({
                                "nameBox": element.description,
                                "navigation": () async {
                                  LocalDataSouceMatch local =
                                      LocalDataSourceMatchSharedPereference(
                                          sharedPreferences:
                                              await SharedPreferences
                                                  .getInstance());
                                  await local.storageCurentMatchData(
                                      email: state.account.email,
                                      date: element.date,
                                      location: element.location,
                                      titlematch: element.description,
                                      tournamentTitle: element.title);
                                  RemoteDataSourceGetLastMatch remote =
                                      RemoteDataSourceGetLastMatchFB();
                                  AMatch match = await remote.getLastMatch();
                                  BlocProvider.of<LastMatchCubit>(context)
                                      .emit(StartedMatchState(aMatch: match));
                                  Navigator.pushReplacementNamed(
                                      context, startMatchPageName,
                                      arguments: state.account);
                                },
                              });
                            })
                          : lv = [
                              {
                                "nameBox": lang!.tournaments,
                                "navigation": () {
                                  BlocProvider.of<SavedMatchCubit>(context)
                                      .navigateToTournaments(state.account);
                                },
                              },
                              {
                                "nameBox": lang.players,
                                "navigation": () {
                                  Navigator.pushNamed(
                                      context, allPlayersLVPageName,
                                      arguments: Player(
                                          name: '',
                                          surname: '',
                                          image: 'null',
                                          gender: 'null',
                                          strongHand: '',
                                          tournamentTitle: '',
                                          dateLocation: '',
                                          team: '1',
                                          player: '1',
                                          account: state.account,
                                          note: ''));
                                },
                              }
                            ];
            }
            return Scaffold(
              backgroundColor: theme.colorScheme.primary,
              appBar: AppBar(
                elevation: 0,
              ),
              body: savedMatchState is SavedMatchInitial
                  ? Center(
                      child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ))
                  : lv.isEmpty
                      ? Container(
                          color: theme.colorScheme.primary,
                          width: size.width,
                          height: size.height,
                          alignment: Alignment.center,
                          child: Container(
                            width: size.width*0.8,
                            height: size.height*0.05,
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: Text(
                                lang!.noMatches,
                                style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: lv.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                              onTap: lv[index]['navigation'],
                              child: Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                height: size.height * 0.1,
                                margin: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02,
                                    horizontal: size.width * 0.02),
                                alignment: Alignment.center,
                                child: FittedBox(
                                    child: Text(
                                  lv[index]['nameBox'] ?? 'd',
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                )),
                              ),
                            );
                          },
                        ),
            );
          },
        );
      },
    );
  }
}

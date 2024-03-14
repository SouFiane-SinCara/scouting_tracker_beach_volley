import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/choose_page.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/initial_page.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/location_date/add_location_date.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/location_date/all_locations_date.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/new_save_edit_options/matches_saved.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/new_save_edit_options/new_match.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/players/add_player_page.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/players/all_players.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/screens/tournaments_part/tournaments_page.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/connection_bloc/connection_bloc.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/screens/login.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/screens/sign_up.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/all_matches.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/do_statics_screens/beat.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/do_statics_screens/end_action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/match_story.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/statics_home.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/start_match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/wind_directions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyRoutes {
  Route onGenerate(RouteSettings routeSettings) {
    bool ishowed = false;

    Route createRoute(Widget page) {
      return MaterialPageRoute(
        builder: (context) => BlocListener<ConnectionBloc, ConnectionsState>(
          listener: (context, con) {
            if (con is DisconnectedState) {
              ishowed = true;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  Size size = device(context);
                  ThemeData theme = themeDevice(context);
                  AppLocalizations? lang = AppLocalizations.of(context);
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      backgroundColor: Colors.transparent,
                      actions: [
                        Container(
                          width: double.infinity,
                          height: size.height * 0.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  child: Text(
                                    lang!.checkyourinternetplease + ' !',
                                    style: TextStyle(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              ),
                              Container(
                                width: size.width * 0.5,
                                height: size.height * 0.35,
                                child: Image.asset(
                                  theme.brightness != Brightness.light
                                      ? "lib/core/assets/images/No connection_dark.png"
                                      : "lib/core/assets/images/No connection_light.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (con is ConnectedState && ishowed == true) {
              Navigator.pop(context);
            }
          },
          child: page,
        ),
      );
    }

    switch (routeSettings.name) {
      case initialPageName:
        return createRoute(InitialPage());
      case addPlayerPageName:
        return createRoute(AddPlayerPage(data: routeSettings.arguments as Map));
      case choosePageName:
        return createRoute(
            ChoosePage(account: routeSettings.arguments as Account));
      case allPlayersLVPageName:
        return createRoute(
            AllPlayers(player: routeSettings.arguments as Player));
      case matchesSavedPageName:
        return createRoute(MatchesSaved());
      case tournamentsPageName:
        return createRoute(
            TournamentsPage(data: routeSettings.arguments as Map));
      case getDateLocationPageName:
        return createRoute(
            GetLocationDate(data: routeSettings.arguments as Map));
      case detailsTournamentPageName:
        return createRoute(
            TournamentsPage(data: routeSettings.arguments as Map));
      case newMatchPageName:
        return createRoute(NewMatchPage(data: routeSettings.arguments as Map));
      case loginPageName:
        return createRoute(LoginPage());
      case allMatchesPageName:
        return createRoute(AllMatches(data: routeSettings.arguments as Map));
      case tournamentGetinfoPageName:
        return createRoute(
            TournamentGetinfo(data: routeSettings.arguments as Map));
      case signUpPageName:
        return createRoute(SignUpPage());
      case beatPageName:
        return createRoute(
            BeatPage(data: routeSettings.arguments as Map<String, dynamic>));
      case windDirectionPageName:
        return createRoute(const WindDirectionSelectPage());
      case staticMatchPageName:
        return createRoute(
            StaticsPage(account: routeSettings.arguments as Account));
      case endActionPageName:
        return createRoute(EndAction(data: routeSettings.arguments as Map));
      case startMatchPageName:
        return createRoute(
            StartMatch(account: routeSettings.arguments as Account));
      case matchStoryPageName:
        return createRoute(Matchstory(
          account: routeSettings.arguments as Account,
        ));
      default:
        return createRoute(InitialPage());
    }
  }
}

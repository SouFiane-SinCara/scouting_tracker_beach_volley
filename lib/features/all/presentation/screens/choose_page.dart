import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/saved_match_cubit/saved_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/language_card_change.dart';
import 'package:scouting_tracker_beach_volley/features/auth/data/source/local.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/login_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/start_match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePage extends StatefulWidget {
  final Account account;
  const ChoosePage({super.key, required this.account});

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  void initState() {
    BlocProvider.of<LastMatchCubit>(context)
        .getLastMatch(account: widget.account);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = themeDevice(context);
    Size size = device(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    return BlocBuilder<LastMatchCubit, LastMatchState>(
      builder: (context, state) {
        if (state is ChooseMatchState) {
          return SafeArea(
            child: Scaffold(
                backgroundColor: theme.colorScheme.primary,
                appBar: AppBar(
                  titleSpacing: 0,
                  title: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                color: theme.primaryColor,
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Container(
                                width: size.width * 0.4,
                                height: size.height,
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  '  ' + state.account.username,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              LanguageChangerCard(),
                              IconButton(
                                  onPressed: () async {
                                    FirebaseAuth.instance.signOut();
                                    LocalDataAccount localDataAccount =
                                        LocalDataSharedPereference(
                                            sharedPreferences:
                                                await SharedPreferences
                                                    .getInstance());
                                    localDataAccount.delete();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      loginPageName,
                                      (route) => false,
                                    );

                                    await BlocProvider.of<LoginCubit>(context)
                                        .login(
                                            account: Account(
                                                username: "",
                                                email: "",
                                                password: ""));
                                  },
                                  icon: Icon(
                                    Icons.logout,
                                    color: theme.primaryColor,
                                  ))
                            ],
                          )
                        ]),
                  ),
                  // leading: Container(
                  //   child: Row(children: [
                  //     Icon(
                  //       Icons.person,
                  //       color: theme.primaryColor,
                  //     ),
                  //     SizedBox(
                  //       width: size.width * 0.02,
                  //     ),
                  //     VerticalDivider(
                  //       color: theme.primaryColor,
                  //       width: size.width*0.02,
                  //       endIndent: size.height*0.02,
                  //       indent: size.height*0.02,
                  //     ),
                  //     Container(
                  //       width: size.width * 0.4,
                  //       height: size.height * 0.1,
                  //       color: Colors.red,
                  //       alignment: Alignment.centerLeft,
                  //       child: AutoSizeText(
                  //     '  '+    "moahemdo",
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.bold,
                  //             color: theme.primaryColor),
                  //       ),
                  //     )
                  //   ]),
                  // ),
                  // leadingWidth: size.width * 0.4,
                  elevation: 0,
                  backgroundColor: theme.colorScheme.secondary,
                  // actions: [

                  // ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                      color: theme.colorScheme.primary,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width * 0.8,
                            height: size.height * 0.4,
                            child: FittedBox(
                              child: theme.brightness != Brightness.light
                                  ? Image.asset(
                                      "lib/core/assets/images/dark_logo_without_bg.png")
                                  : Image.asset(
                                      "lib/core/assets/images/light_logo_without_bg.png"),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.45,
                            width: size.width * 0.9,
                            child: Stack(
                              children: [
                                //!: new match
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                    
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, newMatchPageName,
                                          arguments: {
                                            "title": lang.selecttournament,
                                            "account": widget.account,
                                          });
                                    },
                                    child: Container(
                                      height: size.height * 0.2,
                                      width: size.width * 0.4,
                                      margin: EdgeInsets.symmetric(
                                          vertical: size.height * 0.01,
                                          horizontal: size.width * 0.01),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              theme.colorScheme.secondary,
                                              theme.colorScheme.secondary
                                                  .withOpacity(0.5),
                                            ],
                                            stops: const [0.7, 1],
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Container(
                                          width: size.width * 0.5,
                                          alignment: Alignment.center,
                                          child: AutoSizeText(
                                            lang!.newMatch,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: theme
                                                    .colorScheme.onSecondary,
                                                fontFamily: "MyFont"),
                                          )),
                                    ),
                                  ),
                                ),
                                //!: matches saved

                                Container(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                                    onTap: () {
                                      BlocProvider.of<SavedMatchCubit>(context)
                                          .navigateToTournamentsPlayers();
                                      Navigator.pushNamed(
                                          context, matchesSavedPageName);
                                    },
                                    child: Container(
                                      height: size.height * 0.2,
                                      width: size.width * 0.4,
                                      margin: EdgeInsets.symmetric(
                                          vertical: size.height * 0.01,
                                          horizontal: size.width * 0.01),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              theme.colorScheme.secondary,
                                              theme.colorScheme.secondary
                                                  .withOpacity(0.5),
                                            ],
                                            stops: const [0.7, 1],
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Container(
                                          width: size.width * 0.5,
                                          alignment: Alignment.center,
                                          child: AutoSizeText(
                                            lang.matchesSaved,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: theme
                                                    .colorScheme.onSecondary,
                                                fontFamily: "MyFont"),
                                          )),
                                    ),
                                  ),
                                ),
                                //!: edit Data

                                // Container(
                                //   alignment: Alignment.bottomLeft,
                                //   child: Container(
                                //     height: size.height * 0.2,
                                //     width: size.width * 0.4,
                                //     margin: EdgeInsets.symmetric(
                                //         vertical: size.height * 0.01,
                                //         horizontal: size.width * 0.01),
                                //     decoration: BoxDecoration(
                                //         gradient: LinearGradient(
                                //           begin: Alignment.bottomCenter,
                                //           end: Alignment.topCenter,
                                //           colors: [
                                //             theme.colorScheme.secondary,
                                //             theme.colorScheme.secondary
                                //                 .withOpacity(0.5),
                                //           ],
                                //           stops: const [0.7, 1],
                                //         ),
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(10))),
                                //     child: Container(
                                //         width: size.width * 0.5,
                                //         alignment: Alignment.center,
                                //         child: AutoSizeText(
                                //           lang.editData,
                                //           style: TextStyle(
                                //               fontWeight: FontWeight.bold,
                                //               color:
                                //                   theme.colorScheme.onSecondary,
                                //               fontFamily: "MyFont"),
                                //         )),
                                //   ),
                                // ),
                                //!: Options

                                // Container(
                                //   alignment: Alignment.bottomCenter,
                                //   child: Container(
                                //     height: size.height * 0.2,
                                //     width: size.width * 0.4,
                                //     margin: EdgeInsets.symmetric(
                                //         vertical: size.height * 0.01,
                                //         horizontal: size.width * 0.01),
                                //     decoration: BoxDecoration(
                                //         gradient: LinearGradient(
                                //           begin: Alignment.bottomCenter,
                                //           end: Alignment.topCenter,
                                //           colors: [
                                //             theme.colorScheme.secondary,
                                //             theme.colorScheme.secondary
                                //                 .withOpacity(0.5),
                                //           ],
                                //           stops: const [0.7, 1],
                                //         ),
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(10))),
                                //     child: Container(
                                //         width: size.width * 0.5,
                                //         alignment: Alignment.center,
                                //         child: AutoSizeText(
                                //           lang.options,
                                //           style: TextStyle(
                                //               fontWeight: FontWeight.bold,
                                //               color:
                                //                   theme.colorScheme.onSecondary,
                                //               fontFamily: "MyFont"),
                                //         )),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      )),
                )),
          );
        } else if (state is StartedMatchState) {
          return StartMatch(
            account:widget.account,
            fromChoosePage: true,
          );
        } else {
          return Scaffold(
            backgroundColor: theme.colorScheme.primary,
            body: Center(
                child: Center(
                    child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
              onTap: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove('match');
              },
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            ))),
          );
        }
      },
    );
  }
}

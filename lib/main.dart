import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/routes/MyRoutes.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/connection_bloc/connection_bloc.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/language_cubit/language_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/match_cubit/match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/players_cubit/getplayer_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/saved_match_cubit/saved_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/stateMangement/tournaments_cubit/tournaments_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/themes/dark.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/themes/light.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/auth_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/auth/presensation/state_mangament/cubit/login_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/list_rise_type_cubit/list_rise_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/Type_Beat_cubit/type_beat_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_options_cubit/attack_options_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_type_cubit/attack_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/ball_line_cubit/ball_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/direction_cubit/direction_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/errors_beats_cubit/errors_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/graphic_or_state_cubit/graphic_or_state_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/invert_cubit/invert_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_change_ball_type_cubit/list_change_ball_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_type_lines_cubit/list_type_lines_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/list_wall_cubit/list_wall_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_choose_cubit/choose_player_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/reset_line_cubit/reset_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/riser_type_cubit/riser_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/rouand_cubit/rouand_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/scoore_cubit/scoore_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/show_player_on_field_cubit/show_player_on_field_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/table_data_cubit/table_data_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/team_cubit/team_cubit.dart';
import 'package:scouting_tracker_beach_volley/firebase_options.dart';
import 'package:scouting_tracker_beach_volley/l10n/l10n.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
        alignment: Alignment.center,
        child: Text(
          '${details.exception}',
          style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 20), // TextStyle
          textAlign: TextAlign.center,
// Text
        )); // Container
  };

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // cheak user platform

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (context) => TournamentsCubit()),
      BlocProvider(
        create: (context) => LanguageCubit()..changeLanguage(''),
      ),
      BlocProvider(
        create: (context) => AuthCubit(signUpUseCase: SignUpUseCase()),
      ),
      BlocProvider(
        create: (context) => GetplayerCubit(),
      ),
      BlocProvider(
        create: (context) => LastMatchCubit(),
      ),
      BlocProvider(
        create: (context) => TableDataCubit(),
      ),
      BlocProvider(
        create: (context) => ConnectionBloc(),
      ),
      BlocProvider(
        create: (context) => AcctionsPlayCubit(),
      ),
       BlocProvider(
        create: (context) => ShowPlayerOnFieldCubit(),
      ),
      BlocProvider(
        create: (context) => ErrorsBeatsCubit(),
      ),
      BlocProvider(
        create: (context) => InvertCubit(),
      ),
      BlocProvider(
        create: (context) => ListWallCubit(),
      ),
      BlocProvider(
        create: (context) => DirectionCubit(),
      ),
      BlocProvider(
        create: (context) => ScooreCubit(),
      ),
      BlocProvider(
        create: (context) => TeamCubit(),
      ),
      BlocProvider(
        create: (context) => SetsCubit(),
      ),
      BlocProvider(
        create: (context) => ListChangeBallTypeCubit(),
      ),
      BlocProvider(
        create: (context) => ListTypeLinesCubit(),
      ),
      BlocProvider(
        create: (context) => GraphicOrStateCubit(),
      ),
      BlocProvider(
        create: (context) => PlayerSelectStaticsCubit(),
      ),
      BlocProvider(
        create: (context) => GetBeatsCubit(),
      ),
      BlocProvider(
        create: (context) => ListRiseTypeCubit(),
      ),
      BlocProvider(
        create: (context) => RiserTypeCubit()..emit(RiserTypeInitial()),
      ),
      BlocProvider(
        create: (context) => TypeBeatCubit()..emit(TypeBeatInitial()),
      ),
      BlocProvider(
        create: (context) => ChoosePlayerCubit()..emit(ChoosePlayerInitial()),
      ),
      BlocProvider(
        create: (context) => LoginCubit(),
      ),
      BlocProvider(
        create: (context) => SavedMatchCubit(),
      ),
      BlocProvider(
        create: (context) => AttackOptionsCubit(),
      ),
      BlocProvider(
        create: (context) => MatchCubit(),
      ),
      BlocProvider(
        create: (context) => AttackTypeCubit(),
      ),
      BlocProvider(
        create: (context) => ResetLineCubit(),
      ),
      BlocProvider(
        create: (context) => BallLineCubit(),
      ),
      BlocProvider(
        create: (context) => RouandCubit(),
      )
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        if (state is ItState) {
          return MaterialApp(
              title: 'Flutter Demo',
              darkTheme: darkTheme,
              theme: lightTheme,
              debugShowCheckedModeBanner: false,
              supportedLocales: L10n.all,
              locale: const Locale('it'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              onGenerateRoute: MyRoutes().onGenerate);
        } else {
          return MaterialApp(
              title: 'Flutter Demo',
              darkTheme: darkTheme,
              theme: lightTheme,
              debugShowCheckedModeBanner: false,
              supportedLocales: L10n.all,
              locale: const Locale('en'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              onGenerateRoute: MyRoutes().onGenerate);
        }
      },  
    );
  }
}

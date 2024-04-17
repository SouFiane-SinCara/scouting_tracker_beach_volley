// ignore_for_file: public_member_api_docs, sort_constructors_first, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, avoid_print
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scouting_tracker_beach_volley/core/constants/strings/routes_names.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/all/presentation/widgets/player_card.dart';
import 'package:scouting_tracker_beach_volley/features/match/data/sources/remote_data.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/Type_Beat_cubit/type_beat_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_options_cubit/attack_options_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/attack_type_cubit/attack_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/ball_line_cubit/ball_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/errors_beats_cubit/errors_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_choose_cubit/choose_player_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/reset_line_cubit/reset_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/riser_type_cubit/riser_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/show_player_on_field_cubit/show_player_on_field_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/team_cubit/team_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/text_card_sec.dart';

class BeatPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const BeatPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final AMatch match = data['match'];
    final int currentSet = data['currentSet'];

    Size size = MediaQuery.of(context).size;
    AppLocalizations? lang = AppLocalizations.of(context);
    TypeBeatCubit typeBeat = BlocProvider.of<TypeBeatCubit>(context);
    typeBeat.typeBeat = 'normal';
    RiserTypeCubit typeRise = BlocProvider.of<RiserTypeCubit>(context);
    print('new state:');
    BlocProvider.of<ResetLineCubit>(context).reset();
    BlocProvider.of<TypeBeatCubit>(context).emit(TypeBeatInitial());
    BlocProvider.of<ErrorsBeatsCubit>(context).emit(ErrorsBeatsInitial());
    BlocProvider.of<ChoosePlayerCubit>(context).player = null;
    BlocProvider.of<RiserTypeCubit>(context).typeofriser = null;
    BlocProvider.of<RiserTypeCubit>(context).emit(RiserTypeInitial());
    BlocProvider.of<ChoosePlayerCubit>(context).emit(ChoosePlayerInitial());
    BlocProvider.of<TypeBeatCubit>(context).emit(TypeBeatInitial());
    BlocProvider.of<BallLineCubit>(context).emit(BallLineInitial());
    BlocProvider.of<BallLineCubit>(context)
        .newLine(Offset.zero, Offset.zero, false);
    BlocProvider.of<AttackTypeCubit>(context).newAttack(AttackTypeInitial());

    BlocProvider.of<AttackOptionsCubit>(context).emit(AttackOptionsInitial());
    return BlocListener<AttackTypeCubit, AttackTypeState>(
      listener: (context, state) {
        print("new state: $state");
        BlocProvider.of<ResetLineCubit>(context).reset();
        BlocProvider.of<TypeBeatCubit>(context).emit(TypeBeatInitial());
        BlocProvider.of<ErrorsBeatsCubit>(context).emit(ErrorsBeatsInitial());
        BlocProvider.of<ChoosePlayerCubit>(context).player = null;
        BlocProvider.of<RiserTypeCubit>(context).typeofriser = null;
        BlocProvider.of<RiserTypeCubit>(context).emit(RiserTypeInitial());
        BlocProvider.of<ChoosePlayerCubit>(context).emit(ChoosePlayerInitial());
        BlocProvider.of<TypeBeatCubit>(context).emit(TypeBeatInitial());
        BlocProvider.of<BallLineCubit>(context).emit(BallLineInitial());
        BlocProvider.of<BallLineCubit>(context)
            .newLine(Offset.zero, Offset.zero, false);

        BlocProvider.of<AttackOptionsCubit>(context)
            .emit(AttackOptionsInitial());
      },
      child: BlocBuilder<AttackTypeCubit, AttackTypeState>(
        builder: (context, attackType) {
          BlocProvider.of<BallLineCubit>(context)
              .newLine(Offset.zero, Offset.zero, false);
          BlocProvider.of<TypeBeatCubit>(context).emit(TypeBeatInitial());
          int? team = BlocProvider.of<TeamCubit>(context).team;
          print("team : " + team.toString());
          int? player = data['player'];
          int? breackPoint =
              BlocProvider.of<AttackTypeCubit>(context).breackpointNum;
          print("team : " + team.toString() + " player : " + player.toString());

          return WillPopScope(
            onWillPop: () async {
              print(" exited ");
              RemoteDataSourceGetLastMatch remoteDataSourceGetLastMatch =
                  RemoteDataSourceGetLastMatchFB();
              await remoteDataSourceGetLastMatch.removeLastPointFromStatics(
                  isRemoveWithoutDelatable: true);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: size.width * 0.05),
                      child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<ResetLineCubit>(context).reset();
                          },
                          child: TextCardSec(
                              taped: true,
                              width: size.width * 0.25,
                              text: lang!.newline)),
                    ),
                  ],
                  title: Text(
                    attackType is ReceptionState ||
                            attackType is AttackTypeInitial
                        ? lang.reception
                        : attackType is BreackPointState
                            ? breackPoint != 0
                                ? '${lang.breakPoint} Nr ${attackType.breakPoint}'
                                : lang.changeBall
                            : lang.reception,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.primaryColor),
                  )),
              backgroundColor: theme.colorScheme.primary,
              body: Container(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: BlocBuilder<ChoosePlayerCubit, ChoosePlayerState>(
                    builder: (context, playerChooseState) {
                      return Column(children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        BlocBuilder(
                          bloc: BlocProvider.of<BallLineCubit>(context),
                          builder: (context, state) {
                            return Container(
                                width: 300,
                                height: 150,
                                child: VolleyballField(
                                  isShowStatics: false,
                                  isBeat: true,
                                ));
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        BlocBuilder<ErrorsBeatsCubit, ErrorsBeatsState>(
                          builder: (context, beatError) {
                            return beatError is ErrorSatate
                                ? Container(
                                    width: size.width * 0.9,
                                    alignment: Alignment.center,
                                    height: size.height * 0.05,
                                    child: AutoSizeText(
                                      beatError.error,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ))
                                : SizedBox();
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          width: size.width * 0.35,
                          height: size.height * 0.03,
                          alignment: Alignment.center,
                          child: FittedBox(
                              child: Text(
                            attackType is ReceptionState ||
                                    attackType is AttackTypeInitial
                                ? lang.typeOfBeat
                                : lang.typeofriser,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                        Container(
                          width: size.width,
                          alignment: Alignment.center,
                          height: size.height * 0.08,
                          child: BlocBuilder<TypeBeatCubit, TypeBeatState>(
                            builder: (context, state) {
                              return BlocBuilder<RiserTypeCubit,
                                  RiserTypeState>(
                                builder: (context, riseState) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        attackType is ReceptionState ||
                                                attackType is AttackTypeInitial
                                            ? InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeBeat.changeBeatType(
                                                      HybirdState());
                                                },
                                                child: TextCardSec(
                                                    taped: state is HybirdState,
                                                    text: 'Hybird'))
                                            : InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeRise
                                                      .emit(QuickRiseState());
                                                },
                                                child: TextCardSec(
                                                    taped: riseState
                                                        is QuickRiseState,
                                                    text: lang.quick),
                                              ),
                                        attackType is ReceptionState ||
                                                attackType is AttackTypeInitial
                                            ? InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeBeat.changeBeatType(
                                                      JumpFloatState());
                                                },
                                                child: TextCardSec(
                                                    taped:
                                                        state is JumpFloatState,
                                                    text: '''Jump Float'''),
                                              )
                                            : InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeRise
                                                      .emit(BehindRiseState());
                                                },
                                                child: TextCardSec(
                                                    taped: riseState
                                                        is BehindRiseState,
                                                    text: lang.behind),
                                              ),
                                        attackType is ReceptionState ||
                                                attackType is AttackTypeInitial
                                            ? InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeBeat.changeBeatType(
                                                      JumpState());
                                                },
                                                child: TextCardSec(
                                                    taped: state is JumpState,
                                                    text: 'Jump'))
                                            : InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeRise
                                                      .emit(SuperRiseState());
                                                },
                                                child: TextCardSec(
                                                    taped: riseState
                                                        is SuperRiseState,
                                                    text: 'Super'),
                                              ),
                                        attackType is ReceptionState ||
                                                attackType is AttackTypeInitial
                                            ? InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeBeat.changeBeatType(
                                                      FloatState());
                                                },
                                                child: TextCardSec(
                                                    taped: state is FloatState,
                                                    text: 'Float'))
                                            : SizedBox(),
                                        attackType is ReceptionState ||
                                                attackType is AttackTypeInitial
                                            ? InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeBeat.changeBeatType(
                                                      NormaleState());
                                                },
                                                child: TextCardSec(
                                                    taped: state
                                                            is NormaleState ||
                                                        state
                                                            is TypeBeatInitial,
                                                    text: lang.normal),
                                              )
                                            : InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  typeRise
                                                      .emit(NormalRiseState());
                                                },
                                                child: TextCardSec(
                                                    taped: riseState
                                                            is NormalRiseState ||
                                                        riseState
                                                            is RiserTypeInitial,
                                                    text: lang.normal),
                                              )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  playerChooseState is FirstState
                                      ? BlocProvider.of<ChoosePlayerCubit>(
                                              context)
                                          .changePlayer(null, 3)
                                      : BlocProvider.of<ChoosePlayerCubit>(
                                              context)
                                          .changePlayer(
                                              team == 1
                                                  ? match.player3
                                                  : match.player1,
                                              1);
                                },
                                child: Playercard(
                                  player:
                                      team == 2 ? match.player1 : match.player3,
                                  taped: playerChooseState is FirstState,
                                )),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  playerChooseState is SecondState
                                      ? BlocProvider.of<ChoosePlayerCubit>(
                                              context)
                                          .changePlayer(null, 3)
                                      : BlocProvider.of<ChoosePlayerCubit>(
                                              context)
                                          .changePlayer(
                                              team == 1
                                                  ? match.player4
                                                  : match.player2,
                                              2);
                                },
                                child: Playercard(
                                  player:
                                      team == 2 ? match.player2 : match.player4,
                                  taped: playerChooseState is SecondState,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            attackType is ReceptionState ||
                                    attackType is AttackTypeInitial
                                ? InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      Player? playerSelected =
                                          BlocProvider.of<ChoosePlayerCubit>(
                                                  context)
                                              .player;
                                      bool? continuedLine =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .continued;

                                      Offset? p1 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .startPoint;
                                      Offset? p2 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .endPoint;
                                      String? type =
                                          BlocProvider.of<TypeBeatCubit>(
                                                  context)
                                              .typeBeat;

                                      playerSelected == null
                                          ? null
                                          : print("Player : " +
                                              playerSelected.team.toString() +
                                              playerSelected.player.toString());

                                      await BlocProvider.of<ErrorsBeatsCubit>(
                                              context)
                                          .cheack(
                                              attackTypeState: BreackPointState(
                                                  breakPoint: breackPoint,
                                                  player: player!,
                                                  team: team!),
                                              curentSet: currentSet,
                                              method: "Quickplus",
                                              stateName: "reception",
                                              player: playerSelected == null
                                                  ? null
                                                  : int.parse(
                                                      playerSelected.player),
                                              team: team == 1 ? 2 : 1,
                                              continuedLine: continuedLine,
                                              p1: p1,
                                              wittoutChangeBK: true,
                                              p2: p2,
                                              playerSelected: playerSelected,
                                              type: type,
                                              context: context);

                                      if (BlocProvider.of<ErrorsBeatsCubit>(
                                              context)
                                          .state is! ErrorSatate) {
                                        Player? playerSelected =
                                            BlocProvider.of<ChoosePlayerCubit>(
                                                    context)
                                                .player;
                                        bool? continuedLine =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .continued;

                                        Offset? p1 =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .startPoint;
                                        Offset? p2 =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .endPoint;
                                        String type =
                                            BlocProvider.of<TypeBeatCubit>(
                                                    context)
                                                .typeBeat;
                                        BlocProvider.of<ErrorsBeatsCubit>(
                                                context)
                                            .cheack(
                                                attackTypeState:
                                                    BreackPointState(
                                                        breakPoint: breackPoint,
                                                        player: player!,
                                                        team: team!),
                                                curentSet: currentSet,
                                                method: "plus",
                                                stateName: "reception",
                                                player: player,
                                                team: team,
                                                continuedLine: continuedLine,
                                                p1: p1,
                                                p2: p2,
                                                playerSelected: team == 1
                                                    ? player == 1
                                                        ? match.player1
                                                        : match.player2
                                                    : player == 1
                                                        ? match.player3
                                                        : match.player4,
                                                type: type,
                                                context: context);
                                      }
                                    },
                                    child: TextCardSec(
                                      taped: playerChooseState
                                          is ChoosePlayerInitial,
                                      text: '+',
                                      height: size.height * 0.1,
                                      font: 39,
                                      width: size.width * 0.4,
                                    ),
                                  )
                                : InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Player? playerSelected =
                                          BlocProvider.of<ChoosePlayerCubit>(
                                                  context)
                                              .player;
                                      bool? continuedLine =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .continued;

                                      Offset? p1 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .startPoint;
                                      Offset? p2 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .endPoint;
                                      RiserTypeState? type =
                                          BlocProvider.of<RiserTypeCubit>(
                                                  context)
                                              .state;

                                      String attackOption =
                                          BlocProvider.of<AttackOptionsCubit>(
                                                  context)
                                              .state
                                              .toString();
                                      BlocProvider.of<ErrorsBeatsCubit>(context)
                                          .cheack(
                                              attackTypeState: BreackPointState(
                                                  breakPoint: breackPoint,
                                                  player: player!,
                                                  team: team!),
                                              curentSet: currentSet,
                                              method: "replayableattack",
                                              attackOptions: attackOption,
                                              stateName: attackType.toString(),
                                              player: player,
                                              team: team,
                                              continuedLine: continuedLine,
                                              p1: p1,
                                              p2: p2,
                                              attackOption: attackOption,
                                              playerSelected: playerSelected,
                                              type: type is RiserTypeInitial
                                                  ? NormalRiseState().toString()
                                                  : type.toString(),
                                              context: context);
                                    },
                                    child: TextCardSec(
                                      taped: false,
                                      text: lang.replayableattack,
                                      height: size.height * 0.1,
                                      font: 39,
                                      width: size.width * 0.4,
                                    ),
                                  ),
                            SizedBox(
                              width: size.width * 0.1,
                            ),
                            attackType is ReceptionState ||
                                    attackType is AttackTypeInitial
                                ? InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      Player? playerSelected =
                                          BlocProvider.of<ChoosePlayerCubit>(
                                                  context)
                                              .player;
                                      bool? continuedLine =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .continued; 

                                      Offset? p1 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .startPoint;
                                      Offset? p2 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .endPoint;
                                      String? type =
                                          BlocProvider.of<TypeBeatCubit>(
                                                  context)
                                              .typeBeat;

                                      playerSelected == null
                                          ? null
                                          : print("Player : " +
                                              playerSelected.team.toString() +
                                              playerSelected.player.toString());

                                      await BlocProvider.of<ErrorsBeatsCubit>(
                                              context)
                                          .cheack(
                                              attackTypeState: BreackPointState(
                                                  breakPoint: breackPoint,
                                                  player: player!,
                                                  team: team!),
                                              curentSet: currentSet,
                                              method: "Quickminus",
                                              stateName: "reception",
                                              player: playerSelected == null
                                                  ? null
                                                  : int.parse(
                                                      playerSelected.player),
                                              team: team == 1 ? 2 : 1,
                                              continuedLine: continuedLine,
                                              p1: p1,
                                              wittoutChangeBK: true,
                                              p2: p2,
                                              playerSelected: playerSelected,
                                              type: type,
                                              context: context);

                                      if (BlocProvider.of<ErrorsBeatsCubit>(
                                              context)
                                          .state is! ErrorSatate) {
                                        Player? playerSelected =
                                            BlocProvider.of<ChoosePlayerCubit>(
                                                    context)
                                                .player;
                                        bool? continuedLine =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .continued;
                                        Offset? p1 =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .startPoint;
                                        Offset? p2 =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .endPoint;
                                        String type =
                                            BlocProvider.of<TypeBeatCubit>(
                                                    context)
                                                .typeBeat;
                                        await BlocProvider.of<ErrorsBeatsCubit>(
                                                context)
                                            .cheack(
                                                attackTypeState:
                                                    BreackPointState(
                                                        breakPoint: breackPoint,
                                                        player: player!,
                                                        team: team!),
                                                curentSet: currentSet,
                                                method: "minus",
                                                stateName: "reception",
                                                player: player,
                                                team: team,
                                                continuedLine: continuedLine,
                                                p1: p1,
                                                p2: p2,
                                                playerSelected: team == 1
                                                    ? player == 1
                                                        ? match.player1
                                                        : match.player2
                                                    : player == 1
                                                        ? match.player3
                                                        : match.player4,
                                                type: type,
                                                context: context);
                                      }
                                    },
                                    child: TextCardSec(
                                      taped: playerChooseState
                                          is ChoosePlayerInitial,
                                      text: '-',
                                      height: size.height * 0.1,
                                      font: 39,
                                      width: size.width * 0.4,
                                    ),
                                  )
                                : InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Player? playerSelected =
                                          BlocProvider.of<ChoosePlayerCubit>(
                                                  context)
                                              .player;
                                      bool continuedLine =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .continued;
                                      Offset? p1 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .startPoint;
                                      Offset? p2 =
                                          BlocProvider.of<BallLineCubit>(
                                                  context)
                                              .endPoint;
                                      RiserTypeState? type =
                                          BlocProvider.of<RiserTypeCubit>(
                                                  context)
                                              .state;

                                      String attackOption =
                                          BlocProvider.of<AttackOptionsCubit>(
                                                  context)
                                              .state
                                              .toString();
                                      BlocProvider.of<ErrorsBeatsCubit>(context)
                                          .cheack(
                                              attackTypeState: BreackPointState(
                                                  breakPoint: breackPoint,
                                                  player: player!,
                                                  team: team!),
                                              curentSet: currentSet,
                                              method: "defendedattack",
                                              attackOption: attackOption,
                                              attackOptions: attackOption,
                                              stateName: attackType.toString(),
                                              player: player,
                                              team: team == 1 ? 2 : 1,
                                              continuedLine: continuedLine,
                                              p1: p1,
                                              p2: p2,
                                              playerSelected: playerSelected,
                                              type: type is RiserTypeInitial
                                                  ? NormalRiseState().toString()
                                                  : type.toString(),
                                              context: context);
                                    },
                                    child: TextCardSec(
                                      taped: false,
                                      text: lang.defendedattack,
                                      height: size.height * 0.1,
                                      font: 39,
                                      width: size.width * 0.4,
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        attackType is ReceptionState ||
                                attackType is AttackTypeInitial
                            ? SizedBox()
                            : Container(
                                alignment: Alignment.center,
                                width: size.width,
                                height: size.height * 0.04,
                                child: Text(
                                  lang.options,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor),
                                ),
                              ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        BlocBuilder<AttackOptionsCubit, AttackOptionsState>(
                          builder: (context, attackOptions) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                attackType is ReceptionState ||
                                        attackType is AttackTypeInitial
                                    ? InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          Player? playerSelected = BlocProvider
                                                  .of<ChoosePlayerCubit>(
                                                      context)
                                              .player;
                                          bool? continuedLine =
                                              BlocProvider.of<BallLineCubit>(
                                                      context)
                                                  .continued;

                                          Offset? p1 =
                                              BlocProvider.of<BallLineCubit>(
                                                      context)
                                                  .startPoint;
                                          Offset? p2 =
                                              BlocProvider.of<BallLineCubit>(
                                                      context)
                                                  .endPoint;
                                          String type =
                                              BlocProvider.of<TypeBeatCubit>(
                                                      context)
                                                  .typeBeat;
                                          print("team : " + team.toString());

                                          await BlocProvider.of<ErrorsBeatsCubit>(
                                                  context)
                                              .cheack(
                                                  attackTypeState:
                                                      BreackPointState(
                                                          breakPoint:
                                                              breackPoint,
                                                          player: player!,
                                                          team: team!),
                                                  curentSet: currentSet,
                                                  method: "QuickAce",
                                                  stateName: "reception",
                                                  player: playerSelected == null
                                                      ? null
                                                      : int.parse(playerSelected
                                                          .player),
                                                  team: team == 1 ? 2 : 1,
                                                  continuedLine: continuedLine,
                                                  p1: p1,
                                                  p2: p2,
                                                  playerSelected:
                                                      playerSelected,
                                                  type: type,
                                                  context: context);

                                          if (BlocProvider.of<ErrorsBeatsCubit>(
                                                  context)
                                              .state is! ErrorSatate) {
                                            Player? playerSelected =
                                                BlocProvider.of<
                                                            ChoosePlayerCubit>(
                                                        context)
                                                    .player;
                                            bool? continuedLine =
                                                BlocProvider.of<BallLineCubit>(
                                                        context)
                                                    .continued;
                                            Offset? p1 =
                                                BlocProvider.of<BallLineCubit>(
                                                        context)
                                                    .startPoint;
                                            Offset? p2 =
                                                BlocProvider.of<BallLineCubit>(
                                                        context)
                                                    .endPoint;
                                            String? type =
                                                BlocProvider.of<TypeBeatCubit>(
                                                        context)
                                                    .typeBeat;
                                            BlocProvider.of<ErrorsBeatsCubit>(
                                                    context)
                                                .cheack(
                                                    attackTypeState:
                                                        BreackPointState(
                                                            breakPoint:
                                                                breackPoint,
                                                            player: player,
                                                            team: team),
                                                    curentSet: currentSet,
                                                    method: "immediateAce",
                                                    stateName: "reception",
                                                    player: player,
                                                    deletable: true,
                                                    team: team,
                                                    isimmediateAce: true,
                                                    continuedLine:
                                                        continuedLine,
                                                    p1: p1,
                                                    p2: p2,
                                                    playerSelected: team == 1
                                                        ? player == 1
                                                            ? match.player1
                                                            : match.player2
                                                        : player == 1
                                                            ? match.player3
                                                            : match.player4,
                                                    type: type,
                                                    context: context);
                                            playerSelected == null
                                                ? print("")
                                                : print(
                                                    "selected player : ${playerSelected.name}");

                                            BlocProvider.of<ErrorsBeatsCubit>(
                                                        context)
                                                    .state is ErrorsBeatsInitial
                                                ? Navigator.pop(
                                                    context, {'team': team})
                                                : null;
                                          }
                                        },
                                        child: TextCardSec(
                                          taped: playerChooseState
                                              is ChoosePlayerInitial,
                                          text: lang.immediateAce,
                                          height: size.height * 0.1,
                                          font: 25,
                                          width: size.width * 0.4,
                                        ),
                                      )
                                    : InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          BlocProvider.of<AttackOptionsCubit>(
                                                  context)
                                              .emit(DefededAttackState());
                                        },
                                        child: TextCardSec(
                                          taped: attackOptions
                                              is DefededAttackState,
                                          text: lang.attackondetachment,
                                          height: size.height * 0.1,
                                          font: 39,
                                          width: size.width * 0.4,
                                        ),
                                      ),
                                SizedBox(
                                  width: size.width * 0.1,
                                ),
                                attackType is ReceptionState ||
                                        attackType is AttackTypeInitial
                                    ? InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          Player? playerSelected = BlocProvider
                                                  .of<ChoosePlayerCubit>(
                                                      context)
                                              .player;
                                          bool? continuedLine =
                                              BlocProvider.of<BallLineCubit>(
                                                      context)
                                                  .continued;

                                          Offset? p1 =
                                              BlocProvider.of<BallLineCubit>(
                                                      context)
                                                  .startPoint;
                                          Offset? p2 =
                                              BlocProvider.of<BallLineCubit>(
                                                      context)
                                                  .endPoint;
                                          String type =
                                              BlocProvider.of<TypeBeatCubit>(
                                                      context)
                                                  .typeBeat;
                                          print("team : " + team.toString());
                                          await BlocProvider.of<ErrorsBeatsCubit>(
                                                  context)
                                              .cheack(
                                                  attackTypeState:
                                                      BreackPointState(
                                                          breakPoint:
                                                              breackPoint,
                                                          player: player!,
                                                          team: team!),
                                                  curentSet: currentSet,
                                                  method:
                                                      "QuickreceivingOtherFields",
                                                  stateName: "reception",
                                                  player: playerSelected == null
                                                      ? null
                                                      : int.parse(playerSelected
                                                          .player),
                                                  team: team == 1 ? 2 : 1,
                                                  continuedLine: continuedLine,
                                                  p1: p1,
                                                  p2: p2,
                                                  playerSelected:
                                                      playerSelected,
                                                  type: type,
                                                  context: context);

                                          if (BlocProvider.of<ErrorsBeatsCubit>(
                                                  context)
                                              .state is! ErrorSatate) {
                                            Player? playerSelected =
                                                BlocProvider.of<
                                                            ChoosePlayerCubit>(
                                                        context)
                                                    .player;
                                            bool? continuedLine =
                                                BlocProvider.of<BallLineCubit>(
                                                        context)
                                                    .continued;

                                            Offset? p1 =
                                                BlocProvider.of<BallLineCubit>(
                                                        context)
                                                    .startPoint;
                                            Offset? p2 =
                                                BlocProvider.of<BallLineCubit>(
                                                        context)
                                                    .endPoint;
                                            String? type =
                                                BlocProvider.of<TypeBeatCubit>(
                                                        context)
                                                    .typeBeat;
                                            BlocProvider.of<AttackTypeCubit>(
                                                    context)
                                                .newAttack(
                                              BreackPointState(
                                                  breakPoint: breackPoint,
                                                  player: player,
                                                  team: team),
                                            );
                                            BlocProvider.of<TeamCubit>(context)
                                                .changeTeam(team == 1 ? 2 : 1);
                                            BlocProvider.of<ErrorsBeatsCubit>(
                                                    context)
                                                .cheack(
                                                    attackTypeState:
                                                        BreackPointState(
                                                            breakPoint:
                                                                breackPoint,
                                                            player: player,
                                                            team: team),
                                                    curentSet: currentSet,
                                                    method:
                                                        "receivingOtherFields",
                                                    stateName: "reception",
                                                    player: player,
                                                    team: team == 1 ? 2 : 1,
                                                    continuedLine:
                                                        continuedLine,
                                                    p1: p1,
                                                    p2: p2,
                                                    playerSelected: team == 1
                                                        ? player == 1
                                                            ? match.player1
                                                            : match.player2
                                                        : player == 1
                                                            ? match.player3
                                                            : match.player4,
                                                    type: type,
                                                    context: context);
                                          }
                                        },
                                        child: TextCardSec(
                                          taped: playerChooseState
                                              is ChoosePlayerInitial,
                                          text: lang.receivingOtherFields,
                                          height: size.height * 0.1,
                                          width: size.width * 0.4,
                                        ),
                                      )
                                    : InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          BlocProvider.of<AttackOptionsCubit>(
                                                  context)
                                              .emit(SecondAttackState());
                                        },
                                        child: TextCardSec(
                                          taped: attackOptions
                                              is SecondAttackState,
                                          text: lang.attackonsecond,
                                          height: size.height * 0.1,
                                          font: 39,
                                          width: size.width * 0.4,
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        attackType is ReceptionState ||
                                attackType is AttackTypeInitial
                            ? BlocBuilder<ChoosePlayerCubit, ChoosePlayerState>(
                                builder: (context, state) {
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (state is ChoosePlayerInitial) {
                                        bool? continuedLine =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .continued;
                                        Offset? p1 =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .startPoint;
                                        Offset? p2 =
                                            BlocProvider.of<BallLineCubit>(
                                                    context)
                                                .endPoint;
                                        String? type =
                                            BlocProvider.of<TypeBeatCubit>(
                                                    context)
                                                .typeBeat;
                                        await BlocProvider.of<ErrorsBeatsCubit>(
                                                context)
                                            .cheack(
                                                attackTypeState:
                                                    BreackPointState(
                                                        breakPoint: breackPoint,
                                                        player: player!,
                                                        team: team!),
                                                curentSet: currentSet,
                                                method: "battingError",
                                                stateName: "reception",
                                                deletable: true,
                                                player: player,
                                                team: team,
                                                continuedLine: continuedLine,
                                                p1: p1,
                                                p2: p2,
                                                playerSelected: team == 1
                                                    ? player == 1
                                                        ? match.player1
                                                        : match.player2
                                                    : player == 1
                                                        ? match.player3
                                                        : match.player4,
                                                type: type,
                                                isbatting: true,
                                                context: context);
                                        BlocProvider.of<ErrorsBeatsCubit>(
                                                    context)
                                                .state is ErrorSatate
                                            ? null
                                            : team == 1
                                                ? Navigator.pop(
                                                    context, {'team': 2})
                                                : Navigator.pop(
                                                    context, {'team': 1});
                                      }
                                    },
                                    child: TextCardSec(
                                      taped: state is ChoosePlayerInitial
                                          ? false
                                          : true,
                                      text: lang.battingError,
                                      width: size.width * 0.4,
                                    ),
                                  );
                                },
                              )
                            : InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final data = await Navigator.pushNamed(
                                      context, endActionPageName,
                                      arguments: {
                                        "team": team!,
                                        "player": player,
                                        "currentSet": currentSet,
                                        "breackPoint": breackPoint,
                                        "match": match
                                      }) as Map?;

                                  data != null
                                      ? Navigator.pop(context, data)
                                      : null;
                                },
                                child: TextCardSec(
                                  taped: false,
                                  text: lang.endAction,
                                  height: size.height * 0.05,
                                  font: 39,
                                  width: size.width * 0.4,
                                ),
                              ),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

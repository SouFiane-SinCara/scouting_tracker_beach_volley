import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/list_rise_type_cubit/list_rise_type_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/last_match_cubit/last_match_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/player_select_statics_cubit/player_select_statics_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/sets_cubit/sets_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/table_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'table_data_state.dart';

class TableDataCubit extends Cubit<TableDataState> {
  TableDataCubit() : super(TableDataInitial());
  void update(
    AcctionsPlayState acctionsPlayState,
    BuildContext context,
  ) {
    emit(TableDataInitial());
    AppLocalizations? lang = AppLocalizations.of(context);

    if (acctionsPlayState is BeatState ||
        acctionsPlayState is AcctionsPlayInitial) {
      List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;

      AMatch match = BlocProvider.of<LastMatchCubit>(context).aMatch!;
      List<Player> players = [];
      if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
          '${match.player1.surname} / ${match.player2.surname}') {
        players = [
          match.player1,
          match.player2,
        ];
      } else if (BlocProvider.of<PlayerSelectStaticsCubit>(context)
              .playersurname ==
          '${match.player3.surname} / ${match.player4.surname}') {
        players = [
          match.player3,
          match.player4,
        ];
      } else {
        players = [
          match.player1,
          match.player2,
          match.player3,
          match.player4,
        ];
      }
      List<RowDataModel> rowDataModel = [];
      int tothashtag = 0;
      int totplus = 0;
      int totminus = 0;
      int totequal = 0;
      int totaleBeat = 0;
      for (var player in players) {
        int hashtag = 0;
        int plus = 0;
        int minus = 0;
        int equal = 0;
        int tot = 0;

        for (var element in beats) {
          int? curentSet = BlocProvider.of<SetsCubit>(context).currentSet;
          if (curentSet == null || curentSet == element.currentSet) {
            if (element.type ==
                    BlocProvider.of<ListRiseTypeCubit>(context).rise ||
                BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                    'select rise' ||
                BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                    lang!.selectrise) {
              if (player.surname == element.playersurname) {
                print("beat: " + element.method);
                if (element.state == 'reception' &&
                    element.method != "Quickplus" &&
                    element.method != "Quickminus"&&
                    element.method != "QuickAce"&&
                    element.method != "QuickreceivingOtherFields" 
                    
                    ) {
                  print("beats: " + element.method);

                  tot++;
                  if (element.method == 'immediateAce') {
                    hashtag++;
                  } else if (element.method == 'minus' ||
                      element.method == 'receivingOtherFields') {
                    plus++;
                  } else if (element.method == 'plus') {
                    minus++;
                  } else if (element.method == 'battingError') {
                    equal++;
                  }
                }
              }
            }
          }
        }
        totaleBeat += tot;
        totequal += equal;
        totplus += plus;
        totminus += minus;
        tothashtag += hashtag;

        rowDataModel.add(RowDataModel(
            equal: tot != 0
                ? [equal.toString(), "${((equal / tot) * 100).toInt()} %"]
                : ['0', '0 %'],
            total: tot,
            hashtag: tot != 0
                ? [hashtag.toString(), "${((hashtag / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            minus: tot != 0
                ? [minus.toString(), "${((minus / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            playerAllName: player.name + " " + player.surname,
            plus: tot != 0
                ? [plus.toString(), "${((plus / tot) * 100).floor()} %"]
                : ['0', '0 %']));
      }

      rowDataModel.add(RowDataModel(
          equal: totaleBeat != 0
              ? [
                  totequal.toString(),
                  "${((totequal / totaleBeat) * 100).toInt()} %"
                ]
              : ['0', '0 %'],
          total: totaleBeat,
          hashtag: totaleBeat != 0
              ? [
                  tothashtag.toString(),
                  "${((tothashtag / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          minus: totaleBeat != 0
              ? [
                  totminus.toString(),
                  "${((totminus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          playerAllName: 'total',
          plus: totaleBeat != 0
              ? [
                  totplus.toString(),
                  "${((totplus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %']));
      emit(LoadedTableDataState(rowDataModels: rowDataModel));
    } else if (acctionsPlayState is ChangeBallAcctionState ||
        acctionsPlayState is BreakPointState) {
      List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;

      AMatch match = BlocProvider.of<LastMatchCubit>(context).aMatch!;
      List<Player> players = [];
      if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
          '${match.player1.surname} / ${match.player2.surname}') {
        players = [
          match.player1,
          match.player2,
        ];
      } else if (BlocProvider.of<PlayerSelectStaticsCubit>(context)
              .playersurname ==
          '${match.player3.surname} / ${match.player4.surname}') {
        players = [
          match.player3,
          match.player4,
        ];
      } else {
        players = [
          match.player1,
          match.player2,
          match.player3,
          match.player4,
        ];
      }
      List<RowDataModel> rowDataModel = [];
      int tothashtag = 0;
      int totplus = 0;
      int totminus = 0;
      int totequal = 0;
      int totaleBeat = 0;
      for (var player in players) {
        int hashtag = 0;
        int plus = 0;
        int minus = 0;
        int equal = 0;
        int tot = 0;
        int index = 0;
        for (var element in beats) {
          int? curentSet = BlocProvider.of<SetsCubit>(context).currentSet;
          if (curentSet == null || curentSet == element.currentSet) {
            if (element.type ==
                    BlocProvider.of<ListRiseTypeCubit>(context).rise ||
                BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                    'select rise' ||
                BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                    lang!.selectrise) {
                      
              if (player.surname == element.playersurname) {
                if (((element.state == 'BreackPointState()' || element.state == 'BreackPointState') &&
                        element.breackpointNum == 0 &&
                        element.method != 'WallAttackBK' &&
                        acctionsPlayState is ChangeBallAcctionState) ||
                        (element.method== "WallAttackBK" && acctionsPlayState is BreakPointState)||
                    ((element.state == 'BreackPointState()' || element.state == 'BreackPointState') &&
                        element.breackpointNum != 0 &&
                        
                        acctionsPlayState is BreakPointState)
                        
                        || ((element.method =="QuickreceivingOtherFields" ||element.method =='QuickAce' ) &&  acctionsPlayState is ChangeBallAcctionState)
                        ) {
                          print("method :${element.method}");
                  tot++;
                  if (element.method == "attachmentPointBK" || 
                      element.method == 'WallAttackBK') { 
                    hashtag++;
                  } else if (element.method == 'replayableattack') {
                    plus++;
                  } else if (element.method == 'defendedattack' || element.method == 'QuickreceivingOtherFields') {
                    minus++;
                  } else if (element.method == 'attackErrorBK' || element.method == 'QuickAce' || element.method == "errorRaisedBK") {
                    equal++;
                  }
                }
              }
            }
          }
          index++;

        }
        totaleBeat += tot;
        totequal += equal;
        totplus += plus;
        totminus += minus;
        tothashtag += hashtag;

        rowDataModel.add(RowDataModel(
            equal: tot != 0
                ? [equal.toString(), "${((equal / tot) * 100).toInt()} %"]
                : ['0', '0 %'],
            total: tot,
            hashtag: tot != 0
                ? [hashtag.toString(), "${((hashtag / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            minus: tot != 0
                ? [minus.toString(), "${((minus / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            playerAllName: player.name + " " + player.surname,
            plus: tot != 0
                ? [plus.toString(), "${((plus / tot) * 100).floor()} %"]
                : ['0', '0 %']));
      }

      rowDataModel.add(RowDataModel(
          equal: totaleBeat != 0
              ? [
                  totequal.toString(),
                  "${((totequal / totaleBeat) * 100).toInt()} %"
                ]
              : ['0', '0 %'],
          total: totaleBeat,
          hashtag: totaleBeat != 0
              ? [
                  tothashtag.toString(),
                  "${((tothashtag / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          minus: totaleBeat != 0
              ? [
                  totminus.toString(),
                  "${((totminus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          playerAllName: 'total',
          plus: totaleBeat != 0
              ? [
                  totplus.toString(),
                  "${((totplus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %']));
      emit(LoadedTableDataState(rowDataModels: rowDataModel));
    } else if (acctionsPlayState is ReceptionState) {
      List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;

      AMatch match = BlocProvider.of<LastMatchCubit>(context).aMatch!;
      List<Player> players = [];
      if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
          '${match.player1.surname} / ${match.player2.surname}') {
        players = [
          match.player1,
          match.player2,
        ];
      } else if (BlocProvider.of<PlayerSelectStaticsCubit>(context)
              .playersurname ==
          '${match.player3.surname} / ${match.player4.surname}') {
        players = [
          match.player3,
          match.player4,
        ];
      } else {
        players = [
          match.player1,
          match.player2,
          match.player3,
          match.player4,
        ];
      }
      List<RowDataModel> rowDataModel = [];
      int tothashtag = 0;
      int totplus = 0;
      int totminus = 0;
      int totequal = 0;
      int totaleBeat = 0;
      for (var player in players) {
        int hashtag = 0;
        int plus = 0;
        int minus = 0;
        int equal = 0;
        int tot = 0;

        for (var element in beats) {
          int? curentSet = BlocProvider.of<SetsCubit>(context).currentSet;
          if (curentSet == null || curentSet == element.currentSet) {
            if (element.type ==
                    BlocProvider.of<ListRiseTypeCubit>(context).rise ||
                BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                    'select rise' ||
                BlocProvider.of<ListRiseTypeCubit>(context).rise ==
                    lang!.selectrise) {
              if (player.surname == element.playersurname) {
                if (element.state == 'reception') {
                  if (element.method == 'QuickAce') {
                    tot++;

                    equal++;
                  } else if (element.method == 'Quickminus' ||
                      element.method == 'QuickreceivingOtherFields') {
                    tot++;

                    minus++;
                  } else if (element.method == 'Quickplus') {
                    tot++;

                    plus++;
                  }
                }
              }
            }
          }
        }
        totaleBeat += tot;
        totequal += equal;
        totplus += plus;
        totminus += minus;
        tothashtag += hashtag;

        rowDataModel.add(RowDataModel(
            equal: tot != 0
                ? [equal.toString(), "${((equal / tot) * 100).toInt()} %"]
                : ['0', '0 %'],
            total: tot,
            hashtag: tot != 0
                ? [hashtag.toString(), "${((hashtag / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            minus: tot != 0
                ? [minus.toString(), "${((minus / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            playerAllName: player.name + " " + player.surname,
            plus: tot != 0
                ? [plus.toString(), "${((plus / tot) * 100).floor()} %"]
                : ['0', '0 %']));
      }

      rowDataModel.add(RowDataModel(
          equal: totaleBeat != 0
              ? [
                  totequal.toString(),
                  "${((totequal / totaleBeat) * 100).toInt()} %"
                ]
              : ['0', '0 %'],
          total: totaleBeat,
          hashtag: totaleBeat != 0
              ? [
                  tothashtag.toString(),
                  "${((tothashtag / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          minus: totaleBeat != 0
              ? [
                  totminus.toString(),
                  "${((totminus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          playerAllName: 'total',
          plus: totaleBeat != 0
              ? [
                  totplus.toString(),
                  "${((totplus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %']));
      emit(LoadedTableDataState(rowDataModels: rowDataModel));
    } else if (acctionsPlayState is WallState) {
      List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;

      AMatch match = BlocProvider.of<LastMatchCubit>(context).aMatch!;
      List<Player> players = [];
      if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
          '${match.player1.surname} / ${match.player2.surname}') {
        players = [
          match.player1,
          match.player2,
        ];
      } else if (BlocProvider.of<PlayerSelectStaticsCubit>(context)
              .playersurname ==
          '${match.player3.surname} / ${match.player4.surname}') {
        players = [
          match.player3,
          match.player4,
        ];
      } else {
        players = [
          match.player1,
          match.player2,
          match.player3,
          match.player4,
        ];
      }
      List<RowDataModel> rowDataModel = [];
      int tothashtag = 0;
      int totplus = 0;
      int totminus = 0;
      int totequal = 0;
      int totaleBeat = 0;
      for (var player in players) {
        int hashtag = 0;
        int plus = 0;
        int minus = 0;
        int equal = 0;
        int tot = 0;
        List<String> offsets = [];
        for (var element in beats) {
          int? curentSet = BlocProvider.of<SetsCubit>(context).currentSet;
          if (curentSet == null || curentSet == element.currentSet) {
            if (player.surname == element.playersurname) {
              if (element.method == 'WallAttackBK') {
                tot++;
              }
            }
          }
        }
        totaleBeat += tot;
        totequal += equal;
        totplus += plus;
        totminus += minus;
        tothashtag += hashtag;

        rowDataModel.add(RowDataModel(
            equal: tot != 0
                ? [equal.toString(), "${((equal / tot) * 100).toInt()} %"]
                : ['0', '0 %'],
            total: tot,
            hashtag: tot != 0
                ? [hashtag.toString(), "${((hashtag / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            minus: tot != 0
                ? [minus.toString(), "${((minus / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            playerAllName: player.name + " " + player.surname,
            plus: tot != 0
                ? [plus.toString(), "${((plus / tot) * 100).floor()} %"]
                : ['0', '0 %']));
      }

      rowDataModel.add(RowDataModel(
          equal: totaleBeat != 0
              ? [
                  totequal.toString(),
                  "${((totequal / totaleBeat) * 100).toInt()} %"
                ]
              : ['0', '0 %'],
          total: totaleBeat,
          hashtag: totaleBeat != 0
              ? [
                  tothashtag.toString(),
                  "${((tothashtag / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          minus: totaleBeat != 0
              ? [
                  totminus.toString(),
                  "${((totminus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          playerAllName: 'total',
          plus: totaleBeat != 0
              ? [
                  totplus.toString(),
                  "${((totplus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %']));
      emit(LoadedTableDataState(rowDataModels: rowDataModel));
    } else if (acctionsPlayState is AttackOnDetachmentState ||
        acctionsPlayState is AttackOftwoState) {
      List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;

      AMatch match = BlocProvider.of<LastMatchCubit>(context).aMatch!;
      List<Player> players = [];
      if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
          '${match.player1.surname} / ${match.player2.surname}') {
        players = [
          match.player1,
          match.player2,
        ];
      } else if (BlocProvider.of<PlayerSelectStaticsCubit>(context)
              .playersurname ==
          '${match.player3.surname} / ${match.player4.surname}') {
        players = [
          match.player3,
          match.player4,
        ];
      } else {
        players = [
          match.player1,
          match.player2,
          match.player3,
          match.player4,
        ];
      }
      List<RowDataModel> rowDataModel = [];
      int tothashtag = 0;
      int totplus = 0;
      int totminus = 0;
      int totequal = 0;
      int totaleBeat = 0;
      for (var player in players) {
        int hashtag = 0;
        int plus = 0;
        int minus = 0;
        int equal = 0;
        int tot = 0;
        
        for (var element in beats) {
          int? curentSet = BlocProvider.of<SetsCubit>(context).currentSet;
          if (curentSet == null || curentSet == element.currentSet) {
            if (player.surname == element.playersurname) {
              if (((element.attackOption == "SecondAttackState()" || element.attackOption == "SecondAttackState")  &&
                      acctionsPlayState is AttackOftwoState) ||
                  ((element.attackOption == "DefededAttackState()" || element.attackOption == "DefededAttackState") &&
                      acctionsPlayState is AttackOnDetachmentState)) {
                tot++;
                if (element.method == 'attachmentPointBK') {
                  hashtag++;
                } else if (element.method == 'replayableattack') {
                  plus++;
                } else if (element.method == 'defendedattack') {
                  minus++;
                } else if (element.method == 'attackErrorBK' ||
                    element.method == 'WallAttackBK') {
                  equal++;
                }
              }
            }
          }
        }
        totaleBeat += tot;
        totequal += equal;
        totplus += plus;
        totminus += minus;
        tothashtag += hashtag;

        rowDataModel.add(RowDataModel(
            equal: tot != 0
                ? [equal.toString(), "${((equal / tot) * 100).toInt()} %"]
                : ['0', '0 %'],
            total: tot,
            hashtag: tot != 0
                ? [hashtag.toString(), "${((hashtag / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            minus: tot != 0
                ? [minus.toString(), "${((minus / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            playerAllName: player.name + " " + player.surname,
            plus: tot != 0
                ? [plus.toString(), "${((plus / tot) * 100).floor()} %"]
                : ['0', '0 %']));
      }

      rowDataModel.add(RowDataModel(
          equal: totaleBeat != 0
              ? [
                  totequal.toString(),
                  "${((totequal / totaleBeat) * 100).toInt()} %"
                ]
              : ['0', '0 %'],
          total: totaleBeat,
          hashtag: totaleBeat != 0
              ? [
                  tothashtag.toString(),
                  "${((tothashtag / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          minus: totaleBeat != 0
              ? [
                  totminus.toString(),
                  "${((totminus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          playerAllName: 'total',
          plus: totaleBeat != 0
              ? [
                  totplus.toString(),
                  "${((totplus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %']));
      emit(LoadedTableDataState(rowDataModels: rowDataModel));
    } else if (acctionsPlayState is ErrorsState) {
      List<BeatAction> beats = BlocProvider.of<GetBeatsCubit>(context).beats;

      AMatch match = BlocProvider.of<LastMatchCubit>(context).aMatch!;
      List<Player> players = [];
      if (BlocProvider.of<PlayerSelectStaticsCubit>(context).playersurname ==
          '${match.player1.surname} / ${match.player2.surname}') {
        players = [
          match.player1,
          match.player2,
        ];
      } else if (BlocProvider.of<PlayerSelectStaticsCubit>(context)
              .playersurname ==
          '${match.player3.surname} / ${match.player4.surname}') {
        players = [
          match.player3,
          match.player4,
        ];
      } else {
        players = [
          match.player1,
          match.player2,
          match.player3,
          match.player4,
        ];
      }
      List<RowDataModel> rowDataModel = [];
      int tothashtag = 0;
      int totplus = 0;
      int totminus = 0;
      int totequal = 0;
      int totaleBeat = 0;
      for (var player in players) {
        int hashtag = 0;
        int plus = 0;
        int minus = 0;
        int equal = 0;
        int tot = 0;
        List<String> offsets = [];
        for (var element in beats) {
          int? curentSet = BlocProvider.of<SetsCubit>(context).currentSet;
          if (curentSet == null || curentSet == element.currentSet) {
            if (player.surname == element.playersurname) {
              if (element.method == 'battingError') {
                tot++;
                minus++;
              } else if (element.method == 'attackErrorBK' &&
                  element.breackpointNum == 0) {
                hashtag++;
                tot++;
              } else if (element.method == 'attackErrorBK' &&
                  element.breackpointNum != 0) {
                plus++;
                tot++;
              }
            }
          }
        }
        totaleBeat += tot;
        totequal += equal;
        totplus += plus;
        totminus += minus;
        tothashtag += hashtag;

        rowDataModel.add(RowDataModel(
            equal: tot != 0
                ? [equal.toString(), "${((equal / tot) * 100).toInt()} %"]
                : ['0', '0 %'],
            total: tot,
            hashtag: tot != 0
                ? [hashtag.toString(), "${((hashtag / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            minus: tot != 0
                ? [minus.toString(), "${((minus / tot) * 100).floor()} %"]
                : ['0', '0 %'],
            playerAllName: player.name + " " + player.surname,
            plus: tot != 0
                ? [plus.toString(), "${((plus / tot) * 100).floor()} %"]
                : ['0', '0 %']));
      }

      rowDataModel.add(RowDataModel(
          equal: totaleBeat != 0
              ? [
                  totequal.toString(),
                  "${((totequal / totaleBeat) * 100).toInt()} %"
                ]
              : ['0', '0 %'],
          total: totaleBeat,
          hashtag: totaleBeat != 0
              ? [
                  tothashtag.toString(),
                  "${((tothashtag / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          minus: totaleBeat != 0
              ? [
                  totminus.toString(),
                  "${((totminus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %'],
          playerAllName: 'total',
          plus: totaleBeat != 0
              ? [
                  totplus.toString(),
                  "${((totplus / totaleBeat) * 100).floor()} %"
                ]
              : ['0', '0 %']));
      emit(LoadedTableDataState(rowDataModels: rowDataModel));
    }
  }
}

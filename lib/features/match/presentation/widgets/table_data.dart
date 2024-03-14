// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/table_data_cubit/table_data_cubit.dart';

class MyTable extends StatelessWidget {
  final bool? noHashtag;
  final bool? wall;
  final bool? isError;
  const MyTable({Key? key, this.noHashtag, this.wall, this.isError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations? lang = AppLocalizations.of(context);
    Size size = device(context);
    DataColumn treeWidgetDatatable(
        String top, String bottomLeft, String bottomRight) {
      return DataColumn(
        label: Container(
          padding: EdgeInsets.zero, // Set padding to zero
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(top),
              Row(
                children: [
                  Container(
                    color: theme.primaryColor,
                    height: 2,
                    width: size.width * 0.22,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: size.width * 0.05,
                    height: 20,
                    child: FittedBox(
                      child: Text(bottomLeft),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 25,
                      width: 1,
                      color: theme.primaryColor,
                    ),
                  ),
                  Container(
                    width: size.width * 0.05,
                    height: 20,
                    child: FittedBox(
                      child: Text(bottomRight),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    DataCell towCell(String left, String right) {
      return DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: size.width * 0.05,
            height: 20,
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                left,
                style: TextStyle(
                    color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 25,
              width: 1,
              color: theme.primaryColor,
            ),
          ),
          Container(
            width: size.width * 0.05,
            height: 20,
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                right,
                style: TextStyle(
                    color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ));
    }

    return Container(
      width: size.width,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: size.height * 0.05),
      height: size.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<TableDataCubit, TableDataState>(
          builder: (context, state) {
            if (state is LoadedTableDataState) {
              AcctionsPlayState acctionsPlayState =
                  BlocProvider.of<AcctionsPlayCubit>(context).state;
              return DataTable(
                  horizontalMargin: 0,
                  border: TableBorder.all(
                      color: theme.primaryColor,
                      width: 2,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  columnSpacing: 0,
                  columns: [
                    DataColumn(
                        label: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(lang!.players)))),
                    DataColumn(
                        label: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01),
                            child: Text(wall == null && isError == null
                                ? acctionsPlayState is ChangeBallAcctionState
                                    ? lang.changeballTotale
                                    : acctionsPlayState is BreakPointState
                                        ? lang.breakPointtotale
                                        : acctionsPlayState is ReceptionState
                                            ? lang.receptiontotale
                                            : acctionsPlayState is AttackOftwoState||  acctionsPlayState is AttackOnDetachmentState? lang.totAttack:lang.totalBeat
                                : isError != null
                                    ? lang.battingError
                                    : lang.wall))),
                    noHashtag == null && wall == null && isError == null
                        ? treeWidgetDatatable('#', "Nr.", "%")
                        : isError != null
                            ? DataColumn(
                                label: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.01),
                                    child: Text(lang.errorChangeBall)))
                            : DataColumn(label: SizedBox()),
                    wall == null && isError == null
                        ? treeWidgetDatatable('+', "Nr.", "%")
                        : isError != null
                            ? DataColumn(
                                label: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.01),
                                    child: Text(lang.errorBreackPoint)))
                            : DataColumn(label: SizedBox()),
                    wall == null && isError == null
                        ? treeWidgetDatatable('-', "Nr.", "%")
                        : DataColumn(label: SizedBox()),
                    wall == null && isError == null
                        ? treeWidgetDatatable('=', "Nr.", "%")
                        : DataColumn(label: SizedBox()),
                  ],
                  rows: List.generate(
                      state.rowDataModels.length,
                      (index) => DataRow(cells: [
                            DataCell(Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  state.rowDataModels[index].playerAllName,
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))),
                            DataCell(Center(
                                child: Text(
                              isError == null
                                  ? state.rowDataModels[index].total.toString()
                                  : state.rowDataModels[index].minus[0]
                                      .toString(),
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ))),
                            noHashtag == null && wall == null && isError == null
                                ? towCell(state.rowDataModels[index].hashtag[0],
                                    state.rowDataModels[index].hashtag[1])
                                : isError != null
                                    ? DataCell(Center(
                                        child: Text(
                                        state.rowDataModels[index].hashtag[0],
                                        style: TextStyle(
                                            color: theme.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      )))
                                    : DataCell(SizedBox()),
                            wall == null && isError == null
                                ? towCell(state.rowDataModels[index].plus[0],
                                    state.rowDataModels[index].plus[1])
                                : isError != null
                                    ? DataCell(Center(
                                        child: Text(
                                        state.rowDataModels[index].plus[0],
                                        style: TextStyle(
                                            color: theme.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      )))
                                    : DataCell(SizedBox()),
                            wall == null && isError == null
                                ? towCell(state.rowDataModels[index].minus[0],
                                    state.rowDataModels[index].minus[1])
                                : DataCell(SizedBox()),
                            wall == null && isError == null
                                ? towCell(state.rowDataModels[index].equal[0],
                                    state.rowDataModels[index].equal[1])
                                : DataCell(SizedBox()),
                          ])));
            } else {
              return Container(
                  width: size.width,
                  height: size.height,
                  color: theme.colorScheme.primary,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: theme.primaryColor,
                  ));
            }
          },
        ),
      ),
    );
  }
}

class RowDataModel {
  final List<String> hashtag;
  final List<String> plus;
  final List<String> minus;
  final List<String> equal;
  final int total;
  final String playerAllName;
  RowDataModel(
      {required this.equal,
      required this.total,
      required this.hashtag,
      required this.minus,
      required this.playerAllName,
      required this.plus});
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/table_data_cubit/table_data_cubit.dart';

import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/table_data.dart';

class BeatStatistics extends StatelessWidget {
  final bool ? isReception;
  const BeatStatistics({
    Key? key,
    this.isReception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

   isReception == null? BlocProvider.of<TableDataCubit>(context)
        .update(BeatState(), context,): BlocProvider.of<TableDataCubit>(context)
        .update(ReceptionState(), context,);
    return MyTable(noHashtag: isReception,);
  }
}

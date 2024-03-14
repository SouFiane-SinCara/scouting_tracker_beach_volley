import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/action_play_cubit/acctions_play_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/table_data_cubit/table_data_cubit.dart';

import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/table_data.dart';

class WallStatistic extends StatelessWidget {
  const WallStatistic({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TableDataCubit>(context)
        .update(WallState(), context,); 
    return MyTable(wall: true,);
  }
}
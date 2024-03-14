import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/change_ball_statics/change_ball_graphic.dart';

class BreackPOintGraphic extends StatelessWidget {
  const BreackPOintGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeBallGraphic(
      isBreakPoint: true, 
    );
  }
}

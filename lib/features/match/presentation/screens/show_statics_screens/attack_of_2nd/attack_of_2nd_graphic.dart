import 'package:flutter/material.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/screens/show_statics_screens/attack_on_detachment/attack_on_detachment_graphic.dart';

class AttackOf2ndGraphic extends StatelessWidget {
  const AttackOf2ndGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return AttackOnDetachmentGraphic(
      isAttackOftwoState: true,
    );
  }
}

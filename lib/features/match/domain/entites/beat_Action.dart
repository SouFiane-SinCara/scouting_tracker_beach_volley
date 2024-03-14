// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';

class BeatAction extends Equatable {
  final String state;
  final int currentSet;
  final String method;
  final Player player;
  final int breackpointNum;
  final String type;
  final Offset p1;
  final Offset p2;
  final String ?attackOption;
  final bool continued;
  final bool ? deletable;
  final int playerNumber;
  final int playerTeam;
  final String playersurname;
  const BeatAction({
    required this.state,
    required this.currentSet,
    required this.method,
    this.deletable,
    this.attackOption,
    required this.player,
    required this.breackpointNum,
    required this.type,
    required this.p1,
    required this.p2,
    required this.continued,
    required this.playerNumber,
    required this.playerTeam,
    required this.playersurname,
  });

  @override
  List<Object?> get props => [state, method, player, type];
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:azlistview/azlistview.dart';

import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';

class AZPlayers extends ISuspensionBean {
  Player player;
  String tag;
  AZPlayers({
    required this.player,
    required this.tag,
  });

  @override
  String getSuspensionTag() => this.tag;
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/features/all/domain/entites/player.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/rouand.dart';

class AMatch extends Equatable {
  final String date;
  final String description;
  final String location;
  final String title;
  final Player player1;
  final Player player2;
  final Player player3;
  final Player player4;
   int ?wind;
  final Account account;
  final bool? finished;

  final List<Rouand>? rouands;
   AMatch(
      {required this.date,
       this.wind,
      required this.description,
      required this.location,
      required this.title,
      required this.player1,
      required this.player2,
      required this.player3,
      required this.player4,
      required this.account,
      this.rouands,
      this.finished});

  @override
  List<Object?> get props => [
        date,
        description,
        location,
        title,
        account,
        player1,
        player2,
        player3,
        player4
      ];
}

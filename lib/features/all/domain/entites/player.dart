// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:scouting_tracker_beach_volley/features/auth/domain/entits/account.dart';

class Player extends Equatable {
  final String name;
  final String surname;
  final String image;
  final String gender;
  final String strongHand;
  final String? tournamentTitle;
  final String? dateLocation;
  final String team;
  final String player;
  final Account account;
  
  final String note;
  const  Player({
    required this.name,
    required this.surname,
    required this.image,
    required this.gender,
    required this.strongHand,
    required this.tournamentTitle,
    required this.dateLocation,
    required this.team,
    required this.player,
    required this.account,
    required this.note,
  });

  @override
  List<Object?> get props => [name, surname, gender, strongHand, note, image];
}

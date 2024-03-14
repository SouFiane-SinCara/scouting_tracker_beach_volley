// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'saved_match_cubit.dart';

sealed class SavedMatchState extends Equatable {
  const SavedMatchState();

  @override
  List<Object> get props => [];
}

final class SavedMatchInitial extends SavedMatchState {}

class TournamentsPlayersState extends SavedMatchState {}

class TournamentsState extends SavedMatchState {
  final List<String> tournaments;
  const TournamentsState({
    required this.tournaments,
  });
}

class LocationsDateState extends SavedMatchState {
  final List<Map> locationDate;
  final String tournamentTitle;
  const LocationsDateState({
    required this.tournamentTitle,
    required this.locationDate,
  });
}
class MatchesState extends SavedMatchState {
  final List<AMatch> matches;
  const MatchesState({
    required this.matches,
  });
}

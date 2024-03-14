part of 'match_cubit.dart';

sealed class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

final class MatchInitial extends MatchState {}

final class LoadedMatchesState extends MatchState {
  final List<AMatch> matches;
  const LoadedMatchesState({required this.matches});
}

final class ErrorMatchesState extends MatchState {
  final String error;
  const ErrorMatchesState({required this.error});
}
final class EmpityMatchesState extends MatchState{
  
}
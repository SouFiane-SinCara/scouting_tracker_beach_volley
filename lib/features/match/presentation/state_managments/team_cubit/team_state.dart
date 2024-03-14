part of 'team_cubit.dart';

sealed class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object> get props => [];
}

final class TeamInitial extends TeamState {}
class RedTeamState extends TeamState{}
class BlueTeamState extends TeamState{}
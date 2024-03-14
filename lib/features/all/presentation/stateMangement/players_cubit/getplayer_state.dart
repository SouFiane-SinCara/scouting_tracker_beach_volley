part of 'getplayer_cubit.dart';

sealed class GetplayerState extends Equatable {
  const GetplayerState();

  @override
  List<Object> get props => [];
}

final class GetplayerInitial extends GetplayerState {}

final class AddedPlayerState extends GetplayerState {}

final class ErrorPlayerState extends GetplayerState {}

final class EmpityPlayerState extends GetplayerState {}

final class LoadedPlayerState extends GetplayerState {
  final List<Player> players;
  const LoadedPlayerState({required this.players});
}


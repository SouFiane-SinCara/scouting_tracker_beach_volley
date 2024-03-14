part of 'connection_bloc.dart';

class ConnectionsState extends Equatable {
  const ConnectionsState();

  @override
  List<Object> get props => [];
}

final class ConnectionInitial extends ConnectionsState {}

class ConnectedState extends ConnectionsState {}

class DisconnectedState extends ConnectionsState {}

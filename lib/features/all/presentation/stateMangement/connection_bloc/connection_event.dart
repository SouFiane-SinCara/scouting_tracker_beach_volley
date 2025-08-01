part of 'connection_bloc.dart';

sealed class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object> get props => [];
}

class ConnectedEvent extends ConnectionEvent{}
class DisconnectedEvent extends ConnectionEvent{}

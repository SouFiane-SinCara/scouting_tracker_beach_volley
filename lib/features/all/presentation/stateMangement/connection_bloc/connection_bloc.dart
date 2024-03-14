import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionsState> {
  StreamSubscription? streamSubscription;
  ConnectionBloc() : super(ConnectionInitial()) {
    on<ConnectionEvent>((event, emit) {
      emit(ConnectionInitial());
      if (event is ConnectedEvent) {
        emit(ConnectedState());
      } else if (event is DisconnectedEvent) {
        emit(DisconnectedState());
      }
    });

    streamSubscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        add(DisconnectedEvent());
      } else {
        add(ConnectedEvent());
      }
    });
  }
}

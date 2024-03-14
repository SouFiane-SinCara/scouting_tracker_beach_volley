import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'invert_state.dart';

class InvertCubit extends Cubit<InvertState> {
  bool inverted = false;
  bool blueInverted = false;
  bool redInverted = false;
  InvertCubit() : super(InvertInitial());
  void invertMatch() {
    emit(InvertInitial());
    redInverted = !redInverted;
    blueInverted = !blueInverted;

    inverted = !inverted;
    emit(InvertNewState(
        blueInverted: blueInverted,
        inverted: inverted,
        redInverted: redInverted));
  }

  void invertRedTeam() {
    emit(InvertInitial());
    redInverted = !redInverted;
    emit(InvertNewState(
        blueInverted: blueInverted,
        inverted: inverted,
        redInverted: redInverted));
  }

  void invertBlueTeam() {
    emit(InvertInitial());
    blueInverted = !blueInverted;
    emit(InvertNewState(
        blueInverted: blueInverted,
        inverted: inverted,
        redInverted: redInverted));
  }
}

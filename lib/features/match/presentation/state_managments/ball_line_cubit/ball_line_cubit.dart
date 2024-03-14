import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'ball_line_state.dart';

class BallLineCubit extends Cubit<BallLineState> {
  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;
  bool continued = true;
  BallLineCubit() : super(BallLineInitial());
  void newLine(Offset p1, Offset p2, bool continuedLine) {
    emit(BallLineInitial());
    startPoint = p1;
    endPoint = p2;
    emit(SelectedBallLineState(p1: p1, p2: p2, continuedLine: continuedLine));

    continued = continuedLine;
 
  }
  
}

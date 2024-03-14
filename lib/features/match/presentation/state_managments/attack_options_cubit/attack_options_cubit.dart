import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'attack_options_state.dart';

class AttackOptionsCubit extends Cubit<AttackOptionsState> {
  AttackOptionsCubit() : super(AttackOptionsInitial());
}

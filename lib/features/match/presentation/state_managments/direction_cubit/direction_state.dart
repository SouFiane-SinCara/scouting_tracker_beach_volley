// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'direction_cubit.dart';

sealed class DirectionState extends Equatable {
  const DirectionState();

  @override
  List<Object> get props => [];
}

final class DirectionInitial extends DirectionState {}

class NewDirectionState extends DirectionState {
  int direction;
  NewDirectionState({ 
    required this.direction,
  });
}

part of 'type_beat_cubit.dart';

sealed class TypeBeatState extends Equatable {
  const TypeBeatState();

  @override
  List<Object> get props => [];
}

final class TypeBeatInitial extends TypeBeatState {}

class FloatState extends TypeBeatState {}

class JumpState extends TypeBeatState {}

class JumpFloatState extends TypeBeatState {}

class HybirdState extends TypeBeatState {}

class NormaleState extends TypeBeatState {}

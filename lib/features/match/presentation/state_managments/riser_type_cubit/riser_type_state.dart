part of 'riser_type_cubit.dart';

sealed class RiserTypeState extends Equatable {
  const RiserTypeState();

  @override
  List<Object> get props => [];
}

final class RiserTypeInitial extends RiserTypeState {}

class NormalRiseState extends RiserTypeState {}

class QuickRiseState extends RiserTypeState {}

class SuperRiseState extends RiserTypeState {}

class BehindRiseState extends RiserTypeState {}
  
// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tournaments_cubit.dart';

sealed class TournamentsState extends Equatable {
  const TournamentsState();

  @override
  List<Object> get props => [];
}

final class TournamentsInitial extends TournamentsState {}

final class EmpityTournamentsState extends TournamentsState {}

final class LoadedTournamentsState extends TournamentsState {
  final List<String> tournaments;
  const LoadedTournamentsState({required this.tournaments});
}
final class ErrorTournamentsState extends TournamentsState{
  
}
class LoadedLocationState extends TournamentsState {
  final List<Map> locationdate;
  LoadedLocationState({
    required this.locationdate,
  });

  
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'scoore_cubit.dart';

sealed class ScooreState extends Equatable {
  const ScooreState();

  @override
  List<Object> get props => [];
}

final class ScooreInitial extends ScooreState {}

class NewSccoreState extends ScooreState {
  // static add 
  
  final  int homeSccore;
  final int awaySccore;
  final int homeSet1;
  final int homeSet2;
  final int homeSet3;

  final int awaySet1;
  final int awaySet2;
  final int awaySet3;
  final int currentSet;
  const NewSccoreState(
      {required this.awaySccore,
      required this.awaySet1,
      required this.awaySet2,
      required this.awaySet3,
      required this.homeSet1,
      required this.homeSet2,
      required this.homeSccore,
      required this.currentSet,
      required this.homeSet3});
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'last_match_cubit.dart';

sealed class LastMatchState extends Equatable {
  const LastMatchState();

  @override
  List<Object> get props => [];
}

final class LastMatchInitial extends LastMatchState {}

final class ChooseMatchState extends LastMatchState {
  final Account account;
  const ChooseMatchState({required this.account});
}

class ErrorMatchState extends LastMatchState {
 
 
}

class StartedMatchState extends LastMatchState {
  final AMatch aMatch;
  const StartedMatchState({
    required this.aMatch,
  });
  
}

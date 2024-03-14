// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rouand_cubit.dart';

sealed class RouandState extends Equatable {
  const RouandState();

  @override
  List<Object> get props => [];
}

final class RouandInitial extends RouandState {}

class NextRouandState extends RouandState {
  final int rouandNum;
  const NextRouandState({
    required this.rouandNum,
  });
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_beats_cubit.dart';

sealed class GetBeatsState extends Equatable {
  const GetBeatsState();

  @override
  List<Object> get props => [];
}

final class GetBeatsInitial extends GetBeatsState {}
class BeatsActionsLoadedState extends GetBeatsState {
  final List<BeatAction> beats ;
  const BeatsActionsLoadedState({
    required this.beats,
  });

}
class BeatsActionsErrorState extends GetBeatsState{}
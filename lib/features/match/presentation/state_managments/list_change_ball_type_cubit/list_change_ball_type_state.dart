part of 'list_change_ball_type_cubit.dart';

sealed class ListChangeBallTypeState extends Equatable {
  const ListChangeBallTypeState();

  @override
  List<Object> get props => [];
}

final class ListChangeBallTypeInitial extends ListChangeBallTypeState {}
class ChangeBallListstate extends ListChangeBallTypeState{}
class RightBallListState extends ListChangeBallTypeState{}
class LeftBallListState extends ListChangeBallTypeState{}
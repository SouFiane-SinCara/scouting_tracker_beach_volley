part of 'table_data_cubit.dart';

sealed class TableDataState extends Equatable {
  const TableDataState();

  @override
  List<Object> get props => [];
}

final class TableDataInitial extends TableDataState {}
class LoadedTableDataState extends TableDataState{
  final List<RowDataModel> rowDataModels;
  const LoadedTableDataState({required this.rowDataModels});
}
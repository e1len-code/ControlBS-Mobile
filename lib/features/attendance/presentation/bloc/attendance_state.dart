part of 'attendance_bloc.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class LoadingState extends AttendanceState {}

class SavedState extends AttendanceState {
  final bool? saved;
  const SavedState({this.saved});
  @override
  List<Object> get props => [saved!];
}

class ErrorState extends AttendanceState {
  final String message;
  const ErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class FilteredListState extends AttendanceState {
  final Map<String, List<AttendanceResp?>> mapList;
  const FilteredListState({required this.mapList});
  @override
  List<Object> get props => [mapList];
}

class GotListState extends AttendanceState {
  final List<AttendanceResp?> list;
  const GotListState({required this.list});
  @override
  List<Object> get props => [list];
}

class GotReportState extends AttendanceState {
  final String? base64Report;
  const GotReportState({required this.base64Report});
  @override
  List<Object> get props => [base64Report!];
}

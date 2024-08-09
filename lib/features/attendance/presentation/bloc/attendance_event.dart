part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

class SaveEvent extends AttendanceEvent {
  final Attendance attendance;
  const SaveEvent({required this.attendance});
}

class FilterListEvent extends AttendanceEvent {
  final AttendanceReq attendanceReq;
  const FilterListEvent({required this.attendanceReq});
}

class GetListEvent extends AttendanceEvent {
  final AttendanceReq attendanceReq;
  const GetListEvent({required this.attendanceReq});
}

class GetReportEvent extends AttendanceEvent {
  final AttendanceReq attendanceReq;
  const GetReportEvent({required this.attendanceReq});
}

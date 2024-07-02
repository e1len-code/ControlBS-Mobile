import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/features/attendance/domain/useCase/attendance_usecase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceUseCase useCase;
  AttendanceProvider({required this.useCase});

  Map<String, List<AttendanceResp?>> listFilterMapDates = {};
  List<AttendanceResp?> listAttendance = [];

  bool isLoading = false;
  String error = '';
  bool saved = false;
  String? base64Report = "";

  Future<int> filterList(AttendanceReq attendanceReq) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.filter(attendanceReq);
    result.fold((failure) => error = failure.message,
        (list) => mapDatesAttendance(list));
    isLoading = false;
    notifyListeners();
    return listFilterMapDates.length;
  }

  Future<int> getAttendance(AttendanceReq attendanceReq) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.filter(attendanceReq);
    result.fold(
        (failure) => error = failure.message, (list) => listAttendance = list);
    isLoading = false;
    notifyListeners();
    return listAttendance.length;
  }

  Future<bool> save(Attendance attendance) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.save(attendance);
    result.fold(
        (failure) => error = failure.message, (saved) => this.saved = saved!);
    if (saved) {
      getAttendance(AttendanceReq(
          persIden: attendance.persIden, attnDtIn: DateTime.now()));
    }
    isLoading = false;
    notifyListeners();
    return saved;
  }

  void mapDatesAttendance(List<AttendanceResp?> list) {
    listFilterMapDates = {};
    for (var elemento in list) {
      String fechaFormateada =
          DateFormat('yyyy-MM-dd').format(elemento!.attnDate!);
      if (listFilterMapDates.containsKey(fechaFormateada)) {
        listFilterMapDates[fechaFormateada]!.add(elemento);
      } else {
        listFilterMapDates[fechaFormateada] = [elemento];
      }
    }
  }

  getReport(AttendanceReq attendanceReq) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.getReport(attendanceReq);
    result.fold((failure) => error = failure.message,
        (report) => base64Report = report);
    isLoading = false;
    notifyListeners();
  }
}

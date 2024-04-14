import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/features/attendance/domain/useCase/attendance_usecase.dart';
import 'package:flutter/material.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceUseCase useCase;
  AttendanceProvider({required this.useCase});

  List<AttendanceResp?> listFilter = [];

  bool isLoading = false;
  String error = '';

  Future<int> filterList(AttendanceReq attendanceReq) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final auth = await useCase.filter(attendanceReq);
    auth.fold(
        (failure) => error = failure.message, (list) => listFilter = list);
    notifyListeners();
    isLoading = false;
    return listFilter.length;
  }
}

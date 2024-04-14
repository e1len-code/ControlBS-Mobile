import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/features/attendance/data/repository/attendance_repository.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceUseCase {
  Future<Either<Failure, List<AttendanceResp?>>> filter(
      AttendanceReq attendanceReq);
}

class AttendanceUseCaseImple implements AttendanceUseCase {
  final AttendanceRepository repository;

  AttendanceUseCaseImple({required this.repository});
  @override
  Future<Either<Failure, List<AttendanceResp?>>> filter(
      AttendanceReq attendanceReq) {
    return repository.filter(attendanceReq);
  }
}

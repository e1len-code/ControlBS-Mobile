import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/utils/crypto.dart';
import 'package:controlbs_mobile/core/utils/geolocator.dart';
import 'package:controlbs_mobile/core/utils/wifi_ip.dart';
import 'package:controlbs_mobile/features/attendance/data/repository/attendance_repository.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceUseCase {
  Future<Either<Failure, List<AttendanceResp?>>> filter(
      AttendanceReq attendanceReq);
  Future<Either<Failure, bool?>> save(Attendance attendance);
  Future<Either<Failure, String?>> getReport(AttendanceReq attendanceReq);
}

class AttendanceUseCaseImple implements AttendanceUseCase {
  final AttendanceRepository repository;

  AttendanceUseCaseImple({required this.repository});
  @override
  Future<Either<Failure, List<AttendanceResp?>>> filter(
      AttendanceReq attendanceReq) {
    return repository.filter(attendanceReq);
  }

  @override
  Future<Either<Failure, bool?>> save(Attendance attendance) async {
    final responseGeo = await determinePosition();
    return responseGeo
        .fold((failure) => Left(DataFailure(message: failure.message)),
            (geolocator) async {
      attendance.attnUbic =
          encrypt('${geolocator.latitude}, ${geolocator.longitude}').base16;
      final responseWifi = await getIpWifi();
      return responseWifi.fold((failure) => Left(failure), (ipWifi) async {
        //if (ipWifi == ipWifiGateAway) {
        if (true) {
          return repository.save(attendance);
        } else {
          return Left(
              DataFailure(message: "No esta conectado a la red Wifi local"));
        }
      });
    });
  }

  @override
  Future<Either<Failure, String?>> getReport(AttendanceReq attendanceReq) {
    return repository.getReport(attendanceReq);
  }
}

import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/features/attendance/data/datasource/attendance_remote_data.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AttendanceResp?>>> filter(
      AttendanceReq attendanceReq);
  Future<Either<Failure, bool?>> save(Attendance attendance);
  Future<Either<Failure, String?>> getReport(AttendanceReq attendanceReq);
}

class AttendanceRepositoryImple implements AttendanceRepository {
  final AttendanceRemoteData remoteData;

  AttendanceRepositoryImple({required this.remoteData});

  @override
  Future<Either<Failure, List<AttendanceResp?>>> filter(
      AttendanceReq attendanceReq) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.filter(attendanceReq);
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure(message: ""));
    }
  }

  @override
  Future<Either<Failure, bool?>> save(Attendance attendance) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.save(attendance);
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure(message: "Error intentelo mas tarde"));
    }
  }

  @override
  Future<Either<Failure, String?>> getReport(
      AttendanceReq attendanceReq) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.getReport(attendanceReq);
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure(message: "Error intentelo mas tarde"));
    }
  }
}

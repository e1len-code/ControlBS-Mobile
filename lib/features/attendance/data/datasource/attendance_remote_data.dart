import 'dart:convert';

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/core/utils/response_model.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:http/http.dart' as http;

abstract class AttendanceRemoteData {
  Future<bool?> save(Attendance attendance);
  Future<List<AttendanceResp?>> filter(AttendanceReq attendanceReq);
}

class AttendanceRemoteDataImple implements AttendanceRemoteData {
  late final http.Client client;
  AttendanceRemoteDataImple({required this.client});

  @override
  Future<bool?> save(Attendance attendance) async {
    final uri = Uri.parse('http://controlBS.somee.com/attendance');
    var response = await client
        .post(uri,
            headers: getIt<Headers>().headers,
            body: jsonEncode(attendance.toJson()))
        .timeout(const Duration(seconds: timeout),
            onTimeout: () => throw TimeOutException());
    final data = Data.fromJson(jsonDecode(response.body),
        (value) => response.statusCode == 200 ? valueBool(value) : null);
    if (response.statusCode == 200) {
      return data.value;
    } else {
      throw ApiResponseException(
          statusCode: response.statusCode,
          firstMessageError: data.errors.first.message);
    }
  }

  bool valueBool(bool value) {
    return value;
  }

  @override
  Future<List<AttendanceResp?>> filter(AttendanceReq attendanceReq) async {
    final uri = Uri.parse('http://controlBS.somee.com/attendance/filterList');
    var response = await client
        .post(uri,
            headers: getIt<Headers>().headers,
            body: jsonEncode(attendanceReq.toJson()))
        .timeout(const Duration(seconds: timeout),
            onTimeout: () => throw TimeOutException());

    final data = Data.fromJson(
        jsonDecode(response.body),
        (value) =>
            response.statusCode == 200 ? AttendanceResp.fromJson(value) : null);
    if (response.statusCode == 200) {
      return data.value;
    } else {
      throw ApiResponseException(
          statusCode: response.statusCode,
          firstMessageError: data.errors.first.message);
    }
  }
}

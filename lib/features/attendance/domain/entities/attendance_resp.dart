import 'package:controlbs_mobile/core/utils/datetime_parsing.dart';

class AttendanceResp {
  final int persIden;
  final int attnIden;
  final String persName;
  final String attnObse;
  final String attnUbic;
  final DateTime? attnDate;
  final String attnIp;

  AttendanceResp(
      {required this.persIden,
      required this.attnIden,
      required this.persName,
      required this.attnDate,
      required this.attnIp,
      required this.attnUbic,
      required this.attnObse});

  factory AttendanceResp.fromJson(Map<String, dynamic> json) {
    return AttendanceResp(
        persIden: json['persiden'] ?? 0,
        attnIden: json['attniden'] ?? 0,
        persName: json['persname'] ?? '',
        attnDate: toDate(json['attndate']),
        attnIp: json['attnip'] ?? '',
        attnUbic: json['attnubic'] ?? '',
        attnObse: json['attnobse'] ?? '');
  }
}

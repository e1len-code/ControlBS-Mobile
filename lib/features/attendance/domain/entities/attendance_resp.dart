import 'package:controlbs_mobile/core/utils/datetime_parsing.dart';

class AttendanceResp {
  final int persIden;
  final int attnIden;
  final int attnLine;
  final String persName;
  final String attnObse;
  final String attnUbic;
  final DateTime? attnDate;

  AttendanceResp(
      {required this.persIden,
      required this.attnIden,
      required this.attnLine,
      required this.persName,
      required this.attnDate,
      required this.attnUbic,
      required this.attnObse});

  factory AttendanceResp.fromJson(Map<String, dynamic> json) {
    return AttendanceResp(
        persIden: json['persiden'] ?? 0,
        attnIden: json['attniden'] ?? 0,
        attnLine: json['attnline'] ?? 0,
        persName: json['persname'] ?? '',
        attnDate: toDate(json['attndate']),
        attnUbic: json['attnubic'] ?? '',
        attnObse: json['attnobse'] ?? '');
  }
}

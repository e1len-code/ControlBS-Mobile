import 'package:controlbs_mobile/core/utils/datetime_parsing.dart';

class Attendance {
  final int attnIden;
  final int persIden;
  final int attnline;
  String? attnUbic;
  final DateTime attnDate;
  final String attnObse;

  Attendance(
      {required this.attnIden,
      required this.persIden,
      required this.attnline,
      required this.attnUbic,
      required this.attnDate,
      this.attnObse = "CORRECTO"});

  Map<String, dynamic> toJson() {
    return {
      'attniden': attnIden,
      'persiden': persIden,
      'attnline': attnline,
      'attnubic': attnUbic,
      'attndate': dateTimeFormatJson(attnDate),
      'attnobse': attnObse
    };
  }
}

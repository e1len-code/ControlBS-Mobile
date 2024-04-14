import 'package:controlbs_mobile/core/utils/datetime_parsing.dart';

class AttendanceReq {
  final int? persIden;
  final DateTime? attnDtIn;
  final DateTime? atttnDtFn;

  AttendanceReq({this.persIden, this.attnDtIn, this.atttnDtFn});

  Map<String, dynamic> toJson() {
    return {
      'persiden': persIden,
      'attndtin': dateTimeFormatJson(attnDtIn),
      'attndtfn': dateTimeFormatJson(atttnDtFn)
    };
  }
}

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime? toDate(dynamic fecha) {
  if (fecha != null) {
    return DateTime.parse(fecha.toString());
  } else
    return null;
  /* json["fecha_Inspeccion"] != null
            ? DateTime.parse(json["fecha_Inspeccion"].toString())
            : null, */
}

TimeOfDay? toTime(dynamic time) {
  if (time != null) {
    return TimeOfDay(
        hour: int.parse(timeout.toString().substring(0, 2)),
        minute: int.parse(time.toString().substring(3, 5)));
  } else
    return null;
}

String dateFormat(DateTime? date) {
  return date == null ? "" : DateFormat('dd/MM/yyyy').format(date);
}

String timeFormat(DateTime? time) {
  return time == null ? "" : DateFormat('HH:mm:ss').format(time);
}

String dateTimeFormat(DateTime? date) {
  return date == null ? "" : DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
}

String timeFormatJson(TimeOfDay? time) {
  final now = new DateTime.now();
  final timeValue = time == null ? TimeOfDay.now() : time;
  final dt =
      DateTime(now.year, now.month, now.day, timeValue.hour, timeValue.minute);
  return DateFormat('HH:mm').format(dt);
}

String? dateFormatJson(DateTime? date) {
  return date == null ? null : DateFormat('yyyy-MM-dd').format(date);
}

String? dateTimeFormatJson(DateTime? date) {
  return date == null ? null : DateFormat('yyyy-MM-ddTHH:mm:ss').format(date);
}

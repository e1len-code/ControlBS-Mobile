import 'package:controlbs_mobile/core/utils/datetime_parsing.dart';

class UserBreak {
  final DateTime pebrDay;
  final String pebrDays;
  final String pewbrName;

  UserBreak({
    required this.pebrDay,
    required this.pebrDays,
    required this.pewbrName,
  });

  factory UserBreak.fromJson(Map<String, dynamic> json) {
    return UserBreak(
        pebrDay: toDate(json['pebrday']) ?? DateTime.now(),
        pebrDays: json['pebrdays'] ?? '',
        pewbrName: json['pewbrname'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'pebrday': dateFormatJson(pebrDay),
      'pebrdays': pebrDays,
      'pewbrname': pewbrName
    };
  }
}

class Attendance {
  final int attnIden;
  final int persIden;
  final String attnUbic;
  final DateTime attnDate;
  final String attnIp;

  Attendance(
      {required this.attnIden,
      required this.persIden,
      required this.attnUbic,
      required this.attnDate,
      required this.attnIp});

  Map<String, dynamic> toJson() {
    return {
      'attniden': attnIden,
      'persiden': persIden,
      'attnubic': attnUbic,
      'attndate': attnDate,
      'attnIp': attnIp
    };
  }
}

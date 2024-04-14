import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_item_widget.dart';
import 'package:flutter/material.dart';

class AttendanceListWidget extends StatelessWidget {
  final List<AttendanceResp?> attendanceList;
  final bool isSearching;
  const AttendanceListWidget(
      {Key? key, required this.attendanceList, this.isSearching = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        //shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        itemBuilder: (context, index) {
          return AttendanceItemWidget(
              attendance: attendanceList[index]!, isSearching: isSearching);
        },
        itemCount: attendanceList.length,
      ),
    );
  }
}

import 'package:controlbs_mobile/core/widgets/item_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:flutter/material.dart';

class AttendanceItemWidget extends StatelessWidget {
  final AttendanceResp attendance;
  final bool isSearching;
  const AttendanceItemWidget(
      {Key? key, required this.attendance, this.isSearching = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      children: [
        Text(
          attendance.persIden.toString(),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer),
        ),
        Text(attendance.persName),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                attendance.attnDate.toString(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                attendance.attnObse,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer),
              ),
            ),
          ],
        )
      ],
    );
  }
}

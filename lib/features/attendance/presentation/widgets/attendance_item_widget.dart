import 'package:controlbs_mobile/core/utils/datetime_parsing.dart';
import 'package:controlbs_mobile/core/widgets/item_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_date_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceItemWidget extends StatefulWidget {
  final String dateTime;
  final List<AttendanceResp?> list;
  const AttendanceItemWidget(
      {Key? key, required this.dateTime, required this.list})
      : super(key: key);

  @override
  State<AttendanceItemWidget> createState() => _AttendanceItemWidgetState();
}

class _AttendanceItemWidgetState extends State<AttendanceItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    DateFormat('EEEE, ', 'en_US')
                        .format(toDate(widget.dateTime)!),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    DateFormat('d MMMM', 'en_US')
                        .format(toDate(widget.dateTime)!),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 30,
                width: 300,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.list.length,
                    itemBuilder: (context, index) {
                      return AttendanceDateItemWidget(
                          date: timeFormat(widget.list[index]!.attnDate));
                    }),
              ),
            )
          ],
        ),
      ],
    );
  }
}

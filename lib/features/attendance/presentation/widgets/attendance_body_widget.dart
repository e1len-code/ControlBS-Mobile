import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_list_widget.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceBodyWidget extends StatefulWidget {
  const AttendanceBodyWidget({Key? key}) : super(key: key);

  @override
  _AttendanceBodyWidgetState createState() => _AttendanceBodyWidgetState();
}

class _AttendanceBodyWidgetState extends State<AttendanceBodyWidget> {
  //final _nroDocController = TextEditingController();
  late final AttendanceProvider attendanceProvider;
  late final AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    attendanceProvider = context.read<AttendanceProvider>();
    authProvider = context.read<AuthProvider>();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      attendanceProvider.filterList(AttendanceReq(
        persIden: authProvider.authResponse.id,
        attnDtIn: DateTime.now(),
      ));
    });
  }

  // Future<void> _handleRefresh() async {
  //   Future.delayed(Duration(seconds: 1));
  //   _search();
  //   //personaBloc.add(ListEvent());
  // }

  void _search(List<DateTime?> listDates) {
    attendanceProvider.filterList(AttendanceReq(
        persIden: authProvider.authResponse.id,
        attnDtIn: listDates.first,
        atttnDtFn: listDates.last));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.symmetric(vertical: vspaceM, horizontal: hspaceS),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.range,
                ),
                value: [DateTime.now()],
                onValueChanged: (dates) => _search(dates),
              ),
              Expanded(child: Consumer<AttendanceProvider>(
                  builder: (context, attendanceProvider, child) {
                return attendanceProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AttendanceListWidget(
                        attendanceList: attendanceProvider.listFilter,
                      );
              }))
            ]));
  }
}

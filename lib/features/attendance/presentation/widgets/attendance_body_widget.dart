import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_list_widget.dart';
import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart'
    as authbloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBodyWidget extends StatefulWidget {
  const AttendanceBodyWidget({Key? key}) : super(key: key);

  @override
  _AttendanceBodyWidgetState createState() => _AttendanceBodyWidgetState();
}

class _AttendanceBodyWidgetState extends State<AttendanceBodyWidget> {
  //final _nroDocController = TextEditingController();
  late final AttendanceBloc attendanceBloc;
  late final authbloc.AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    attendanceBloc = context.read<AttendanceBloc>();
    authBloc = context.read<authbloc.AuthBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      attendanceBloc.add(FilterListEvent(
          attendanceReq: AttendanceReq(
        persIden: authBloc.authResponse!.id,
        attnDtIn: DateTime.now(),
      )));
    });
  }

  // Future<void> _handleRefresh() async {
  //   Future.delayed(Duration(seconds: 1));
  //   _search();
  //   //personaBloc.add(ListEvent());
  // }

  void _search(List<DateTime?> listDates) {
    attendanceBloc.add(FilterListEvent(
        attendanceReq: AttendanceReq(
      persIden: authBloc.authResponse!.id,
      attnDtIn: DateTime.now(),
    )));
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
              Expanded(child: BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  return state is LoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : state is GotListState
                          ? AttendanceListWidget(
                              attendanceList: attendanceBloc.listFilterMapDates)
                          : const Center(
                              child: Text("No hay datos"),
                            );
                },
              ))
            ]));
  }
}

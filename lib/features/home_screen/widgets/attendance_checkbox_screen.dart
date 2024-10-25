import 'package:controlbs_mobile/core/config/valueListenables/checkbox_status.dart';
import 'package:controlbs_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_checkbox_widget.dart';
import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart'
    as authbloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AttendaceCheckBoxScreen extends StatelessWidget {
  const AttendaceCheckBoxScreen({
    super.key,
    required this.checkBoxValueNotifier,
    required GlobalKey<AttendanceCheckBoxWidgetState> keyAttendanceCheckBox,
  }) : _keyAttendanceCheckBox = keyAttendanceCheckBox;

  final CheckBoxStatusVListenable checkBoxValueNotifier;
  final GlobalKey<AttendanceCheckBoxWidgetState> _keyAttendanceCheckBox;

  @override
  Widget build(BuildContext context) {
    authbloc.AuthBloc authBloc = context.read<authbloc.AuthBloc>();
    AttendanceBloc attendanceBloc = context.read<AttendanceBloc>();

    return BlocBuilder<AttendanceBloc, AttendanceState>(
      bloc: attendanceBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return BlocBuilder<authbloc.AuthBloc, authbloc.AuthState>(
              bloc: authBloc,
              builder: (context, state) {
                if (state is LoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (authBloc.authResponse!.id != 0) {
                    return AttendanceCheckBoxWidget(
                      key: _keyAttendanceCheckBox,
                      listAttendance: attendanceBloc.listAttendance,
                    );
                  } else {
                    return AttendanceCheckBoxWidget(
                      key: _keyAttendanceCheckBox,
                      listAttendance: const [],
                    );
                  }
                }
              });
        }
      },
    );
  }
}

import 'package:controlbs_mobile/core/config/valueListenables/checkbox_status.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_checkbox_widget.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
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
    return ValueListenableBuilder(
        valueListenable: checkBoxValueNotifier.urlStatusCheck,
        builder: (context, statusCheckN, child) {
          return Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, child) {
            return attendanceProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                    return authProvider.authResponse.id != 0
                        ? AttendanceCheckBoxWidget(
                            key: _keyAttendanceCheckBox,
                            listAttendance: attendanceProvider.listAttendance,
                          )
                        : AttendanceCheckBoxWidget(
                            key: _keyAttendanceCheckBox,
                            listAttendance: const [],
                          );
                  });
          });
        });
  }
}

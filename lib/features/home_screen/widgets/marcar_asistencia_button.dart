import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarcarAsistenciaButtonWidget extends StatefulWidget {
  const MarcarAsistenciaButtonWidget({
    super.key,
    required this.authProvider,
    required this.saveAttendance,
  });

  final AuthProvider authProvider;
  final VoidCallback saveAttendance;

  @override
  State<MarcarAsistenciaButtonWidget> createState() =>
      _MarcarAsistenciaButtonWidgetState();
}

class _MarcarAsistenciaButtonWidgetState
    extends State<MarcarAsistenciaButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<AttendanceProvider>(builder: (context, attendance, child) {
          return attendance.isLoading
              ? Container()
              : attendance.listAttendance.length == 4
                  ? const Text(
                      "Se registró todas tus asistencias, vuelve mañana")
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          padding: const EdgeInsets.symmetric(
                              vertical: vspaceXL, horizontal: hspaceXXL * 2)),
                      onPressed: widget.saveAttendance,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.checklist_rounded),
                          SizedBox(
                            width: vspaceXL,
                          ),
                          Text(
                            'MARCAR ASISTENCIA',
                            style: TextStyle(
                                fontSize: fontSizeXXL,
                                fontWeight: fontWeightBold),
                          ),
                        ],
                      ),
                    );
        }),
        Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return authProvider.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Text(
                      authProvider.authResponse.names,
                      style: const TextStyle(
                          fontWeight: fontWeightBold, fontSize: fontSizeL),
                    ),
                  ],
                );
        }),
      ],
    );
  }
}

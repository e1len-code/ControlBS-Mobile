import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/features/attendance/presentation/bloc/attendance_bloc.dart'
    as attendancebloc;
import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarcarAsistenciaButtonWidget extends StatefulWidget {
  const MarcarAsistenciaButtonWidget({
    super.key,
    required this.authBloc,
    required this.saveAttendance,
  });

  final AuthBloc authBloc;
  final VoidCallback saveAttendance;

  @override
  State<MarcarAsistenciaButtonWidget> createState() =>
      _MarcarAsistenciaButtonWidgetState();
}

class _MarcarAsistenciaButtonWidgetState
    extends State<MarcarAsistenciaButtonWidget> {
  @override
  Widget build(BuildContext context) {
    attendancebloc.AttendanceBloc attendanceBloc =
        context.read<attendancebloc.AttendanceBloc>();
    AuthBloc authBloc = context.read<AuthBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<attendancebloc.AttendanceBloc,
            attendancebloc.AttendanceState>(builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return attendanceBloc.listAttendance.length == 4
                ? const Text("Se registró todas tus asistencias, vuelve mañana")
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
          }
        }),
        BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state) {
              // if (state is LoadingState) {
              //   return const Center(child: CircularProgressIndicator());
              // } else {
              return Column(
                children: [
                  Text(
                    authBloc.authResponse!.names,
                    style: const TextStyle(
                        fontWeight: fontWeightBold, fontSize: fontSizeL),
                  ),
                ],
              );
            })
      ],
    );
  }
}

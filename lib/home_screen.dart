import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/core/config/theme_stuff.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_checkbox_widget.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// The home screen
class HomeScreen extends StatefulWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeMode themeMode = ThemeMode.system;
  ThemeStuff appValueNotifier = ThemeStuff.instance();
  late final AuthProvider authProvider;
  late final AttendanceProvider attendanceProvider;
  late final _keyAttendanceCheckBox = GlobalKey<AttendanceCheckBoxWidgetState>(
      debugLabel: '_keyAttendanceCheckBox');

  String theme = "dark";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = context.read<AuthProvider>();
    attendanceProvider = context.read<AttendanceProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authProvider.authLoginLocal();

      await attendanceProvider.getAttendance(AttendanceReq(
          persIden: authProvider.authResponse.id, attnDtIn: DateTime.now()));
    });
  }

  void _saveAttendance() async {
    Attendance attendanceSaved = Attendance(
      attnIden: 0,
      attnline: _keyAttendanceCheckBox.currentState!.nroCheckBoxSelectedF,
      persIden: authProvider.authResponse.id,
      attnUbic: "",
      attnDate: DateTime.now(),
    );

    await attendanceProvider.save(attendanceSaved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<AuthProvider>(builder: (context, authProvider, child) {
            return authProvider.authResponse.id != 0
                ? TextButton(
                    onPressed: () => {authProvider.logOut()},
                    child: Row(
                      children: [
                        Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        Text(
                          "Cerrar Sesión",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer),
                        ),
                      ],
                    ))
                : Container();
          }),
          TextButton(
              onPressed: () => context.go('/configtheme'),
              child: const Icon(Icons.brush_outlined))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Center(child: TitleWidget(text: "CONTROL BS")),
                    Consumer<AttendanceProvider>(
                        builder: (context, attendanceProvider, child) {
                      return attendanceProvider.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              attendanceProvider.error,
                              style: const TextStyle(
                                  fontWeight: fontWeightBold,
                                  fontSize: fontSizeL),
                            );
                    }),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<AttendanceProvider>(
                      builder: (context, attendance, child) {
                    return attendance.listAttendance.length == 4
                        ? const Text(
                            "Se registró todas tus asistencias, vuelve mañana")
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                padding: const EdgeInsets.symmetric(
                                    vertical: vspaceXL,
                                    horizontal: hspaceXXL * 2)),
                            onPressed: () => _saveAttendance(),
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
                  Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                    return authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              Text(
                                authProvider.authResponse.names,
                                style: const TextStyle(
                                    fontWeight: fontWeightBold,
                                    fontSize: fontSizeL),
                              ),
                            ],
                          );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, child) {
                    return attendanceProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                            return authProvider.authResponse.id != 0
                                ? AttendanceCheckBoxWidget(
                                    key: _keyAttendanceCheckBox,
                                    listAttendance:
                                        attendanceProvider.listAttendance,
                                  )
                                : AttendanceCheckBoxWidget(
                                    key: _keyAttendanceCheckBox,
                                    listAttendance: [],
                                  );
                          });
                  })
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    authProvider.authResponse.id == 0
                        ? ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: const Text('INICIAR SESIÓN'),
                          )
                        : ElevatedButton(
                            onPressed: () => context.go('/attendanceFilter'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: const Text('REVISAR ASISTENCIAS'),
                          ),
                    const Text("Inicia sesión o revisa tus asistencias"),
                  ],
                );
              }),
            ),
            const Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Desarrollado por ",
                    style: TextStyle(),
                  ),
                  Text(
                    "Brain Systems",
                    style: TextStyle(fontWeight: fontWeightBold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

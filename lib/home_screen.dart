import 'dart:convert';

import 'package:controlbs_mobile/core/config/valueListenables/checkbox_status.dart';
import 'package:controlbs_mobile/core/config/valueListenables/time_status.dart';
import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/display_bottom_sheet.dart';
import 'package:controlbs_mobile/core/widgets/draw_svg_widget.dart';
import 'package:controlbs_mobile/core/widgets/snack_widget.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_checkbox_widget.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/acceso.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'main.dart';

/// The home screen
class HomeScreen extends StatefulWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  CheckBoxStatusVListenable checkBoxValueNotifier =
      CheckBoxStatusVListenable.instance();
  TimeStatusVListenable timeStatusVListenable =
      TimeStatusVListenable.instance();
  late final AuthProvider authProvider;
  late final AttendanceProvider attendanceProvider;
  late final FileProvider fileProvider;
  late final _keyAttendanceCheckBox = GlobalKey<AttendanceCheckBoxWidgetState>(
      debugLabel: '_keyAttendanceCheckBox');
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  String theme = "dark";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = context.read<AuthProvider>();
    attendanceProvider = context.read<AttendanceProvider>();
    fileProvider = context.read<FileProvider>();

    setupInteractedMessage();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      RemoteNotification? notification = message?.notification!;

      print(notification != null ? notification.title : '');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        String action = jsonEncode(message.data);

        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                priority: Priority.high,
                importance: Importance.max,
                setAsGroupSummary: true,
                styleInformation: DefaultStyleInformation(true, true),
                largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                channelShowBadge: true,
                autoCancel: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: action);
      }
      print('A new event was published!');
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message.data));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authProvider.authLoginLocal();

      await attendanceProvider.getAttendance(AttendanceReq(
          persIden: authProvider.authResponse.id, attnDtIn: DateTime.now()));
      if (authProvider.authResponse.id != 0) {
        await fileProvider.getPhoto('imgs/${authProvider.authResponse.id}.jpg');
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => _handleMessage(value != null ? value.data : Map()));
  }

  void _handleMessage(Map<String, dynamic> data) {
    if (data['redirect'] == "product") {
      print("Si se envio el mensaje");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //dependOnInheritedWidgetOfExactType();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      timeStatusVListenable
          .updateTime(); // Actualiza la hora cuando la aplicación se reanuda
      checkBoxValueNotifier.statusCheckName(
          _keyAttendanceCheckBox.currentState!.nroCheckBoxSelected);
    }
  }

  void _saveAttendance() async {
    Attendance attendanceSaved = Attendance(
      attnIden: 0,
      attnline: _keyAttendanceCheckBox.currentState!.nroCheckBoxSelectedF,
      persIden: authProvider.authResponse.id,
      attnUbic: "",
      attnDate: DateTime.now(),
    );
    attendanceProvider.save(attendanceSaved).then((saved) {
      if (saved) {
        SnackWidget.showMessage(context, "Se guardó la asistencia");
      } else {
        SnackWidget.showMessage(context, "No se guardó la asistencia",
            isError: true);
      }
    });

    checkBoxValueNotifier.updateValue(attendanceSaved.attnline + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<FileProvider>(builder: (context, fileProvider, child) {
            return fileProvider.photoImg != null &&
                    fileProvider.photoImg!.isNotEmpty &&
                    authProvider.authResponse.id != 0
                ? CircleAvatar(
                    backgroundImage:
                        MemoryImage(base64Decode(fileProvider.photoImg!)))
                : Container();
          }),
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                child: const Row(
                  children: [
                    Icon(Icons.brush_outlined),
                    Text("Configuración de tema")
                  ],
                ),
                onPressed: () => this.context.go('/configtheme'),
              ),
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
                return authProvider.authResponse.id != 0
                    ? MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.draw_rounded),
                            Text(
                              "Firma de reporte",
                            )
                          ],
                        ),
                        onPressed: () => displaySignatureModal(this.context,
                            fileProvider, authProvider.authResponse.id),
                      )
                    : Container();
              }),
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
                return authProvider.authResponse.id != 0
                    ? MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.camera_alt_rounded),
                            Text(
                              "Tomar foto de perfil",
                            )
                          ],
                        ),
                        onPressed: () => this.context.go('/camera'),
                      )
                    : Container();
              }),
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
                List<AuthAccess?> listAuth = authProvider.listAuth;
                return Column(children: <Widget>[
                  for (AuthAccess? element in listAuth)
                    MenuItemButton(
                      child: Row(
                        children: [
                          const Icon(Icons.accessibility_new_rounded),
                          Text(element!.acceName),
                        ],
                      ),
                      onPressed: () => this.context.go(element.acceComm),
                    ),
                ]);
              }),
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
                return authProvider.authResponse.id != 0
                    ? MenuItemButton(
                        child: Row(
                          children: [
                            Icon(Icons.close,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer),
                            Text("Cerrar Sessión",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer))
                          ],
                        ),
                        onPressed: () => {authProvider.logOut()},
                      )
                    : Container();
              }),
            ],
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                focusNode: _buttonFocusNode,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: DrawSVGWidget(),
                  ),
                  const Center(child: TitleWidget(text: "CONTROL BS")),
                  Consumer2<AttendanceProvider, FileProvider>(builder:
                      (context, attendanceProvider, fileProvider, child) {
                    return attendanceProvider.isLoading ||
                            fileProvider.isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            attendanceProvider.error + fileProvider.error,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
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
                  return attendance.isLoading
                      ? Container()
                      : attendance.listAttendance.length == 4
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
                Consumer<AuthProvider>(builder: (context, authProvider, child) {
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
            child: ValueListenableBuilder(
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
                                    listAttendance:
                                        attendanceProvider.listAttendance,
                                  )
                                : AttendanceCheckBoxWidget(
                                    key: _keyAttendanceCheckBox,
                                    listAttendance: const [],
                                  );
                          });
                  });
                }),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    authProvider.authResponse.id == 0
                        ? ElevatedButton(
                            onPressed: () => this.context.go('/login'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: const Text('INICIAR SESIÓN'),
                          )
                        : ElevatedButton(
                            onPressed: () =>
                                this.context.go('/attendanceFilter'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: const Text('REVISAR ASISTENCIAS'),
                          ),
                    const Text("Inicia sesión / Revisa tus asistencias"),
                  ],
                );
              }),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Desarrollado por ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    const Text(
                      "Brain Systems",
                      style: TextStyle(
                        fontWeight: fontWeightBold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

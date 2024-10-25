import 'dart:convert';

import 'package:controlbs_mobile/core/config/valueListenables/checkbox_status.dart';
import 'package:controlbs_mobile/core/config/valueListenables/time_status.dart';
import 'package:controlbs_mobile/core/widgets/snack_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_checkbox_widget.dart';
import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart'
    as authbloc;
import 'package:controlbs_mobile/features/file/presentation/bloc/file_provider_bloc.dart'
    as filebloc;
import 'package:controlbs_mobile/features/home_screen/widgets/attendance_checkbox_screen.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/calendar_break.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/footer_screen.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/iniciar_sesion_button.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/marcar_asistencia_button.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/menu_anchor.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/photo_perfil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  late final authbloc.AuthBloc authProvider;
  late final AttendanceBloc attendanceProvider;
  late final filebloc.FileBloc fileProvider;
  late final _keyAttendanceCheckBox = GlobalKey<AttendanceCheckBoxWidgetState>(
      debugLabel: '_keyAttendanceCheckBox');
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  String theme = "dark";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Init provider
    authProvider = context.read<authbloc.AuthBloc>();
    attendanceProvider = context.read<AttendanceBloc>();
    fileProvider = context.read<filebloc.FileBloc>();

    // Noitifications
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
                styleInformation: const DefaultStyleInformation(true, true),
                largeIcon:
                    const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                channelShowBadge: true,
                autoCancel: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: action);
      }
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message.data));

    // after to load the screen
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      authProvider.add(authbloc.AuthLoginEvent());

      attendanceProvider.add(GetListEvent(
          attendanceReq: AttendanceReq(
              persIden: authProvider.authResponse?.id ?? 0,
              attnDtIn: DateTime.now())));
      if (authProvider.authResponse?.id != 0) {
        fileProvider.add(filebloc.GetFileEvent(
            filePath: 'imgs/${authProvider.authResponse?.id}.jpg'));
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  // Functions for notifications
  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => _handleMessage(value != null ? value.data : Map()));
  }

  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  void _handleMessage(Map<String, dynamic> data) {
    if (data['redirect'] == "product") {
      //print("Si se envio el mensaje");
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
      persIden: authProvider.authResponse?.id ?? 0,
      attnUbic: "",
      attnDate: DateTime.now(),
    );
    attendanceProvider.add(SaveEvent(attendance: attendanceSaved));
    checkBoxValueNotifier.updateValue(attendanceSaved.attnline + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PhotoPerfilWidget(authBloc: authProvider),
          MenuAnchorWidget(
              context: context,
              fileBloc: fileProvider,
              buttonFocusNode: _buttonFocusNode),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //const Expanded(flex: 3, child: HeaderHomeScreen()),
          const Expanded(flex: 3, child: CalendarBreak()),
          Expanded(
            flex: 1,
            child: MarcarAsistenciaButtonWidget(
              authBloc: authProvider,
              saveAttendance: _saveAttendance,
            ),
          ),
          Expanded(
            child: AttendaceCheckBoxScreen(
                checkBoxValueNotifier: checkBoxValueNotifier,
                keyAttendanceCheckBox: _keyAttendanceCheckBox),
          ),
          Expanded(
            flex: 1,
            child: IniciarSesionButton(context: context),
          ),
          const Expanded(
            flex: 1,
            child: FooterWidget(),
          ),
          BlocConsumer<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is SavedState) {
                SnackWidget.showMessage(context, "Se guardó la asistencia");
              } else if (state is ErrorState) {
                SnackWidget.showMessage(context, state.message);
              }
            },
            builder: (context, state) {
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/input_password_widget.dart';
import 'package:controlbs_mobile/core/widgets/input_widget.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  //AuthRepository authRepository = AuthRespositoryImple(remoteData: );
  late final AuthProvider authProvider;
  late final AttendanceProvider attendanceProvider;

  _sendLogin() {
    authProvider
        .authLogin(AuthRequest(
            userName: _userController.text, password: _passController.text))
        .then((value) {
      if (value.id != 0) {
        GoRouter.of(context).go('/');
        attendanceProvider.getAttendance(AttendanceReq(
            persIden: value.id, attnDtIn: DateTime.now(), atttnDtFn: null));
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    attendanceProvider = context.read<AttendanceProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: hspaceXXL),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(child: TitleWidget(text: "CONTROL BS")),
                          Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                            return authProvider.isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    authProvider.error,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer),
                                  );
                          })
                        ],
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InputWidget(
                          label: "Usuario",
                          controller: _userController,
                          suffixIcon: const Icon(Icons.person_4_rounded),
                          readOnly: authProvider.isLoading,
                        ),
                        const SizedBox(
                          height: hspaceXXL,
                        ),
                        InputPasswordWidget(
                          label: "Contraseña",
                          controller: _passController,
                          readOnly: authProvider.isLoading,
                        ),
                      ],
                    );
                  }),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => _sendLogin(),
                      style: ElevatedButton.styleFrom(
                        //padding: EdgeInsets.symmetric(),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: const Text(
                        'INICIAR SESIÓN',
                        //style: TextStyle(fontSize: fontSizeXXL),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

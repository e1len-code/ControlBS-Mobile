import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/input_password_widget.dart';
import 'package:controlbs_mobile/core/widgets/input_widget.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/presentation/bloc/attendance_bloc.dart'
    as attendancebloc;
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:controlbs_mobile/features/file/presentation/bloc/file_provider_bloc.dart'
    as filebloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  //AuthRepository authRepository = AuthRespositoryImple(remoteData: );
  late final AuthBloc authBloc;
  late final attendancebloc.AttendanceBloc attendanceBloc;
  late final filebloc.FileBloc fileBloc;

  _sendLogin() {
    authBloc.add(AuthReqEvent(AuthRequest(
        userName: _userController.text, password: _passController.text)));
  }

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
    attendanceBloc = context.read<attendancebloc.AttendanceBloc>();
    fileBloc = context.read<filebloc.FileBloc>();
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
                    child: BlocConsumer<AuthBloc, AuthState>(
                      bloc: authBloc,
                      listener: (context, state) {
                        if (state is AuthenticatedState) {
                          if (state.authResponse!.id != 0) {
                            GoRouter.of(context).go('/');
                            fileBloc.add(filebloc.GetFileEvent(
                                filePath:
                                    'imgs/${state.authResponse!.id}.jpg'));
                            attendanceBloc.add(attendancebloc.GetListEvent(
                                attendanceReq: AttendanceReq(
                                    persIden: state.authResponse!.id,
                                    attnDtIn: DateTime.now(),
                                    atttnDtFn: null)));
                          } else {}
                        }
                      },
                      builder: (context, state) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: TitleWidget(text: "CONTROL BS")),
                            ],
                          ),
                        );
                      },
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InputWidget(
                          label: "Usuario",
                          controller: _userController,
                          suffixIcon: const Icon(Icons.person_4_rounded),
                        ),
                        const SizedBox(
                          height: hspaceXXL,
                        ),
                        InputPasswordWidget(
                          label: "Contraseña",
                          controller: _passController,
                        ),
                      ],
                    )),
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

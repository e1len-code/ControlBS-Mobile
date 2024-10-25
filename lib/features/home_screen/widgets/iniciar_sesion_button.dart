import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class IniciarSesionButton extends StatefulWidget {
  const IniciarSesionButton({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<IniciarSesionButton> createState() => _IniciarSesionButtonState();
}

class _IniciarSesionButtonState extends State<IniciarSesionButton> {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    return SizedBox(
      width: double.infinity,
      child: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is ErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state) {
            if (state is ErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is LogOutState) {
              setState(() {});
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                authBloc.authResponse!.id == 0
                    ? ElevatedButton(
                        onPressed: () => widget.context.go('/login'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                        child: const Text('INICIAR SESIÓN'),
                      )
                    : ElevatedButton(
                        onPressed: () => widget.context.go('/attendanceFilter'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                        child: const Text('REVISAR ASISTENCIAS'),
                      ),
                const Text("Inicia sesión / Revisa tus asistencias"),
              ],
            );
          },
        ),
      ),
    );
  }
}

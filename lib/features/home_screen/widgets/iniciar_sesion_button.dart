import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class IniciarSesionButton extends StatelessWidget {
  const IniciarSesionButton({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            authProvider.authResponse.id == 0
                ? ElevatedButton(
                    onPressed: () => this.context.go('/login'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer),
                    child: const Text('INICIAR SESIÓN'),
                  )
                : ElevatedButton(
                    onPressed: () => this.context.go('/attendanceFilter'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer),
                    child: const Text('REVISAR ASISTENCIAS'),
                  ),
            const Text("Inicia sesión / Revisa tus asistencias"),
          ],
        );
      }),
    );
  }
}

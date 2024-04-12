import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/core/config/theme_stuff.dart';
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
  //late final AuthProvider authProvider;

  String theme = "dark";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //authProvider = context.read<AuthProvider>();
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
            const Expanded(
                flex: 2, child: Center(child: TitleWidget(text: "CONTROL BS"))),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        padding: const EdgeInsets.symmetric(
                            vertical: vspaceXL, horizontal: hspaceXXL * 2)),
                    onPressed: () => context.go('/details'),
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
                  ),
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
                            onPressed: () => context.go('/details'),
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

import 'package:controlbs_mobile/core/widgets/display_bottom_sheet.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/acceso.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuAnchorWidget extends StatelessWidget {
  const MenuAnchorWidget({
    super.key,
    required this.context,
    required this.fileProvider,
    required FocusNode buttonFocusNode,
  }) : _buttonFocusNode = buttonFocusNode;

  final BuildContext context;
  final FileProvider fileProvider;
  final FocusNode _buttonFocusNode;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
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
                  onPressed: () => displaySignatureModal(
                      this.context, fileProvider, authProvider.authResponse.id),
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
                          color:
                              Theme.of(context).colorScheme.onErrorContainer),
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
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
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
    );
  }
}

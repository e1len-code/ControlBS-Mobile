import 'package:controlbs_mobile/core/widgets/display_bottom_sheet.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/acceso.dart';
import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:controlbs_mobile/features/file/presentation/bloc/file_provider_bloc.dart'
    as filebloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuAnchorWidget extends StatelessWidget {
  const MenuAnchorWidget({
    super.key,
    required this.context,
    required this.fileBloc,
    required FocusNode buttonFocusNode,
  }) : _buttonFocusNode = buttonFocusNode;

  final BuildContext context;
  final filebloc.FileBloc fileBloc;
  final FocusNode _buttonFocusNode;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
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
        BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return authBloc.authResponse!.id == 0
                    ? MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.login_rounded),
                            Text("Iniciar sesión"),
                          ],
                        ),
                        onPressed: () => this.context.go('/login'),
                      )
                    : MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.logout_rounded),
                            Text("Cerrar sesión"),
                          ],
                        ),
                        onPressed: () => authBloc.add(LogOutEvent()),
                      );
              }
            }),
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return authBloc.authResponse!.id != 0
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
                        this.context, fileBloc, authBloc.authResponse!.id),
                  )
                : Container();
          }
        }),
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return authBloc.authResponse!.id != 0
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
          }
        }),
        BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state) {
              List<AuthAccess?> listAuth = authBloc.listAuthAccess;
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else {
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
              }
            }),
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return authBloc.authResponse!.id != 0
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
                    onPressed: () => {authBloc.add(LogOutEvent())},
                  )
                : Container();
          }
        })
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

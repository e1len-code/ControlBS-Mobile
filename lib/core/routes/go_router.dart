import 'package:controlbs_mobile/core/config/config_theme.dart';
import 'package:controlbs_mobile/features/attendance/presentation/page/attendance_page.dart';
import 'package:controlbs_mobile/features/attendance/presentation/page/attendance_page_edit.dart';
import 'package:controlbs_mobile/features/auth/presentation/page/auth_page.dart';
import 'package:controlbs_mobile/features/camera/presentation/page/camera_page.dart';
import 'package:controlbs_mobile/features/file/presentation/page/sign_page.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/thmbnail_widget.dart';
import 'package:controlbs_mobile/features/users/presentation/page/user_form_page.dart';
import 'package:controlbs_mobile/features/users/presentation/page/user_page.dart';
import 'package:controlbs_mobile/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'configtheme',
          builder: (BuildContext context, GoRouterState state) {
            return const ConfigThemeScreen();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthPage();
          },
        ),
        GoRoute(
            path: 'camera',
            builder: (BuildContext context, GoRouterState state) {
              return const CameraPage();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'thmbnailPhoto',
                builder: (BuildContext context, GoRouterState state) {
                  return const ThmbnailWidget(controller: null);
                },
              ),
            ]),
        GoRoute(
          path: 'attendanceFilter',
          builder: (BuildContext context, GoRouterState state) {
            return const AttendacePage();
          },
        ),
        GoRoute(
          path: "signaturePage",
          builder: (BuildContext context, GoRouterState state) {
            return const SignPage();
          },
        ),
        GoRoute(
          path: "attendanceEdit",
          builder: (BuildContext context, GoRouterState state) {
            return const AttendancePageEdit();
          },
        ),
        GoRoute(
            path: "Usuarios",
            builder: (BuildContext context, GoRouterState state) {
              return const UserPage();
            },
            routes: <RouteBase>[
              GoRoute(
                path: ":persIden",
                builder: (BuildContext context, GoRouterState state) {
                  return UserFormPage(
                      persIden: state.pathParameters['persIden'] ?? '');
                },
              )
            ] // Add more routes here
            ),
      ],
    ),
  ],
);

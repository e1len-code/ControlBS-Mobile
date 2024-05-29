import 'package:controlbs_mobile/core/config/config_theme.dart';
import 'package:controlbs_mobile/details.dart';
import 'package:controlbs_mobile/features/attendance/presentation/page/attendance_page.dart';
import 'package:controlbs_mobile/features/auth/presentation/page/auth_page.dart';
import 'package:controlbs_mobile/features/file/presentation/page/sign_page.dart';
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
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return const DetailsScreen();
          },
        ),
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
        )
      ],
    ),
  ],
);

import 'package:controlbs_mobile/config_theme.dart';
import 'package:controlbs_mobile/details.dart';
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
      ],
    ),
  ],
);

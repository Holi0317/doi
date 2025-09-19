import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/pages/home.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
    ),
  ],
  // TODO: Add error handling, for example:
  // errorBuilder: (context, state) => ErrorScreen(error: state.error!),
);

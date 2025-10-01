import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/pages/search.dart';
import 'package:mobile/pages/settings.dart';
import 'package:mobile/pages/shell.dart';
import 'package:mobile/pages/unread.dart';

final router = GoRouter(
  initialLocation: '/unread',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const Text('TODO: Login (init setup) page');
      },
    ),
    StatefulShellRoute.indexedStack(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            return Shell(navigationShell: navigationShell);
          },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/unread',
              builder: (BuildContext context, GoRouterState state) {
                return const UnreadPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (BuildContext context, GoRouterState state) {
                return const SearchPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) {
                return const SettingsPage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
  // TODO: Add error handling, for example:
  // errorBuilder: (context, state) => ErrorScreen(error: state.error!),
);

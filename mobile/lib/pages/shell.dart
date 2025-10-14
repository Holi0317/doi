import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/unauth_redirect.dart';

class Shell extends StatelessWidget {
  const Shell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return UnauthRedirect(
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.inbox), label: 'Unread'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (int tappedIndex) {
            navigationShell.goBranch(tappedIndex);
          },
        ),
      ),
    );
  }
}

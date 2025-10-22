import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/reselect.dart';

import '../components/events/unauth_redirect.dart';

class Shell extends StatelessWidget {
  const Shell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final notifier = ReselectNotifier();

    return ReselectScope(
      notifier: notifier,
      child: UnauthRedirect(
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
              if (tappedIndex == navigationShell.currentIndex) {
                notifier.notifyReselect();
              } else {
                navigationShell.goBranch(tappedIndex);
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/reselect.dart';

import '../components/events/unauth_redirect.dart';
import '../l10n/app_localizations.dart';

class Shell extends StatelessWidget {
  const Shell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final notifier = ReselectNotifier();
    final t = AppLocalizations.of(context)!;

    return ReselectScope(
      notifier: notifier,
      child: UnauthRedirect(
        child: Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.inbox),
                label: t.unread,
              ),
              NavigationDestination(
                icon: const Icon(Icons.search),
                label: t.search,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings),
                label: t.settings,
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

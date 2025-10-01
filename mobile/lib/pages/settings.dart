import 'package:flutter/material.dart';

import '../components/settings_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return const SettingsDialog();
            },
          );
        },
        child: const Text('Open'),
      ),
    );
  }
}

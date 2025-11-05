import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/settings/app_version_tile.dart';
import 'package:mobile/components/settings/theme_select_tile.dart';
import 'package:mobile/components/settings/whoami.dart';

import '../l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          // User Profile Section
          Whoami(),

          const Divider(),

          // Preferences Section
          _buildPreferencesSection(context, ref),

          const Divider(),

          // App Info Section
          _buildAppInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            t.preferences,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Theme Selection
        const ThemeSelectTile(),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            t.about,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // App Version
        const AppVersionTile(),
        // Help & Support
        ListTile(
          leading: const Icon(Icons.help),
          title: Text(t.helpSupport),
          onTap: () {
            // TODO: Implement help link
            debugPrint('Navigate to help page');
          },
        ),
        // Acknowledgements
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: Text(t.acknowledgements),
          onTap: () {
            // TODO: Implement acknowledgements
            _showAcknowledgementsDialog(context);
          },
        ),
      ],
    );
  }

  void _showAcknowledgementsDialog(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.acknowledgements),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Libraries and Resources',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Flutter - UI toolkit for building beautiful applications',
              ),
              Text('• Riverpod - State management solution'),
              Text('• Other dependencies...'),
              SizedBox(height: 16),
              Text(
                'Contributors',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Team members and contributors'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

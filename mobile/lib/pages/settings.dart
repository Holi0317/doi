import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/settings/theme.dart';
import 'package:mobile/components/settings/whoami.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // User Profile Section
          SettingsWhoami(),

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            'Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Language Selection
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('English'), // TODO: Get from provider
          onTap: () {
            // TODO: Implement language selection
            _showLanguageSelectionDialog(context);
          },
        ),
        // Theme Selection
        const ThemeSelectTile(),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // App Version
        const ListTile(
          leading: Icon(Icons.info),
          title: Text('App Version'),
          subtitle: Text('1.0.0'), // TODO: Get actual app version
        ),
        // Help & Support
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          onTap: () {
            // TODO: Implement help link
            debugPrint('Navigate to help page');
          },
        ),
        // Acknowledgements
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Acknowledgements'),
          onTap: () {
            // TODO: Implement acknowledgements
            _showAcknowledgementsDialog(context);
          },
        ),
      ],
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    final languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Japanese',
      'Chinese',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(languages[index]),
                onTap: () {
                  // TODO: Update language preference
                  debugPrint('Selected language: ${languages[index]}');
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAcknowledgementsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acknowledgements'),
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

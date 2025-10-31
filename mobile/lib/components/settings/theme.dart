import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/shared_preferences.dart';

class ThemeSelectTile extends ConsumerWidget {
  const ThemeSelectTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(preferenceProvider(SharedPreferenceKey.theme));

    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Theme'),
      subtitle: Text(switch (a.value) {
        'light' => 'Light',
        'dark' => 'Dark',
        'system' || null || _ => 'System Default',
      }),
      onTap: () {
        _showThemeSelectionDialog(context, ref);
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Theme'),
        children: [
          _buildOption(context, ref, 'Light', 'light'),
          _buildOption(context, ref, 'Dark', 'dark'),
          _buildOption(context, ref, 'System Default', 'system'),
        ],
      ),
    );
  }

  SimpleDialogOption _buildOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    String value,
  ) {
    return SimpleDialogOption(
      onPressed: () async {
        await ref
            .read(preferenceProvider(SharedPreferenceKey.theme).notifier)
            .set(value);

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(label),
      ),
    );
  }
}

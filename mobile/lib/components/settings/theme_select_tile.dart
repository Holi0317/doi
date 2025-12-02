import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';
import '../../providers/bindings/shared_preferences.dart';

class ThemeSelectTile extends ConsumerWidget {
  const ThemeSelectTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(preferenceProvider(SharedPreferenceKey.theme));

    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: Text(t.settings.theme.title),
      subtitle: Text(switch (a.value) {
        'light' => t.settings.theme.light,
        'dark' => t.settings.theme.dark,
        'system' || null || _ => t.settings.theme.dark,
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
        title: Text(t.settings.theme.select),
        children: [
          _buildOption(context, ref, t.settings.theme.light, 'light'),
          _buildOption(context, ref, t.settings.theme.dark, 'dark'),
          _buildOption(context, ref, t.settings.theme.system, 'system'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';
import '../../providers/extensions.dart';
import '../../providers/package_info.dart';
import 'app_version_dialog.dart';

class AppVersionTile extends ConsumerWidget {
  const AppVersionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(
      packageInfoProvider.selectData((info) => info.version),
    );

    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(t.settings.appVersion),
      subtitle: Text(version.value ?? t.dialogs.loading),
      onTap: () {
        _showDialog(context);
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AppVersionDialog(),
    );
  }
}

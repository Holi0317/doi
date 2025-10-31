import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/settings/app_version_dialog.dart';
import 'package:mobile/providers/extensions.dart';
import 'package:mobile/providers/package_info.dart';

class AppVersionTile extends ConsumerWidget {
  const AppVersionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(
      packageInfoProvider.selectData((info) => info.version),
    );

    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text('App Version'),
      subtitle: Text(version.value ?? 'Loading...'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../i18n/strings.g.dart';
import '../../providers/package_info.dart';
import 'app_version_dialog.dart';

class AppVersionTile extends ConsumerWidget {
  const AppVersionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);

    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(t.settings.appVersion),
      subtitle: Text(packageInfo.value?.version ?? t.dialogs.loading),
      onTap: () {
        _showDialog(context, packageInfo.value);
      },
    );
  }

  void _showDialog(BuildContext context, PackageInfo? packageInfo) {
    showAboutDialog(
      context: context,
      applicationName: packageInfo?.appName,
      applicationVersion: packageInfo?.version,
      applicationIcon: const Icon(Icons.info),
      children: const [AppVersionDialog()],
    );
  }
}

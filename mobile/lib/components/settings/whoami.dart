import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import '../../i18n/strings.g.dart';
import '../../models/server_info.dart';
import '../../providers/api.dart';
import '../../providers/extensions.dart';
import '../../providers/queue.dart';
import '../../providers/shared_preferences.dart';
import '../shimmer.dart';

class Whoami extends ConsumerWidget {
  Whoami({super.key});

  final _logger = Logger('SettingsWhoami');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(
      serverInfoProvider.selectData((value) => value.session),
    );

    final apiUrl = ref.watch(
      preferenceProvider(
        SharedPreferenceKey.apiUrl,
      ).selectData((value) => value.isEmpty ? null : Uri.parse(value)),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: switch (session) {
        AsyncValue(:final value!, hasValue: true) => _buildData(
          context,
          ref,
          value,
          apiUrl,
        ),
        AsyncValue(value: == null, hasValue: true) => _buildUnauth(context),
        AsyncValue(:final error?) => _buildError(context, error),
        AsyncValue() => _buildLoading(context),
      },
    );
  }

  Widget _buildData(
    BuildContext context,
    WidgetRef ref,
    Session session,
    AsyncValue<Uri?> apiUrl,
  ) {
    return Row(
      spacing: 16,
      children: [
        // User Avatar
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade300,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(session.avatarUrl),
            radius: 40,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: apiUrl.value == null
                    ? null
                    : () {
                        Clipboard.setData(
                          ClipboardData(text: apiUrl.value.toString()),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.settings.copyApiUrl)),
                        );
                      },
                child: Text(
                  t.settings.userLine(
                    login: session.login,
                    source: session.source,
                    host: apiUrl.value?.host ?? '',
                  ),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => _logoutDialog(context, ref),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, size: 20),
                    const SizedBox(width: 8),
                    Text(t.settings.logout.title),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnauth(BuildContext context) {
    return Text(t.settings.unauthenticated);
  }

  Widget _buildError(BuildContext context, Object error) {
    // TODO: Better error handling. Retry button, error message, and redirect to login.
    return Text('Error: $error');
  }

  Widget _buildLoading(BuildContext context) {
    return Shimmer(
      child: Row(
        spacing: 16,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logoutDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.logout.confirmDialog),
        content: Text(t.settings.logout.confirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.dialogs.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.settings.logout.title),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    if (!context.mounted) {
      _logger.warning('Context not mounted after logout confirmation dialog');
      return;
    }

    await _logout(context, ref);
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref
        .read(preferenceProvider(SharedPreferenceKey.apiToken).notifier)
        .reset();

    // Reset edit queues
    ref.read(editQueueProvider.notifier).reset();
    ref.read(insertQueueProvider.notifier).reset();

    if (!context.mounted) {
      _logger.warning('Context not mounted after clearing preferences');
      return;
    }

    context.go('/login');
  }
}

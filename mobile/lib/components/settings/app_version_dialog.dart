import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/version.dart';

class AppVersionDialog extends ConsumerWidget {
  const AppVersionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final line = ref.watch(appVersionLineProvider);

    return AlertDialog(
      title: const Text('App Version'),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: switch (line) {
            AsyncValue(:final value?, hasValue: true) => SelectableText(
              value,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
            AsyncValue(:final error?) => Text('Error: $error'),
            AsyncValue() => const CircularProgressIndicator(),
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _apiUrlController;
  late TextEditingController _apiTokenController;

  @override
  void initState() {
    super.initState();
    _apiUrlController = TextEditingController();
    _apiTokenController = TextEditingController();
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _apiTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiUrl = ref.watch(preferenceProvider(SharedPreferenceKey.apiUrl));
    apiUrl.whenData((value) => _apiUrlController.text = value);

    final apiToken = ref.watch(
      preferenceProvider(SharedPreferenceKey.apiToken),
    );
    apiToken.whenData((value) => _apiTokenController.text = value);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _apiUrlController,
              decoration: InputDecoration(
                labelText: 'API URL',
                error: apiUrl.error != null
                    ? Text(apiUrl.error!.toString())
                    : null,
              ),
              enabled: apiUrl.hasValue,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }

                // Basic URL validation
                // TODO: Check server info on submit
                final uri = Uri.tryParse(value);
                if (uri == null || !uri.isAbsolute) {
                  return 'Please enter a valid URL';
                }

                return null;
              },
            ),
            TextFormField(
              controller: _apiTokenController,
              decoration: InputDecoration(
                labelText: 'Api Token',
                error: apiToken.error != null
                    ? Text(apiToken.error!.toString())
                    : null,
              ),
              enabled: apiToken.hasValue,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );

    // actions: <Widget>[
    //   TextButton(
    //     style: TextButton.styleFrom(
    //       textStyle: Theme.of(context).textTheme.labelLarge,
    //     ),
    //     child: const Text('Discard'),
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //   ),
    //   TextButton(
    //     style: TextButton.styleFrom(
    //       textStyle: Theme.of(context).textTheme.labelLarge,
    //     ),
    //     onPressed: () async {
    //       // Disable button if loading/error
    //       if (!_formKey.currentState!.validate()) {
    //         return;
    //       }
    //
    //       final newUrl = _apiUrlController.text;
    //       final newToken = _apiTokenController.text;
    //
    //       try {
    //         await ref
    //             .read(preferenceProvider(SharedPreferenceKey.apiUrl).notifier)
    //             .set(newUrl);
    //         await ref
    //             .read(
    //               preferenceProvider(SharedPreferenceKey.apiToken).notifier,
    //             )
    //             .set(newToken);
    //
    //         if (context.mounted) {
    //           Navigator.of(context).pop();
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(content: Text('Updated setttings!')),
    //           );
    //         }
    //       } catch (e) {
    //         if (context.mounted) {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text('Failed to save new settings: $e')),
    //           );
    //         }
    //       }
    //     },
    //     child: const Text('Save'),
    //   ),
    // ],
  }

  Future<void> _submit() async {
    // Disable button if loading/error
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newUrl = _apiUrlController.text;
    final newToken = _apiTokenController.text;

    try {
      await ref
          .read(preferenceProvider(SharedPreferenceKey.apiUrl).notifier)
          .set(newUrl);
      await ref
          .read(preferenceProvider(SharedPreferenceKey.apiToken).notifier)
          .set(newToken);

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Updated setttings!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save new settings: $e')),
        );
      }
    }
  }
}

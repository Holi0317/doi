import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.isAbsolute) {
                    return 'Please enter a valid URL';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              // FIXME: Wizard setup for api token
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
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    // Disable button if loading/error
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newUrl = _apiUrlController.text;
    final newToken = _apiTokenController.text;

    // TODO: Validate server info on URL

    try {
      await ref
          .read(preferenceProvider(SharedPreferenceKey.apiUrl).notifier)
          .set(newUrl);
      await ref
          .read(preferenceProvider(SharedPreferenceKey.apiToken).notifier)
          .set(newToken);

      if (context.mounted) {
        context.go('/unread');
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

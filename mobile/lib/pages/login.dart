import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../i18n/strings.g.dart';
import '../providers/shared_preferences.dart';
import '../repositories/api.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _logger = Logger('LoginPage');

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _apiUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(preferenceProvider(SharedPreferenceKey.apiUrl), (
      previous,
      next,
    ) {
      if (next.value != null && next.value != previous?.value) {
        _apiUrlController.text = next.value!;
      }
    });

    final apiUrl = ref.watch(preferenceProvider(SharedPreferenceKey.apiUrl));

    return Scaffold(
      appBar: AppBar(title: Text(t.login.title)),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _apiUrlController,
                  decoration: InputDecoration(
                    labelText: t.login.apiUrlLabel,
                    error: apiUrl.error != null
                        ? Text(apiUrl.error!.toString())
                        : null,
                  ),
                  enabled: apiUrl.hasValue && !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.formErr.emptyValue;
                    }

                    // Basic URL validation
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return t.formErr.invalidUrl;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 48,
                        height: 40,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      FilledButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        onPressed: _login,
                        child: Text(t.login.loginButton),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    // Disable button if loading/error
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final u = Uri.parse(_apiUrlController.text);
      final apiUrl = u.replace(path: "/api").toString();
      final loginUrl = u
          .replace(path: "/auth/github/login", query: "redirect=doi:")
          .toString();

      // Validate server info on URL
      await _validateServer(apiUrl);

      // Authenticate with GitHub and get authorized callback URL
      final token = await _oauthLogin(loginUrl);
      if (token.isEmpty) {
        _showSnackBar(t.login.authFailedNoToken);
        return;
      }

      await ref
          .read(preferenceProvider(SharedPreferenceKey.apiToken).notifier)
          .set(token);
      await ref
          .read(preferenceProvider(SharedPreferenceKey.apiUrl).notifier)
          .set(apiUrl);

      if (context.mounted) {
        context.go('/unread');
      }
    } catch (e, st) {
      _logger.severe('Authentication failed', e, st);

      _showSnackBar(t.login.authFailedMessage(error: e.toString()));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _validateServer(String apiUrl) async {
    final httpClient = http.Client();
    final apiRepository = ApiRepository(
      transport: httpClient,
      baseUrl: apiUrl,
      authToken: '',
    );

    _logger.info('Validating server at $apiUrl');

    try {
      await apiRepository.info();
    } catch (e) {
      // FIXME: Error translation
      throw Exception('Unable to connect to server. Is the URL correct?: $e');
    }

    _logger.info('Server at $apiUrl is valid');
  }

  Future<String> _oauthLogin(String loginUrl) async {
    final result = await FlutterWebAuth2.authenticate(
      url: loginUrl,
      callbackUrlScheme: 'doi',
    );

    // Extract token from callback URL
    final uri = Uri.parse(result);
    final token = uri.queryParameters['token'] ?? '';

    return token;
  }

  void _showSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

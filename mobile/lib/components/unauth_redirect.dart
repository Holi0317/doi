import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/api.dart';

class UnauthRedirect extends ConsumerWidget {
  const UnauthRedirect({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next == AuthStateEnum.unauthenticated) {
        context.go("/login");
      }
    });

    return switch (authState) {
      AuthStateEnum.authenticated => child ?? const SizedBox.shrink(),
      AuthStateEnum.loading ||
      AuthStateEnum.unauthenticated ||
      AuthStateEnum.notConfig => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

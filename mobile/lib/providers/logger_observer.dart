import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class LoggerObserver extends ProviderObserver {
  const LoggerObserver();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    FlutterError.presentError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: "riverpod:${context.provider.name}",
      ),
    );
  }
}

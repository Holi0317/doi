import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:mobile/app_router.dart';
import 'package:mobile/components/events/sync_worker.dart';
import 'package:mobile/providers/logger_observer.dart';
import 'package:mobile/providers/shared_preferences.dart';
import 'package:mobile/repositories/retry.dart';

void main() {
  Logger.root.onRecord.listen((record) {
    final sb = StringBuffer()
      ..writeln(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
      );
    if (record.error != null) {
      sb.writeln('Error (${record.error.runtimeType}): ${record.error}');
    }
    if (record.stackTrace != null) {
      sb.writeln('StackTrace:\n${record.stackTrace}');
    }
    print(sb.toString());
  });

  runApp(
    ProviderScope(
      retry: retryStrategy,
      observers: [const LoggerObserver()],
      child: SyncWorkerWidget(
        child: Consumer(
          builder: (context, ref, child) {
            final themeAsync = ref.watch(
              preferenceProvider(SharedPreferenceKey.theme),
            );
            final themeMode = switch (themeAsync.value) {
              'light' => ThemeMode.light,
              'dark' => ThemeMode.dark,
              'system' || null || _ => ThemeMode.system,
            };

            return MaterialApp.router(
              routerConfig: router,
              // FIXME: Replace with a proper title
              title: 'Flutter Demo',
              themeMode: themeMode,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepPurple,
                  brightness: Brightness.dark,
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

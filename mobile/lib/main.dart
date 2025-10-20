import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:mobile/app_router.dart';
import 'package:mobile/components/events/sync_worker.dart';
import 'package:mobile/providers/logger_observer.dart';
import 'package:mobile/repositories/retry.dart';

void main() {
  Logger.root.onRecord.listen((record) {
    print(
      '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
    );
  });

  runApp(
    ProviderScope(
      retry: retryStrategy,
      observers: [const LoggerObserver()],
      child: SyncWorkerWidget(
        child: Consumer(
          builder: (context, ref, child) {
            return MaterialApp.router(
              routerConfig: router,
              // FIXME: Replace with a proper title
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
            );
          },
        ),
      ),
    ),
  );
}

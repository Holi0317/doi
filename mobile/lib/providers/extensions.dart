import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RefAbortTrigger on Ref {
  /// Create an abortTrigger for http library from riverpod [Ref].
  /// The returned future will be resolved when the ref is disposed.
  Future<void> abortTrigger() {
    final completer = Completer<void>();
    onDispose(completer.complete);
    return completer.future;
  }
}

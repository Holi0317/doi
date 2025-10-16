import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

extension RefAbortTrigger on Ref {
  /// Create an abortTrigger for http library from riverpod [Ref].
  /// The returned future will be resolved when the ref is disposed.
  Future<void> abortTrigger() {
    final completer = Completer<void>();
    onDispose(completer.complete);
    return completer.future;
  }
}

extension ProviderListenableSelectData<InT>
    on ProviderListenable<AsyncValue<InT>> {
  /// Similar to [ProviderListenable.select], but works on [AsyncValue] and only selects
  /// on successful data.
  ProviderListenable<AsyncValue<OutT>> selectData<OutT>(
    OutT Function(InT value) selector,
  ) {
    return ProviderListenableSelect(this).select((v) => v.whenData(selector));
  }
}

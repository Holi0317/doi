import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_handler/share_handler.dart';

part 'share_handler.g.dart';

@Riverpod(keepAlive: true)
ShareHandlerPlatform _shareHandlerPlatform(Ref ref) {
  return ShareHandlerPlatform.instance;
}

/// Stream of shared media received.
///
/// Currently this means links shared to the app.
@riverpod
Stream<SharedMedia> sharedMedia(Ref ref) async* {
  final instance = ref.watch(_shareHandlerPlatformProvider);

  final init = await instance.getInitialSharedMedia();
  if (init != null) {
    yield init;
  }

  yield* instance.sharedMediaStream;
}

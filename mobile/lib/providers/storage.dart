import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';

part 'storage.g.dart';

/// SQFlite-based persistent storage for Riverpod state persistence.
@riverpod
Future<Storage<String, String>> storage(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return JsonSqFliteStorage.open(join(dir.path, 'riverpod.db'));
}

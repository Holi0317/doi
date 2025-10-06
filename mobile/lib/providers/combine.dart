import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/models/edit_op.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/models/search_response.dart';
import 'package:mobile/providers/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/search_query.dart';
import 'api.dart';

part 'combine.g.dart';

/// Combines [search] with [EditQueue] to apply pending edits to search results.
@riverpod
Future<SearchResponse> searchApplied(Ref ref, SearchQuery query) async {
  final response = await ref.watch(searchProvider(query).future);
  final queue = await ref.watch(editQueueByIdProvider.future);

  final items = response.items
      .map((link) => link.applyEdits(queue[link.id] ?? const []))
      .nonNulls
      .where((link) => link.matchesQuery(query))
      .toList();

  return response.copyWith(items: items);
}

extension on Link {
  /// Applies a list of edit operations [EditOp] to this [Link] and returns applied result as a copy.
  ///
  /// If a delete operation is found, returns null. You might want to filter out nulls after applying edits.
  Link? applyEdits(List<EditOp> ops) {
    if (ops.isEmpty) {
      return this;
    }

    var result = this;

    for (var op in ops) {
      switch (op) {
        case EditOpSet():
          result = result.copyWith(
            favorite: op.field == EditOpField.favorite
                ? op.value
                : result.favorite,
            archive: op.field == EditOpField.archive
                ? op.value
                : result.archive,
          );
        case EditOpDelete():
          return null;
      }
    }

    return result;
  }

  /// Checks if this link matches the given [SearchQuery].
  ///
  /// Note: This only checks favorite and archive fields, which are the only editable fields by [EditOp].
  bool matchesQuery(SearchQuery query) {
    if (query.favorite != null && favorite != query.favorite) {
      return false;
    }

    if (query.archive != null && archive != query.archive) {
      return false;
    }

    // Add more field checks as necessary
    return true;
  }
}

/// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
///
/// This uses [searchApplied] to get search results, with edits from [EditQueue] applied to the result.
///
/// [query] is the query for first page. After that, this provider will fetch pages with given [cursors] parameter.
/// Widget should keep a list of cursors that needs to be fetched. You can get the cursor from `state.keys!.last`.
/// Make sure to check that cursor as non-empty string. The page might be in loading or error state and we use empty
/// string here as filler. This provider will assert that all cursors are non-empty string.
///
/// WARN: [cursors] list must be immutable for riverpod's change detection to work.
@riverpod
PagingState<String, Link> searchPaginated(
  Ref ref,
  SearchQuery query,
  List<String> cursors,
) {
  assert(
    cursors.every((c) => c.isNotEmpty),
    "Cursors must not be empty string.",
  );

  final queries = [
    query,
    ...cursors.map((cursor) => query.copyWith(cursor: cursor)),
  ];

  final values = queries
      .map((q) => ref.watch(searchAppliedProvider(q)))
      .toList();

  final loaded = values.map((v) => v.value).nonNulls.toList();

  return PagingState(
    isLoading: values.any((v) => v.isLoading),
    hasNextPage: values.last.value?.hasMore ?? false,
    error: values.where((v) => v.error != null).firstOrNull?.error,
    // pages and keys need to be null for first page loading state
    pages: loaded.isEmpty ? null : loaded.map((v) => v.items).toList(),
    keys: loaded.isEmpty ? null : loaded.map(((v) => v.cursor ?? '')).toList(),
  );
}

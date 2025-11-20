import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'search_query.freezed.dart';

/// Query on searching API
@freezed
abstract class SearchQuery with _$SearchQuery {
  const SearchQuery._();

  @Assert('limit >= 1 && limit <= 300', 'Limit must be between 1 and 300')
  const factory SearchQuery({
    /// Search query. This will search both title and url.
    /// null / empty string will all be treated as disable search filter.
    String? query,

    /// Cursor for pagination.
    /// null / empty string will be treated as noop.
    /// Note the client must keep other search parameters the same when paginating.
    String? cursor,

    /// Archive filter. Null means disable filter.
    /// Boolean means the item must be archived or not archived.
    bool? archive,

    /// Favorite filter.
    /// Null means disable filter. Boolean means the item must be favorited or not favorited.
    bool? favorite,

    /// Limit items to return.
    @Default(30) int limit,

    /// Order in result. Can only sort by id.
    /// id correlates to created_at timestamp, so this sorting is effectively link insert time.
    @Default(SearchOrder.idDesc) SearchOrder order,
  }) = _SearchQuery;

  Map<String, String> toMap() {
    final map = <String, String>{};

    if (query != null && query!.isNotEmpty) {
      map['query'] = query!;
    }

    if (cursor != null && cursor!.isNotEmpty) {
      map['cursor'] = cursor!;
    }

    if (archive != null) {
      map['archive'] = archive.toString();
    }

    if (favorite != null) {
      map['favorite'] = favorite.toString();
    }

    map['limit'] = limit.toString();
    map['order'] = order.value;

    return map;
  }
}

enum SearchOrder {
  idAsc('id_asc'),
  idDesc('id_desc');

  const SearchOrder(this.value);

  final String value;
}

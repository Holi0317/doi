/// Query on searching API
class SearchQuery {
  /// Search query. This will search both title and url.
  /// null / empty string will all be treated as disable search filter.
  final String? query;

  /// Cursor for pagination.
  /// null / empty string will be treated as noop.
  /// Note the client must keep other search parameters the same when paginating.
  final String? cursor;

  /// Archive filter. Null means disable filter.
  /// Boolean means the item must be archived or not archived.
  final bool? archive;

  /// Favorite filter.
  /// Null means disable filter. Boolean means the item must be favorited or not favorited.
  final bool? favorite;

  /// Limit items to return.
  final int limit;

  /// Order in result. Can only sort by id.
  /// id correlates to created_at timestamp, so this sorting is effectively link insert time.
  final SearchOrder order;

  SearchQuery({
    this.query,
    this.cursor,
    this.archive,
    this.favorite,
    this.limit = 30,
    this.order = SearchOrder.idDesc,
  }) {
    if (limit < 1 || limit > 300) {
      throw ArgumentError('Limit must be between 1 and 300');
    }
  }

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

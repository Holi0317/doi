import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/models/search_query.dart';

import '../providers/api.dart';
import '../providers/combine.dart';
import 'link_tile.dart';
import 'link_tile_shimmer.dart';

class LinkList extends ConsumerStatefulWidget {
  const LinkList({super.key, required this.query});

  /// SearchQuery for the first page
  final SearchQuery query;

  @override
  ConsumerState<LinkList> createState() => _LinkListState();
}

class _LinkListState extends ConsumerState<LinkList> {
  List<String> _cursors = const [];

  void _fetchNextPage(PagingState<String, Link> state) {
    if (state.isLoading) {
      return;
    }

    if (!state.hasNextPage) {
      return;
    }

    final nextCursor = state.keys!.last;
    if (nextCursor == "") {
      return;
    }

    setState(() {
      _cursors = List.unmodifiable([..._cursors, nextCursor]);
    });
  }

  void _refresh() {
    setState(() {
      _cursors = const [];
    });

    // Invalidate all search provider. Might be invalidating too much but better sorry than stale.
    ref.invalidate(searchProvider);
  }

  Widget _buildFirstPageLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 1.5,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 50,
        itemBuilder: (context, index) => const LinkTileShimmer(),
      ),
    );
  }

  Widget _buildNewPageLoadingIndicator(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => const LinkTileShimmer()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchPaginatedProvider(widget.query, _cursors));

    return RefreshIndicator(
      onRefresh: () async {
        _refresh();
      },
      child: PagedListView<String, Link>(
        state: state,
        fetchNextPage: () {
          _fetchNextPage(state);
        },
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => LinkTile(item: item),
          animateTransitions: true,
          firstPageProgressIndicatorBuilder: _buildFirstPageLoadingIndicator,
          newPageProgressIndicatorBuilder: _buildNewPageLoadingIndicator,
        ),
      ),
    );
  }
}

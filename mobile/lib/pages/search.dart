import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/filter_overlay.dart';
import 'package:mobile/models/search_query.dart';

import '../components/edit_app_bar.dart';
import '../components/link_list.dart';
import '../models/link_action.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  Set<int> _selection = {};
  var query = const SearchQuery();

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = _selection.isEmpty
        ? AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: SizedBox(
              height: kToolbarHeight - 12,
              child: TextField(
                autofocus: true,
                onChanged: (value) =>
                    setState(() => query = query.copyWith(query: value)),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  suffixIcon: IconButton(
                    tooltip: "Filter",
                    icon: Icon(
                      Icons.filter_alt,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => _openFilter(context),
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
          )
        : EditAppBar(
            selection: _selection,
            onSelectionChanged: _onSelectionChanged,
            actions: [LinkAction.archive, LinkAction.favorite],
            menuActions: [
              LinkAction.unarchive,
              LinkAction.unfavorite,
              LinkAction.delete,
            ],
          );

    return Scaffold(
      appBar: appBar,
      body: LinkList(
        query: query,
        selection: _selection,
        onSelectionChanged: _onSelectionChanged,
      ),
    );
  }

  void _openFilter(BuildContext context) {
    FilterOverlay.show(
      context,
      query: query,
      onQueryChanged: (newQuery) {
        setState(() {
          query = newQuery;
        });
      },
    );
  }

  void _onSelectionChanged(Set<int> next) {
    setState(() {
      _selection = next;
    });
  }
}

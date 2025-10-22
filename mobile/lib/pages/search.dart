import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/filter_overlay.dart';
import 'package:mobile/models/search_query.dart';

import '../components/link_list.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  var query = const SearchQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      // FIXME: Implemenet selection
      body: LinkList(query: query, selection: {}, onSelectionChanged: (_) {}),
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
}

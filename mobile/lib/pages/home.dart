import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/search_query.dart';
import '../provider.dart';
import '../components/link_tile.dart';
import '../models/link.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIXME: Add infinite scrolling
    final val = ref.watch(searchProvider(SearchQuery()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          val.value == null ? 'Unread' : 'Unread (${val.value!.count})',
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.0),
          child: val.isLoading ? LinearProgressIndicator() : Container(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(searchProvider(SearchQuery()).future),
        child: switch (val) {
          AsyncValue(:final value?) => _listBuilder(context, value.items),
          AsyncValue(:final error?) => Text(error.toString()),
          AsyncValue() => Text('Loading shimmer (TODO)'),
        },
      ),
    );
  }

  Widget _listBuilder(BuildContext context, List<Link> value) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: value.length,
      itemBuilder: (BuildContext context, int index) {
        return LinkTile(item: value[index]);
      },
    );
  }
}

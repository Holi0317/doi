import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/link_tile.dart';
import '../models/link.dart';
import '../models/search_query.dart';
import '../providers/api.dart';

class UnreadPage extends ConsumerWidget {
  const UnreadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadSearchQuery = const SearchQuery();
    final asyncValue = ref.watch(searchProvider(unreadSearchQuery));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          asyncValue.value?.count == null
              ? 'Unread'
              : 'Unread (${asyncValue.value!.count})',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          // Show progress only if it's loading
          child: (asyncValue.isLoading)
              ? const LinearProgressIndicator()
              : Container(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(searchProvider(unreadSearchQuery).future),
        child: switch (asyncValue) {
          AsyncValue(:final value?) => _listBuilder(context, value.items),
          AsyncValue(:final error?) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
          AsyncValue() => const Center(
            child: Text('Loading shimmer (TODO)'),
          ), // https://docs.flutter.dev/cookbook/effects/shimmer-loading
        },
      ),
    );
  }

  Widget _listBuilder(BuildContext context, List<Link> value) {
    if (value.isEmpty) {
      return const Center(child: Text('No unread items.'));
    }
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: value.length,
      itemBuilder: (BuildContext context, int index) {
        return LinkTile(item: value[index]);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/link_list.dart';

import '../models/search_query.dart';

class UnreadPage extends ConsumerWidget {
  const UnreadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadSearchQuery = const SearchQuery(archive: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Unread'),
      ),
      body: LinkList(query: unreadSearchQuery),
    );
  }
}

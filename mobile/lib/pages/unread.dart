import 'package:flutter/material.dart';
import 'package:mobile/components/edit_app_bar.dart';
import 'package:mobile/components/link_list.dart';

import '../models/link_action.dart';
import '../models/search_query.dart';

class UnreadPage extends StatefulWidget {
  const UnreadPage({super.key});

  @override
  State<UnreadPage> createState() => _UnreadPageState();
}

class _UnreadPageState extends State<UnreadPage> {
  Set<int> _selection = {};

  @override
  Widget build(BuildContext context) {
    final unreadSearchQuery = const SearchQuery(archive: false);

    final PreferredSizeWidget appBar = _selection.isEmpty
        ? AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // FIXME: Add unread count
            title: const Text('Unread'),
          )
        : EditAppBar(
            selection: _selection,
            onSelectionChanged: _onSelectionChanged,
            actions: [LinkAction.delete, LinkAction.archive],
          );

    return Scaffold(
      appBar: appBar,
      body: LinkList(
        query: unreadSearchQuery,
        selection: _selection,
        onSelectionChanged: _onSelectionChanged,
      ),
    );
  }

  void _onSelectionChanged(Set<int> next) {
    setState(() {
      _selection = next;
    });
  }
}

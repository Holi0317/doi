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
  SearchOrder _order = SearchOrder.idDesc;

  @override
  Widget build(BuildContext context) {
    final unreadSearchQuery = SearchQuery(archive: false, order: _order);

    final PreferredSizeWidget appBar = _selection.isEmpty
        ? AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // FIXME: Add unread count
            title: const Text('Unread'),
            actions: [_sortAction(context)],
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

  Widget _sortAction(BuildContext context) {
    return IconButton(
      icon: Icon(
        _order == SearchOrder.idAsc ? Icons.arrow_upward : Icons.arrow_downward,
      ),
      tooltip:
          'Toggle sort order (currently ${_order == SearchOrder.idAsc ? "oldest first" : "newest first"})',
      onPressed: () {
        setState(() {
          _order = _order == SearchOrder.idAsc
              ? SearchOrder.idDesc
              : SearchOrder.idAsc;
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

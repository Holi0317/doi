import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/components/edit_app_bar.dart';
import 'package:mobile/components/link_list.dart';
import 'package:mobile/providers/combine.dart';
import 'package:mobile/providers/extensions.dart';

import '../models/link_action.dart';
import '../models/search_query.dart';

class UnreadPage extends ConsumerStatefulWidget {
  const UnreadPage({super.key});

  @override
  ConsumerState<UnreadPage> createState() => _UnreadPageState();
}

class _UnreadPageState extends ConsumerState<UnreadPage> {
  Set<int> _selection = {};
  SearchOrder _order = SearchOrder.idDesc;

  @override
  Widget build(BuildContext context) {
    final unreadSearchQuery = SearchQuery(archive: false, order: _order);

    final count = ref.watch(
      searchAppliedProvider(
        unreadSearchQuery,
      ).selectData((data) => NumberFormat.compact().format(data.count)),
    );

    final PreferredSizeWidget appBar = _selection.isEmpty
        ? AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: switch (count) {
              AsyncValue(:final value?, hasValue: true) => Text(
                'Unread ($value)',
              ),
              _ => const Text('Unread'),
            },
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

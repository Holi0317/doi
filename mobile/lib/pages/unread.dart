import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/edit_app_bar.dart';
import '../components/link_list.dart';
import '../components/reselect.dart';
import '../i18n/strings.g.dart';
import '../models/link_action.dart';
import '../models/search_query.dart';
import '../providers/api/search.dart';
import '../providers/extensions.dart';

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
      searchAppliedProvider(unreadSearchQuery).selectData((data) => data.count),
    );

    final PreferredSizeWidget appBar = _selection.isEmpty
        ? AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: switch (count) {
              // FIXME: Count is inaccurate when there are pending edits in queue.
              AsyncValue(:final value?, hasValue: true) => Text(
                t.unread.title(count: value),
              ),
              _ => Text(t.nav.unread),
            },
            actions: [_sortAction(context)],
          )
        : EditAppBar(
            selection: _selection,
            onSelectionChanged: _onSelectionChanged,
            actions: [LinkAction.delete, LinkAction.archive],
          );

    return ReselectListener(
      onReselect: () {
        // FIXME(desktop): LinkList is probably isn't a primary scroller on desktop
        // See https://api.flutter.dev/flutter/widgets/PrimaryScrollController-class.html
        PrimaryScrollController.of(context).animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: Scaffold(
        appBar: appBar,
        body: LinkList(
          query: unreadSearchQuery,
          dismissible: true,
          selection: _selection,
          onSelectionChanged: _onSelectionChanged,
        ),
      ),
    );
  }

  Widget _sortAction(BuildContext context) {
    return IconButton(
      icon: Icon(
        _order == SearchOrder.idAsc ? Icons.arrow_upward : Icons.arrow_downward,
      ),
      tooltip: _order == SearchOrder.idAsc
          ? t.unread.toggleSortingAsc
          : t.unread.toggleSortingDesc,
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

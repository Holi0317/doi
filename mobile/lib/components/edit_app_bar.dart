import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/models/link_action.dart';
import 'package:mobile/providers/queue.dart';

import '../models/edit_op.dart';

/// [AppBar] used in selection mode
class EditAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const EditAppBar({
    super.key,
    this.actions = const [],
    this.menuActions = const [],
    required this.selection,
    required this.onSelectionChanged,
  });

  /// List of actions to show on app bar
  final List<LinkAction> actions;

  /// List of actions to show in overflow menu
  final List<LinkAction> menuActions;

  final Set<int> selection;
  final void Function(Set<int>) onSelectionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('${selection.length} items'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: "Cancel selection",
        onPressed: _endSelection,
      ),
      actions: [
        for (final action in actions)
          IconButton(
            icon: Icon(action.icon),
            tooltip: action.label,
            onPressed: () => _handleAction(context, ref, action),
          ),

        if (menuActions.isNotEmpty)
          PopupMenuButton<LinkAction>(
            icon: const Icon(Icons.more_vert),
            tooltip: "More actions",
            itemBuilder: (context) =>
                menuActions.map((action) => action.popup()).toList(),
            onSelected: (action) => _handleAction(context, ref, action),
          ),
      ],
    );
  }

  void _endSelection() {
    onSelectionChanged(const {});
  }

  // Absolute no idea what this is. But required to satisfy Scaffold's appBar property.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleAction(BuildContext context, WidgetRef ref, LinkAction action) {
    switch (action) {
      case LinkAction.delete:
        _showDeleteDialog(context, ref);
      case LinkAction.archive:
        _edit(ref, EditOpField.archive, true);
      case LinkAction.unarchive:
        _edit(ref, EditOpField.archive, false);
      case LinkAction.favorite:
        _edit(ref, EditOpField.favorite, true);
      case LinkAction.unfavorite:
        _edit(ref, EditOpField.favorite, false);
      case LinkAction.share:
        throw UnimplementedError();
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${selection.length} links permanently?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is permanent and cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    final queue = ref.read(editQueueProvider.notifier);
    queue.addAll(selection.map((id) => EditOp.delete(id: id)));

    _endSelection();
  }

  void _edit(WidgetRef ref, EditOpField field, bool value) {
    final queue = ref.read(editQueueProvider.notifier);
    queue.addAll(
      selection.map((id) => EditOp.set(id: id, field: field, value: value)),
    );

    _endSelection();
  }
}

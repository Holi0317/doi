import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/providers/queue.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/edit_op.dart';
import '../models/link.dart';
import '../models/link_action.dart';
import 'link_image_preview.dart';

class LinkTile extends ConsumerStatefulWidget {
  const LinkTile({
    super.key,
    required this.item,
    this.selecting = false,
    this.selected = false,
    this.onSelect,
  });

  final Link item;
  final bool selecting;
  final bool selected;
  final void Function(bool selected)? onSelect;

  @override
  ConsumerState<LinkTile> createState() => _LinkTileState();
}

class _LinkTileState extends ConsumerState<LinkTile>
    with TickerProviderStateMixin {
  late final controller = SlidableController(this);

  // FIXME: Handle url parsing error
  late final uri = Uri.parse(widget.item.url);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.item.id),
      controller: controller,
      enabled: !widget.selecting,

      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,

        children: [
          if (widget.item.favorite)
            LinkAction.unfavorite.slideable(
              (context) => _edit(EditOpField.favorite, false),
            )
          else
            LinkAction.favorite.slideable(
              (context) => _edit(EditOpField.favorite, true),
            ),
        ],
      ),

      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,

        // FIXME: Only allow archive if query is filtering for unarchived items
        dismissible: DismissiblePane(
          onDismissed: () => _edit(EditOpField.archive, true),
        ),

        children: [
          // FIXME: Icon animation....?
          LinkAction.share.slideable((context) => _share()),
          if (widget.item.archive)
            LinkAction.unarchive.slideable(
              (context) => _edit(EditOpField.archive, false),
            )
          else
            LinkAction.archive.slideable(
              (context) => _edit(EditOpField.archive, true),
            ),
        ],
      ),

      child: ListTile(
        title: Text(
          widget.item.title.isEmpty ? uri.toString() : widget.item.title,
        ),
        subtitle: Row(
          children: [
            Flexible(
              child: Text(
                uri.host,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.item.favorite)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
          ],
        ),
        selected: widget.selected,
        selectedColor: Theme.of(context).colorScheme.onSurface,
        selectedTileColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        leading: LinkImagePreview(item: widget.item),
        trailing: widget.selecting
            ? Checkbox(value: widget.selected, onChanged: null)
            : null,
        onTap: () {
          if (widget.selecting) {
            widget.onSelect?.call(!widget.selected);
            return;
          }

          _open();
        },
        onLongPress: widget.selecting
            ? null
            : () {
                widget.onSelect?.call(true);
              },
        // TODO: Start selection mode on long press
      ),
    );
  }

  Future<void> _open() async {
    // TODO: Add action button in custom tabs. Might need to write native code for that.
    // See https://developer.chrome.com/docs/android/custom-tabs/guide-interactivity
    // For now open the drawer after opening the link for archive
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
      webOnlyWindowName: "_blank",
    );

    if (!opened) {
      throw Exception('Could not launch $uri');
    }

    await controller.openEndActionPane();
  }

  Future<void> _edit(EditOpField field, bool value) async {
    final queue = ref.read(editQueueProvider.notifier);
    queue.add(EditOp.set(field: field, id: widget.item.id, value: value));
  }

  Future<void> _share() async {
    await SharePlus.instance.share(ShareParams(uri: uri));
  }
}

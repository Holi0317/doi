import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/providers/queue.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/edit_op.dart';
import '../models/link.dart';
import 'link_image_preview.dart';

enum LinkAction {
  // FIXME: Fix the colors. They are super ugly right now
  archive(Icons.archive, 'Archive', Colors.lime),
  unarchive(Icons.unarchive, 'Unarchive', Colors.lime),
  favorite(Icons.favorite, 'Favorite', Colors.lightBlue),
  unfavorite(Icons.favorite_border, 'Unfavorite', Colors.lightBlue),
  share(Icons.share, 'Share', Colors.amber),
  delete(Icons.delete, 'Delete', Colors.red),
  select(Icons.check, 'Select', Colors.pinkAccent);

  final IconData icon;
  final String label;
  final Color color;

  const LinkAction(this.icon, this.label, this.color);

  PopupMenuItem<LinkAction> popup() {
    return PopupMenuItem<LinkAction>(
      value: this,
      child: ListTile(leading: Icon(icon), title: Text(label)),
    );
  }

  SlidableAction slideable(void Function(BuildContext) onPressed) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: color,
      foregroundColor: color.computeLuminance() > 0.5
          ? Colors.black87
          : Colors.white,
      icon: icon,
      label: label,
    );
  }
}

class LinkTile extends ConsumerStatefulWidget {
  const LinkTile({super.key, required this.item});

  final Link item;

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
            Text(uri.host),
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
        leading: LinkImagePreview(item: widget.item),
        onTap: _open,
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

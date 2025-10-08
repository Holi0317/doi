import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/providers/queue.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/edit_op.dart';
import '../models/link.dart';
import 'link_image_preview.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

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

      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,

        // FIXME: Archive animation
        // FIXME: Only allow archive if query is filtering for unarchived items
        dismissible: DismissiblePane(onDismissed: _archive),

        children: [
          SlidableAction(
            onPressed: (context) => _archive(),
            backgroundColor: Colors.lime,
            foregroundColor: Colors.black87,
            icon: Icons.archive,
            label: 'Archive',
          ),
        ],
      ),

      child: GestureDetector(
        onLongPressStart: (details) {
          Feedback.forLongPress(context);
          _showContextMenu(context, details.globalPosition);
        },
        onSecondaryTapDown: (details) {
          _showContextMenu(context, details.globalPosition);
        },
        child: ListTile(
          title: Text(
            widget.item.title.isEmpty ? uri.toString() : widget.item.title,
          ),
          subtitle: Text(uri.host),
          leading: LinkImagePreview(item: widget.item),
          onTap: _open,
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset globalPosition) async {
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay == null) return;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(globalPosition, globalPosition),
      Offset.zero & (overlay as RenderBox).size,
    );

    final selected = await showMenu<SampleItem>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Item 1'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: Text('Item 2'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          child: Text('Item 3'),
        ),
      ],
    );

    // TODO: Handle selected item command
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

  Future<void> _archive() async {
    final queue = ref.read(editQueueProvider.notifier);
    queue.add(
      EditOp.set(field: EditOpField.archive, id: widget.item.id, value: true),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../container/link.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class LinkTile extends StatelessWidget {
  const LinkTile({super.key, required this.item});

  final Link item;

  void _showContextMenu(BuildContext context, Offset globalPosition) async {
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay == null) return;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        globalPosition,
        globalPosition,
      ),
      Offset.zero & (overlay as RenderBox).size,
    );

    final selected = await showMenu<SampleItem>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<SampleItem>(value: SampleItem.itemOne, child: Text('Item 1')),
        const PopupMenuItem<SampleItem>(value: SampleItem.itemTwo, child: Text('Item 2')),
        const PopupMenuItem<SampleItem>(value: SampleItem.itemThree, child: Text('Item 3')),
      ],
    );

    // TODO: Handle selected item command
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('value'),
      // FIXME: Add archive icon, and animate it
      background: Container(color: Colors.purple),
      child: GestureDetector(
        onLongPressStart: (details) {
          _showContextMenu(context, details.globalPosition);
        },
        onForcePressStart: (details) {
          _showContextMenu(context, details.globalPosition);
        },
        onSecondaryTapDown: (details) {
          _showContextMenu(context, details.globalPosition);
        },
        child: ListTile(
          title: Text(item.title),
          subtitle: Text(item.uri.host),
          onTap: () async {
            await launchUrl(
              item.uri,
              mode: LaunchMode.inAppBrowserView,
              webOnlyWindowName: "_blank",
            );
          },
        ),
      ),
    );
  }
}

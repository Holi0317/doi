import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Enum of actions that can be performed on a link.
enum LinkAction {
  // FIXME: Fix the colors. They are super ugly right now
  archive(Icons.archive, 'Archive', Colors.lime),
  unarchive(Icons.unarchive, 'Unarchive', Colors.lime),
  favorite(Icons.favorite, 'Favorite', Colors.lightBlue),
  unfavorite(Icons.favorite_border, 'Unfavorite', Colors.lightBlue),
  share(Icons.share, 'Share', Colors.amber),
  delete(Icons.delete, 'Delete', Colors.red);

  final IconData icon;
  final String label;
  final Color color;

  const LinkAction(this.icon, this.label, this.color);

  /// Create a [PopupMenuItem] for this action for use in menus.
  PopupMenuItem<LinkAction> popup() {
    return PopupMenuItem<LinkAction>(
      value: this,
      child: ListTile(leading: Icon(icon), title: Text(label)),
    );
  }

  /// Create a [SlidableAction] for this action for use in flutter_slidable.
  ///
  /// [onPressed] will get called when the action is pressed.
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

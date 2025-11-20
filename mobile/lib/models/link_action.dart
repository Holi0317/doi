import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../i18n/strings.g.dart';

/// Enum of actions that can be performed on a link.
enum LinkAction {
  // FIXME: Fix the colors. They are super ugly right now
  // FIXME: Do translations on labels
  archive(Icons.archive, Colors.lime),
  unarchive(Icons.unarchive, Colors.lime),
  favorite(Icons.favorite, Colors.lightBlue),
  unfavorite(Icons.favorite_border, Colors.lightBlue),
  share(Icons.share, Colors.amber),
  delete(Icons.delete, Colors.red);

  final IconData icon;
  final Color color;

  const LinkAction(this.icon, this.color);

  /// Get the localized label for this action.
  /// Must run in a context where [Translations] is available.
  String get label {
    return t.linkAction[name]!;
  }

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

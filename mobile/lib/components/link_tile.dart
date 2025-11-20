import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/edit_op.dart';
import '../models/link.dart';
import '../models/link_action.dart';
import '../providers/api.dart';
import '../providers/queue.dart';
import '../utils.dart';
import 'link_image_preview.dart';

class LinkTile extends ConsumerStatefulWidget {
  const LinkTile({
    super.key,
    required this.item,
    this.selecting = false,
    this.selected = false,
    this.dismissible = false,
    this.onSelect,
  });

  final Link item;
  final bool selecting;
  final bool selected;

  /// If true, the tile can be dismissed and archived by swiping.
  ///
  /// IMPORTANT: flutter_slidable expects the item will get removed from the list after dismiss.
  /// Parent widget must make sure they have `archive: true` in `SearchQuery` to prevent the item from re-appearing.
  /// Failing to do so will cause error in runtime.
  final bool dismissible;

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
  void didUpdateWidget(LinkTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Close slidable when entering selection mode
    // Seems that disabling the slidable doesn't close it automatically
    if (widget.selecting && !oldWidget.selecting && controller.ratio != 0) {
      controller.close(duration: const Duration());
    }
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

        // FIXME(GH-18): Seems we need 2 ticks to remove item after dismiss, and slidable isn't happy about that.
        dismissible: widget.dismissible && !widget.item.archive
            ? DismissiblePane(
                onDismissed: () => _edit(EditOpField.archive, true),
              )
            : null,

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
            _buildFavicon(context),
            Flexible(
              child: Text(
                uri.host,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(' • ${formatRelativeDate(widget.item.createdAt)}'),
            if (widget.item.favorite)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),

            if (widget.item.archive)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.archive,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      ),
    );
  }

  Widget _buildFavicon(BuildContext context) {
    final apiRepository = ref.watch(apiRepositoryProvider);

    if (apiRepository is! AsyncData) {
      return const SizedBox.shrink();
    }

    final api = apiRepository.value;
    if (api == null) {
      return const SizedBox.shrink();
    }

    final faviconUrl = api.imageUrl(
      widget.item.url,
      type: 'favicon',
      width: 16,
      height: 16,
    );

    final headers = {
      ...api.headers,
      "Accept": "image/webp,image/x-icon,image/png,image/jpeg",
    };

    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: CachedNetworkImage(
        imageUrl: faviconUrl,
        httpHeaders: headers,
        width: 16,
        height: 16,
        errorWidget: (context, url, error) => const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _open() async {
    // TODO(GH-16): Add action button in custom tabs. Might need to write native code for that.
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

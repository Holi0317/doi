import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/link.dart';
import '../providers/api.dart';
import '../repositories/api.dart';

class LinkImagePreview extends ConsumerStatefulWidget {
  const LinkImagePreview({super.key, required this.item});

  final Link item;

  @override
  ConsumerState<LinkImagePreview> createState() => _LinkImagePreviewState();
}

class _LinkImagePreviewState extends ConsumerState<LinkImagePreview> {
  @override
  Widget build(BuildContext context) {
    final apiRepository = ref.watch(apiRepositoryProvider);

    return LayoutBuilder(
      builder: (context, constraint) {
        final width = constraint.maxWidth * 0.25;
        final height = constraint.maxHeight;

        return SizedBox(
          width: width,
          height: height,
          child: switch (apiRepository) {
            AsyncValue(:final value?, hasValue: true) => _buildImage(
              context,
              value,
              width,
              height,
            ),
            AsyncValue(error: != null) => const Icon(Icons.error),
            AsyncValue() => const Center(child: CircularProgressIndicator()),
          },
        );
      },
    );
  }

  Widget _buildImage(
    BuildContext context,
    ApiRepository api,
    double width,
    double height,
  ) {
    final imageUrl = api.imageUrl(widget.item.url);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      httpHeaders: api.headers,
      width: width,
      height: height,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const SizedBox.shrink(),
    );
  }
}

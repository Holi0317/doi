import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/link.dart';
import '../providers/api/api.dart';
import '../repositories/api.dart';

class LinkFavicon extends ConsumerWidget {
  final Link item;

  const LinkFavicon({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiRepository = ref.watch(apiRepositoryProvider);

    return switch (apiRepository) {
      AsyncValue(:final value?, hasValue: true) => _buildImage(context, value),
      AsyncValue(error: != null) => const Icon(Icons.error),
      AsyncValue() => const SizedBox.shrink(),
    };
  }

  Widget _buildImage(BuildContext context, ApiRepository api) {
    final faviconUrl = api.imageUrl(
      item.url,
      type: 'favicon',
      width: 16,
      height: 16,
    );

    final headers = {
      ...api.headers,
      "Accept": "image/webp,image/png,image/jpeg",
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
}

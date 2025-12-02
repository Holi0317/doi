import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/link.dart';
import '../providers/api/api.dart';
import '../repositories/api.dart';
import './shimmer.dart';

class LinkImagePreview extends ConsumerWidget {
  const LinkImagePreview({super.key, required this.item});

  final Link item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            AsyncValue() => _buildShimmer(context, width, height),
          },
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context, double width, double height) {
    return Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildImage(
    BuildContext context,
    ApiRepository api,
    double width,
    double height,
  ) {
    final imageUrl = api.imageUrl(
      item.url,
      dpr: MediaQuery.devicePixelRatioOf(context),
      width: width,
      height: height,
    );

    final headers = {
      ...api.headers,
      // Flutter's `Image` widget only supports webp. Doesn't seem to have a way to check if we support avif or not.
      "Accept": "image/webp,image/jpeg",
    };

    return CachedNetworkImage(
      imageUrl: imageUrl,
      httpHeaders: headers,
      width: width,
      height: height,
      placeholder: (context, url) => _buildShimmer(context, width, height),
      errorWidget: (context, url, error) => const SizedBox.shrink(),
    );
  }
}

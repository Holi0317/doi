import 'package:flutter/material.dart';
import 'shimmer.dart';

/// A shimmer loading placeholder for LinkTile
class LinkTileShimmer extends StatelessWidget {
  const LinkTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Container(
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 14,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A widget that displays a shimmer loading effect.
/// Based on Flutter's cookbook: https://docs.flutter.dev/cookbook/effects/shimmer-loading
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
      stops: [0.1, 0.3, 0.4],
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    ),
  });

  final Widget child;
  final Gradient gradient;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return widget.gradient.createShader(
              Rect.fromLTWH(
                -bounds.width * _controller.value,
                0,
                bounds.width * 3,
                bounds.height,
              ),
            );
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

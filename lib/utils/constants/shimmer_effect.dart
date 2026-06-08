import 'package:flutter/material.dart';

class ShimmerEffect extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<ShimmerEffect> createState() => ShimmerEffectState();
}

class ShimmerEffectState extends State<ShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();

    animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
              stops: [0.0, 0.5, 1.0],
              transform: GradientRotation(animation.value),
            ),
          ),
        );
      },
    );
  }
}

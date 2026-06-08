import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/responsive_size.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // 👇 Reusable shadow properties (optional)
  final double? blurRadius;
  final Offset? shadowOffset;
  final Color? shadowColor;

  const SectionContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.blurRadius,
    this.shadowOffset,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? ResponsiveSize.symmetric(v: 1.5),
      padding: padding ?? ResponsiveSize.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(3)),
        boxShadow: [
          BoxShadow(
            // ✅ Default preserved
            color: shadowColor ?? Colors.black.withOpacity(0.05),
            blurRadius: blurRadius ?? 8,
            offset: shadowOffset ?? const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

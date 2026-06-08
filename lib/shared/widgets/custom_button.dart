import 'package:flutter/material.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/device/responsive_size.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final double? fontSize;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? icon;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.gradient,
    required this.textColor,
    required this.onPressed,
    this.fontSize,
    this.borderRadius = 25,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? ResponsiveSize.w(width!) : null,
      height: height != null ? ResponsiveSize.h(height!) : null,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(borderRadius)),
        border: borderColor != null ? Border.all(color: borderColor!, width: borderWidth ?? 1) : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveSize.w(borderRadius))),
          padding: padding ?? EdgeInsets.symmetric(vertical: ResponsiveSize.h(1.5), horizontal: ResponsiveSize.w(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: ResponsiveSize.w(2))],
            Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(color: textColor, fontSize: fontSize ?? ResponsiveSize.font(14)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/device/responsive_size.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.titleColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: titleColor ?? AppColors.darkGreen,
          fontSize: ResponsiveSize.font(18),
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation: elevation ?? 0,
      leading: leading,
      actions: actions,
      iconTheme: IconThemeData(color: AppColors.darkGreen),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ResponsiveSize.h(7));
}

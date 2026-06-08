import 'package:flutter/material.dart';
import '../../../shared/widgets/section_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';

class ActionCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.category,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SectionContainer(
        shadowColor: Colors.black.withOpacity(0.3),
        padding: ResponsiveSize.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: ResponsiveSize.w(6),
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: ResponsiveSize.icon(3.5)),
            ),
            SizedBox(height: ResponsiveSize.h(1)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: ResponsiveSize.h(0.5)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
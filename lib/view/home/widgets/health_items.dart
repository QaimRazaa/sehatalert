import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';

class HealthItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const HealthItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: ResponsiveSize.w(4),
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: ResponsiveSize.icon(2.5)),
        ),
        SizedBox(width: ResponsiveSize.w(3)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
              ),
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: " $value"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
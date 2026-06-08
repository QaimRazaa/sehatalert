import 'package:flutter/material.dart';
import '../../../shared/widgets/section_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../../utils/device/responsive_size.dart';

class HealthRecordCard extends StatelessWidget {
  final String diseaseType;
  final String reading;
  final String dateTime;
  final String? additionalInfo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HealthRecordCard({
    super.key,
    required this.diseaseType,
    required this.reading,
    required this.dateTime,
    this.additionalInfo,
    required this.onEdit,
    required this.onDelete,
  });

  IconData getIconByType() {
    switch (diseaseType.toLowerCase()) {
      case 'diabetes':
        return Icons.water_drop;
      case 'heart':
        return Icons.favorite;
      case 'hypertension':
        return Icons.monitor_heart;
      default:
        return Icons.health_and_safety;
    }
  }

  Color getColorByType() {
    switch (diseaseType.toLowerCase()) {
      case 'diabetes':
        return Colors.blue;
      case 'heart':
        return Colors.red;
      case 'hypertension':
        return Colors.purple;
      default:
        return AppColors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = getColorByType();

    return SectionContainer(
      padding: ResponsiveSize.all(4),
      margin: ResponsiveSize.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: ResponsiveSize.w(5),
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(
                      getIconByType(),
                      color: color,
                      size: ResponsiveSize.icon(3),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(3)),
                  Text(
                    diseaseType,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              Text(
                reading,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(1)),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.textGray,
                size: ResponsiveSize.icon(2),
              ),
              SizedBox(width: ResponsiveSize.w(2)),
              Text(dateTime, style: AppTextStyles.bodySmall),
              Spacer(),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: ResponsiveSize.symmetric(h: 3, v: 1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: AppColors.error,
                        size: ResponsiveSize.icon(2),
                      ),
                      SizedBox(width: ResponsiveSize.w(1)),
                      Text(
                        l10n.delete,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (additionalInfo != null) ...[
            SizedBox(height: ResponsiveSize.h(1)),
            Text(additionalInfo!, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}

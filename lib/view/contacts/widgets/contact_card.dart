import 'package:flutter/material.dart';
import '../../../shared/widgets/section_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../../utils/device/responsive_size.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String relationship;
  final String phoneNumber;
  final String type;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ContactCard({
    super.key,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    required this.type,
    required this.onEdit,
    required this.onDelete,
  });

  IconData getIconByType() {
    switch (type.toLowerCase()) {
      case 'family':
        return Icons.family_restroom;
      case 'doctor':
        return Icons.medical_services;
      case 'friend':
        return Icons.people;
      default:
        return Icons.person;
    }
  }

  Color getColorByType() {
    switch (type.toLowerCase()) {
      case 'family':
        return Colors.blue;
      case 'doctor':
        return AppColors.lightGreen;
      case 'friend':
        return Colors.orange;
      default:
        return AppColors.textGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = getColorByType();

    return SectionContainer(
      padding: ResponsiveSize.all(3),
      margin: ResponsiveSize.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: ResponsiveSize.w(6),
                backgroundColor: color.withOpacity(0.1),
                child: Icon(
                  getIconByType(),
                  color: color,
                  size: ResponsiveSize.icon(3),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(0.5)),
                    Text(
                      relationship,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(.5)),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: AppColors.lightGreen,
                size: ResponsiveSize.icon(2),
              ),
              SizedBox(width: ResponsiveSize.w(2)),
              Text(
                phoneNumber,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDark,
                ),
              ),
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

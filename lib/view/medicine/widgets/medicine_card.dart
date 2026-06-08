import 'package:flutter/material.dart';
import '../../../shared/widgets/section_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../../utils/device/responsive_size.dart';

class MedicineCard extends StatelessWidget {
  final String medicineName;
  final String dosage;
  final String frequency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MedicineCard({
    super.key,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionContainer(
      padding: ResponsiveSize.all(3),
      margin: ResponsiveSize.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  medicineName,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Icon(
                Icons.medical_services_outlined,
                color: AppColors.primary,
                size: ResponsiveSize.icon(2.5),
              ),
            ],
          ),

          if (dosage.isNotEmpty) ...[
            SizedBox(height: ResponsiveSize.h(1)),
            Text(dosage, style: AppTextStyles.bodySmall),
          ],

          if (frequency.isNotEmpty) ...[
            SizedBox(height: ResponsiveSize.h(0.5)),
            Text(frequency, style: AppTextStyles.bodySmall),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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

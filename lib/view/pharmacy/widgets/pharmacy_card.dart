import 'package:flutter/material.dart';
import '../../../shared/widgets/section_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';

class PharmacyCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String? address;
  final String? city;
  final VoidCallback onDelete;

  const PharmacyCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.address,
    this.city,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: const Color(0xFF0EA5E9).withOpacity(0.1),
                child: Icon(
                  Icons.local_pharmacy_outlined,
                  color: const Color(0xFF0EA5E9),
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
                    if (city != null && city!.isNotEmpty) ...[
                      SizedBox(height: ResponsiveSize.h(0.3)),
                      Text(
                        city!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(1)),
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
              const Spacer(),
              GestureDetector(
                onTap: onDelete,
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: AppColors.error,
                      size: ResponsiveSize.icon(2),
                    ),
                    SizedBox(width: ResponsiveSize.w(1)),
                    Text(
                      'Delete',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (address != null && address!.isNotEmpty) ...[
            SizedBox(height: ResponsiveSize.h(0.8)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textGray,
                  size: ResponsiveSize.icon(2),
                ),
                SizedBox(width: ResponsiveSize.w(2)),
                Expanded(
                  child: Text(
                    address!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textGray,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

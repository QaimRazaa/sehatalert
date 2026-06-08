import 'package:flutter/material.dart';
import '../../../shared/widgets/section_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../../utils/device/responsive_size.dart';

class EmergencyContactCard extends StatelessWidget {
  final String name;
  final String relationship;
  final String phoneNumber;

  const EmergencyContactCard({
    super.key,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
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
            children: [
              Container(
                padding: ResponsiveSize.all(2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(2)),
                ),
                child: Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: ResponsiveSize.icon(3),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(2)),
                        Container(
                          padding: ResponsiveSize.symmetric(h: 2, v: 0.5),
                          decoration: BoxDecoration(
                            color: Color(0xFFEF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(1),
                            ),
                          ),
                          child: Text(
                            l10n.emergency,
                            style: TextStyle(
                              fontSize: ResponsiveSize.font(9),
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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
          SizedBox(height: ResponsiveSize.h(1)),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: Color(0xFFEF4444),
                size: ResponsiveSize.icon(2),
              ),
              SizedBox(width: ResponsiveSize.w(2)),
              Text(
                phoneNumber,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

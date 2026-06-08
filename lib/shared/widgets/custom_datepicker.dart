import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/responsive_size.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onDateSelected;
  final String hintText;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    required this.hintText,
    required this.label,
    this.firstDate,
    this.lastDate,
  });

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? (lastDate ?? DateTime.now()),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectDate(context),
      child: Container(
        padding: ResponsiveSize.symmetric(h: 4, v: 2),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(2)),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.darkGreen, size: ResponsiveSize.icon(2.5)),
            SizedBox(width: ResponsiveSize.w(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(11),
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(0.3)),
                  Text(
                    initialDate != null ? formatDate(initialDate) : hintText,
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(12),
                      fontWeight: FontWeight.w400,
                      color: initialDate != null ? AppColors.textDark : AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

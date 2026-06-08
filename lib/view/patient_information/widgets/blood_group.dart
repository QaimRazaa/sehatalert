import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';


class BloodGroupPicker {
  static void show({
    required BuildContext context,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _tile(context, "A+", onSelected),
              _tile(context, "A-", onSelected),
              _tile(context, "B+", onSelected),
              _tile(context, "B-", onSelected),
              _tile(context, "AB+", onSelected),
              _tile(context, "AB-", onSelected),
              _tile(context, "O+", onSelected),
              _tile(context, "O-", onSelected),
              SizedBox(height: ResponsiveSize.h(2)),
            ],
          ),
        );
      },
    );
  }

  static Widget _tile(
      BuildContext context,
      String value,
      ValueChanged<String> onSelected,
      ) {
    return ListTile(
      title: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        onSelected(value);
        Navigator.pop(context);
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';


class GenderPicker {
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _genderTile(context, "Male", onSelected),
            _genderTile(context, "Female", onSelected),
            _genderTile(context, "Prefer not to say", onSelected),
            SizedBox(height: ResponsiveSize.h(2)),
          ],
        );
      },
    );
  }

  static Widget _genderTile(
      BuildContext context,
      String value,
      ValueChanged<String> onSelected,
      ) {
    return ListTile(
      title: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
      ),
      onTap: () {
        onSelected(value);
        Navigator.pop(context);
      },
    );
  }
}

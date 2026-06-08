import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';

class HeightPicker {
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
            children: List.generate(101, (index) {
              final inches = 20 + index; // 20–120 inches
              final feet = inches ~/ 12;
              final remainingInches = inches % 12;
              final displayValue = "$inches inches ($feet' $remainingInches\")";
              return _tile(
                context,
                inches.toString(),
                displayValue,
                onSelected,
              );
            })..add(SizedBox(height: ResponsiveSize.h(2))),
          ),
        );
      },
    );
  }

  static Widget _tile(
    BuildContext context,
    String value,
    String displayValue,
    ValueChanged<String> onSelected,
  ) {
    return ListTile(
      title: Text(
        displayValue,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
      ),
      onTap: () {
        onSelected(value);
        Navigator.pop(context);
      },
    );
  }
}

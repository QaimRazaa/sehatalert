import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';

class WeightPicker {
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
            children: List.generate(171, (index) {
              final weight = (30 + index).toString(); // 30–200 kg
              return _tile(context, weight, onSelected);
            })
              ..add(SizedBox(height: ResponsiveSize.h(2))),
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
        "$value kg",
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
      ),
      onTap: () {
        onSelected(value);
        Navigator.pop(context);
      },
    );
  }
}

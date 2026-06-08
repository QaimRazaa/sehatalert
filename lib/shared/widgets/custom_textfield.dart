import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/device/responsive_size.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final double? height;
  final double? width;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onSuffixTap;
  final EdgeInsetsGeometry? prefixPadding;
  final EdgeInsetsGeometry? suffixPadding;
  final TextStyle? hintTextStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final List<String>? autofillHints;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.height,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.onSuffixTap,
    this.width,
    this.prefixPadding,
    this.hintTextStyle,
    this.labelText,
    this.labelStyle,
    this.suffixPadding,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: labelStyle ?? AppTextStyles.labelSmall.copyWith(color: AppColors.darkGreen)),
          SizedBox(height: ResponsiveSize.h(1)),
        ],
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            maxLines: maxLines,
            minLines: minLines,
            enabled: enabled,
            readOnly: readOnly,
            onTap: onTap,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            autofillHints: autofillHints,
            onEditingComplete: onEditingComplete,
            style: TextStyle(fontSize: ResponsiveSize.font(12), color: AppColors.textDark),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isCollapsed: false,
              hintText: hintText,
              hintStyle: hintTextStyle ?? TextStyle(fontSize: ResponsiveSize.font(12), color: AppColors.lightGrey),
              prefixIcon: prefixIcon != null
                  ? Padding(padding: prefixPadding ?? ResponsiveSize.only(left: 1, right: 2), child: prefixIcon)
                  : null,
              prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                onTap: onSuffixTap,
                child: Padding(padding: suffixPadding ?? ResponsiveSize.only(right: 2), child: suffixIcon),
              )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              filled: true,
              fillColor: fillColor ?? AppColors.white,
              contentPadding:
              contentPadding ??
                  EdgeInsets.symmetric(horizontal: ResponsiveSize.w(4), vertical: ResponsiveSize.h(2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSize.w(4)),
                borderSide: BorderSide(color: borderColor ?? AppColors.border, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSize.w(4)),
                borderSide: BorderSide(color: borderColor ?? AppColors.border, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSize.w(4)),
                borderSide: BorderSide(color: focusedBorderColor ?? AppColors.primary, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSize.w(4)),
                borderSide: const BorderSide(color: AppColors.error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSize.w(4)),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? ResponsiveSize.w(4)),
                borderSide: BorderSide(color: borderColor ?? AppColors.border, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
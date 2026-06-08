import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../device/responsive_size.dart';

class AppTextStyles {
  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(12),
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(14),
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(16),
    fontWeight: FontWeight.w400,
  );

  static TextStyle get labelSmall => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(11),
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelMedium => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(13),
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleSmall => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(14),
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMedium => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(16),
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: ResponsiveSize.font(20),
    fontWeight: FontWeight.w700,
  );
}
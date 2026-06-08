import 'dart:math';
import 'package:flutter/material.dart';

class ResponsiveSize {
  static late double width;
  static late double height;
  static late double diagonal;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    diagonal = sqrt(pow(width, 2) + pow(height, 2));
  }

  // Percentage based sizing
  static double w(double percent) => width * (percent / 100);

  static double h(double percent) => height * (percent / 100);

  // Font scaling based on screen diagonal
  static double font(double size) => (size * diagonal) / 1000;

  // Icon sizing
  static double icon(double size) => h(size);

  // Padding helpers
  static EdgeInsets all(double percent) => EdgeInsets.all(w(percent));

  static EdgeInsets symmetric({double h = 0, double v = 0}) {
    return EdgeInsets.symmetric(horizontal: w(h), vertical: ResponsiveSize.h(v));
  }

  static EdgeInsets only({double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return EdgeInsets.only(left: w(left), top: h(top), right: w(right), bottom: h(bottom));
  }

  // Border radius
  static BorderRadius radius(double percent) {
    return BorderRadius.circular(w(percent));
  }

  // Device type checks
  static bool get isMobile => width < 600;

  static bool get isTablet => width >= 600 && width < 1024;

  static bool get isDesktop => width >= 1024;
}

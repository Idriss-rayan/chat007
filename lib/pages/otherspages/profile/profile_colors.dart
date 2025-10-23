// profile_colors.dart
import 'package:flutter/material.dart';

class ProfileColors {
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color lightOrange = Color(0xFFFF8E6B);
  static const Color pink = Color(0xFFFF69B4);
  static const Color lightPink = Color(0xFFFFB6C1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFDF6F6);

  static LinearGradient get mainGradient => LinearGradient(
        colors: [primaryOrange, pink],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get cardGradient => LinearGradient(
        colors: [lightPink.withOpacity(0.1), lightOrange.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get buttonGradient => LinearGradient(
        colors: [primaryOrange, pink],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

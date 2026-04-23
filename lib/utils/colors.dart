import 'package:flutter/material.dart';

/// Application color palette extracted from Plumedica logo
class AppColors {
  // Primary colors from logo
  static const Color primaryDarkBlue = Color(0xFF1B4A7E);
  static const Color primaryBlue = Color(0xFF0099D8);
  static const Color lightBlue = Color(0xFF00A8E8);
  static const Color green = Color(0xFF7CB342);
  static const Color gold = Color(0xFFF4C430);
  static const Color lightGold = Color(0xFFFFE082);

  // Secondary colors
  static const Color purple = Color(0xFFAB6FDB);
  static const Color lightPurple = Color(0xFFD4A5E8);
  static const Color darkPurple = Color(0xFF8B5CB8);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF424242);
  static const Color mediumGrey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color veryLightGrey = Color(0xFFF5F5F5);

  // Semantic colors
  static const Color success = green;
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = gold;
  static const Color orange = Color(0xFFF5A623);
  static const Color info = primaryBlue;

  // Background colors
  static const Color backgroundLight = white;
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = veryLightGrey;

  // Text colors
  static const Color textPrimary = primaryDarkBlue;
  static const Color textSecondary = mediumGrey;
  static const Color textHint = lightGrey;

  // Gradient colors
  static const List<Color> primaryGradient = [primaryDarkBlue, primaryBlue];
  static const List<Color> accentGradient = [green, gold];
  static const List<Color> purpleGradient = [darkPurple, purple];

  // Gradient definitions from Plumedica logo
  static LinearGradient get blueGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDarkBlue, primaryBlue],
  );

  static LinearGradient get greenGoldenGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [green, gold],
  );

  static LinearGradient get verticalBlueGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, primaryDarkBlue],
  );

  static LinearGradient get verticalGreenGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [green, Color(0xFF558B2F)],
  );

  static LinearGradient get purpleGradientVertical => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightPurple, purple],
  );

  static LinearGradient get multiColorGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDarkBlue, green, gold],
  );
}

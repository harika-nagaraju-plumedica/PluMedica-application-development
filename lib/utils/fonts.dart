import 'package:flutter/material.dart';

/// Application font utilities and text styles
class AppFonts {
  // Font family
  static const String fontFamily = 'Roboto';

  // Font sizes
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Text styles - Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: fontSizeXXLarge,
    fontWeight: bold,
    fontFamily: fontFamily,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: bold,
    fontFamily: fontFamily,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: semiBold,
    fontFamily: fontFamily,
  );

  // Text styles - Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeRegular,
    fontWeight: regular,
    fontFamily: fontFamily,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    fontFamily: fontFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    fontFamily: fontFamily,
  );

  // Text styles - Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSizeRegular,
    fontWeight: semiBold,
    fontFamily: fontFamily,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: medium,
    fontFamily: fontFamily,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: medium,
    fontFamily: fontFamily,
  );

  // Text styles - Caption
  static const TextStyle caption = TextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: regular,
    fontFamily: fontFamily,
  );
}

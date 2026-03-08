import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Biyoloji temalı yeşil
  static const primary = Color(0xFF2E7D32);
  static const primaryLight = Color(0xFF60AD5E);
  static const primaryDark = Color(0xFF005005);
  static const onPrimary = Colors.white;

  // Secondary
  static const secondary = Color(0xFF00796B);
  static const secondaryLight = Color(0xFF48A999);
  static const secondaryDark = Color(0xFF004C40);

  // Feedback
  static const success = Color(0xFF4CAF50);
  static const successLight = Color(0xFFE8F5E9);
  static const error = Color(0xFFE53935);
  static const errorLight = Color(0xFFFFEBEE);
  static const warning = Color(0xFFFFA726);
  static const warningLight = Color(0xFFFFF3E0);
  static const info = Color(0xFF2196F3);

  // Neutrals - Minimalist tema
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF5F5F5);
  static const border = Color(0xFFE0E0E0);
  static const divider = Color(0xFFEEEEEE);

  // Text
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textHint = Color(0xFFBDBDBD);
  static const textOnDark = Colors.white;

  // Quiz specific
  static const glowColor = Color(0xFF64FFDA);
  static const blurOverlay = Color(0xCCFFFFFF);
  static const dropZoneActive = Color(0x1A2E7D32);
  static const dropZoneHover = Color(0x332E7D32);
}

extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get surfaceColor => isDark ? Colors.black : AppColors.surface;
  Color get textColorPrimary => isDark ? Colors.white : AppColors.textPrimary;
  Color get textColorSecondary =>
      isDark ? Colors.white70 : AppColors.textSecondary;
  Color get surfaceVariantColor =>
      isDark ? const Color(0xFF2C2C2C) : AppColors.surfaceVariant;
}

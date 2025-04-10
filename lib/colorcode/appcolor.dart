import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color authGradientStart = Color(0xFF2A0D4A);
  static const Color authGradientEnd = Color(0xFF0D2F4F);
  static final Color authFormBackground = Colors.black.withAlpha(80);
  static final Color authTextFieldFill = Colors.black.withAlpha(130);
  static final Color authAccent = Colors.cyanAccent.shade200;
  static const Color authPrimaryText = Colors.white;
  static final Color authSecondaryText = Colors.grey.shade400;
  static final Color authBorder = Colors.white.withAlpha(60);
  static final Color authError = Colors.redAccent.shade100;
  static const Color authButtonText = Colors.black87;
  static const Color googleButtonBackground = Colors.white;

  static final Color authDivider = Colors.white.withAlpha(30);
  static final Color authHintText = authSecondaryText.withAlpha(178);
  static final Color authPrefixIcon = authAccent.withAlpha(204);

  static const Color backgroundDark = Color(0xFF121212);
  static final Color indicatorInactive = Colors.grey.shade800;
}
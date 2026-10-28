import 'package:flutter/material.dart';

class AppTheme {
  static const ink = Color(0xFF242424);
  static const muted = Color(0xFF6B6B6B);
  static const line = Color(0xFFE6E6E6);
  static const accent = Color(0xFF1A8917);
  static const paper = Color(0xFFFFFFFF);

  static const serif = 'Georgia';
  static const serifFallback = ['Times New Roman', 'serif'];

  static const accents = [
    Color(0xFFFFC017),
    Color(0xFF8AB4F8),
    Color(0xFFF28B82),
    Color(0xFFA7D7A9),
    Color(0xFFD7AEFB),
  ];

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.light,
        surface: paper,
      ),
      scaffoldBackgroundColor: paper,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(color: line, space: 1, thickness: 1),
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: line),
        backgroundColor: paper,
        showCheckmark: false,
      ),
    );
  }
}

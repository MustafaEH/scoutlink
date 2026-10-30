import 'package:flutter/material.dart';

abstract final class ScoutLinkColors {
  static const ink = Color(0xFF17251F);
  static const paper = Color(0xFFF3EFE4);
  static const paperDeep = Color(0xFFE6DFCF);
  static const field = Color(0xFF276749);
  static const signal = Color(0xFFD97732);
}

abstract final class ScoutLinkTheme {
  static ThemeData get light {
    final colors =
        ColorScheme.fromSeed(
          seedColor: ScoutLinkColors.field,
          surface: ScoutLinkColors.paper,
        ).copyWith(
          primary: ScoutLinkColors.field,
          secondary: ScoutLinkColors.signal,
          onSurface: ScoutLinkColors.ink,
          surfaceContainer: ScoutLinkColors.paperDeep,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: ScoutLinkColors.paper,
      appBarTheme: const AppBarTheme(
        backgroundColor: ScoutLinkColors.paper,
        foregroundColor: ScoutLinkColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ScoutLinkColors.ink.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

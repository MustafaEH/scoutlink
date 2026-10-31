import 'package:flutter/material.dart';

/// The only place where ScoutLink's current visual identity is defined.
/// Feature code consumes semantic Material colors and component themes.
abstract final class ScoutLinkTheme {
  static const _ink = Color(0xFF17251F);
  static const _paper = Color(0xFFF3EFE4);
  static const _paperDeep = Color(0xFFE6DFCF);
  static const _field = Color(0xFF276749);
  static const _signal = Color(0xFFD97732);

  static ThemeData get light {
    final colors =
        ColorScheme.fromSeed(
          seedColor: _field,
          brightness: Brightness.light,
          surface: _paper,
        ).copyWith(
          primary: _field,
          secondary: _signal,
          onSurface: _ink,
          surfaceContainer: _paperDeep,
          surfaceContainerHighest: _paperDeep,
        );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _ink.withValues(alpha: 0.45)),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.onSurface.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: colors.primary,
        headerForegroundColor: colors.onPrimary,
        todayForegroundColor: WidgetStatePropertyAll(colors.secondary),
        todayBorder: BorderSide(color: colors.secondary, width: 2),
        dayOverlayColor: WidgetStatePropertyAll(
          colors.primary.withValues(alpha: 0.10),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: colors.onSurface,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainerHighest,
      ),
    );
  }
}

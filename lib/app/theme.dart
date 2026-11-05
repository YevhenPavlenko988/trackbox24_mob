import 'package:flutter/material.dart';

/// The brand palette, the same as the landing page and the web cabinet.
abstract final class Brand {
  static const navy = Color(0xFF0D2049);
  static const navyDeep = Color(0xFF081634);
  static const orange = Color(0xFFF28C1E);
  static const sand = Color(0xFFF6F4EF);
}

/// Navy bars and text, orange accents, a warm off-white canvas with white cards; the dark theme keeps the navy as the
/// canvas and makes orange the main action, like the web's dark mode.
ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final base = ColorScheme.fromSeed(
    seedColor: Brand.navy,
    brightness: brightness,
  );
  final scheme = dark
      ? base.copyWith(
          primary: Brand.orange,
          onPrimary: Brand.navyDeep,
          primaryContainer: const Color(0xFF5A3A12),
          onPrimaryContainer: const Color(0xFFFFDDB8),
          secondary: const Color(0xFF8FB0EC),
          tertiary: Brand.orange,
          surface: Brand.navyDeep,
          onSurface: const Color(0xFFE9EDF5),
          onSurfaceVariant: const Color(0xFF9AA6BF),
          surfaceContainerLowest: const Color(0xFF06112A),
          surfaceContainerLow: const Color(0xFF0F2149),
          surfaceContainer: const Color(0xFF122753),
          surfaceContainerHigh: const Color(0xFF15295A),
          surfaceContainerHighest: const Color(0xFF182E5E),
          outline: const Color(0x40FFFFFF),
          outlineVariant: const Color(0x1FFFFFFF),
        )
      : base.copyWith(
          primary: Brand.navy,
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFDE6CB),
          onPrimaryContainer: Brand.navy,
          secondary: Brand.orange,
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFFDE6CB),
          onSecondaryContainer: Brand.navy,
          tertiary: Brand.orange,
          surface: Brand.sand,
          onSurface: Brand.navy,
          onSurfaceVariant: const Color(0xFF5C6479),
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: Colors.white,
          surfaceContainer: Colors.white,
          surfaceContainerHigh: const Color(0xFFF1EEE8),
          surfaceContainerHighest: const Color(0xFFEDEAE3),
          outline: const Color(0xFFCFCABE),
          outlineVariant: const Color(0xFFE6E2D9),
        );
  final barColor = dark ? const Color(0xFF06112A) : Brand.navy;
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    // navy bars like the web's sidebar: white titles and icons
    appBarTheme: AppBarTheme(
      backgroundColor: barColor,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xB3FFFFFF),
      indicatorColor: Brand.orange,
      dividerColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? const Color(0xFF06112A) : Colors.white,
      indicatorColor: Brand.orange.withValues(alpha: dark ? 0.25 : 0.18),
      surfaceTintColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected)
              ? (dark ? Brand.orange : Brand.navy)
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Brand.orange,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Brand.orange, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
    ),
  );
}

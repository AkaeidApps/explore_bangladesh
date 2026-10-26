import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const forest = Color(0xFF245C42);
  static const leaf = Color(0xFF6F956B);
  static const cream = Color(0xFFF4F3E9);
  static const river = Color(0xFF397D91);
  static const gold = Color(0xFFD9A65A);
  static const darkBackground = Color(0xFF101A15);
  static const darkSurface = Color(0xFF1B2A21);
}

class AppTheme {
  static ThemeData get light => _make(Brightness.light);
  static ThemeData get dark => _make(Brightness.dark);

  static ThemeData _make(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.forest,
      brightness: brightness,
      primary: dark ? const Color(0xFF9AC7A3) : AppColors.forest,
      secondary: AppColors.leaf,
      tertiary: AppColors.river,
      surface: dark ? AppColors.darkSurface : Colors.white,
    );
    final baseTextTheme = dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final fontTextTheme = GoogleFonts.robotoTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: fontTextTheme,
      scaffoldBackgroundColor: dark ? AppColors.darkBackground : AppColors.cream,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? AppColors.darkBackground : AppColors.cream,
        foregroundColor: dark ? Colors.white : AppColors.forest,
        elevation: 0,
        titleTextStyle: GoogleFonts.roboto(
          color: dark ? Colors.white : AppColors.forest,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: dark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: dark ? Colors.white12 : AppColors.forest.withValues(alpha: .08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.darkSurface : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: dark ? Colors.white12 : AppColors.forest.withValues(alpha: .1)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dark ? AppColors.darkSurface : Colors.white,
        indicatorColor: dark ? AppColors.forest.withValues(alpha: .6) : const Color(0xFFDDE9D9),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiyaaColors {
  LiyaaColors._();

  static const Color lavender = Color(0xFFA9A7F2);
  static const Color lavenderSoft = Color(0xFFECEAFF);
  static const Color plum = Color(0xFF3B1F3D);
  static const Color plumSoft = Color(0xFF7A6580);
  static const Color pink = Color(0xFFF0689F);
  static const Color pinkLight = Color(0xFFF7A6C8);
  static const Color pinkSoft = Color(0xFFFFDDEA);
  static const Color peach = Color(0xFFFFE6D0);
  static const Color orange = Color(0xFFF4A04A);
  static const Color teal = Color(0xFF7FDCD3);
  static const Color tealSoft = Color(0xFFD5F3EF);
  static const Color blush = Color(0xFFFFF6F9);
  static const Color line = Color(0xFFF3DCE7);
  static const Color alertBg = Color(0xFFFFE9E1);
  static const Color alertText = Color(0xFF9A2F4B);
}

ThemeData liyaaTheme() {
  final base = ThemeData.light();
  final text = base.textTheme.apply(
    fontFamily: GoogleFonts.alegreya().fontFamily,
    bodyColor: LiyaaColors.plum,
    displayColor: LiyaaColors.plum,
  );

  final scheme = ColorScheme.fromSeed(
    seedColor: LiyaaColors.pink,
    brightness: Brightness.light,
  ).copyWith(
    primary: LiyaaColors.plum,
    onPrimary: Colors.white,
    secondary: LiyaaColors.pink,
    surface: Colors.white,
    onSurface: LiyaaColors.plum,
  );

  OutlineInputBorder border(Color c, [double w = 1.2]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: w),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: text,
    dividerColor: LiyaaColors.line,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: LiyaaColors.plum,
      iconTheme: const IconThemeData(color: LiyaaColors.plum),
      titleTextStyle: GoogleFonts.alegreya(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: LiyaaColors.plum,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: LiyaaColors.plum,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFE7DCE8),
        disabledForegroundColor: const Color(0xFFA897AA),
        minimumSize: const Size.fromHeight(56),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.alegreya(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: LiyaaColors.plum,
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: LiyaaColors.plum, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.alegreya(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LiyaaColors.plum,
        textStyle: GoogleFonts.alegreya(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LiyaaColors.blush,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: const TextStyle(color: LiyaaColors.plumSoft),
      labelStyle: const TextStyle(color: LiyaaColors.plumSoft, fontSize: 16),
      floatingLabelStyle: const TextStyle(color: LiyaaColors.pink),
      prefixIconColor: LiyaaColors.pinkLight,
      border: border(LiyaaColors.line),
      enabledBorder: border(LiyaaColors.line),
      focusedBorder: border(LiyaaColors.pink, 1.6),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: LiyaaColors.plum,
      contentTextStyle: GoogleFonts.alegreya(color: Colors.white, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
import 'package:flutter/material.dart';

class LiyaaColors {
  // ── Your palette ──
  static const pinkLight = Color(0xFFFAD3E4); // #fad3e4
  static const pinkSoft = Color(0xFFFFC0E6); // #ffc0e6
  static const pink = Color(0xFFF695C5); // #f695c5
  static const plum = Color(0xFF4C454C); // #4c454c
  static const dark = Color(0xFF2A2A2A); // #2a2a2a

  // ── Darker backgrounds ──
  static const bgTop = Color(0xFF161516);
  static const bgBottom = Color(0xFF222122);
  static const navBar = Color(0xFF1E1D1E);

  // ── Semantic ──
  static const ink = pinkLight; // main text on dark
  static const inkSoft = Color(0xB3FAD3E4); // secondary text
  static const onPink = dark; // text on pink surfaces
  static const surface = Color(0xB34C454C); // card surface (plum, 70%)
  static const alert = pinkLight;
  static const alertText = dark;
  static const shadow = Color(0x66000000);
  static const glow = Color(0x4DF695C5);

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgTop, bgBottom],
  );

  static const pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkSoft, pink],
  );

  static const plumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B535B), plum],
  );
}

/// Signature "Shope" card shape: one big rounded corner, three small ones.
const kCardRadius = BorderRadius.only(
  topLeft: Radius.circular(44),
  topRight: Radius.circular(18),
  bottomLeft: Radius.circular(18),
  bottomRight: Radius.circular(18),
);

const kImageRadius = BorderRadius.only(
  topLeft: Radius.circular(64),
  topRight: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);

class LiyaaTheme {
  static ThemeData get dark {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: LiyaaColors.bgBottom,
      colorScheme: const ColorScheme.dark(
        primary: LiyaaColors.pink,
        onPrimary: LiyaaColors.dark,
        secondary: LiyaaColors.pinkSoft,
        onSecondary: LiyaaColors.dark,
        surface: LiyaaColors.dark,
        onSurface: LiyaaColors.pinkLight,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: LiyaaColors.ink,
        displayColor: LiyaaColors.ink,
      ),
      dividerColor: const Color(0x33FAD3E4),
      dividerTheme: const DividerThemeData(color: Color(0x33FAD3E4)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LiyaaColors.surface,
        labelStyle: const TextStyle(color: LiyaaColors.inkSoft),
        floatingLabelStyle: const TextStyle(color: LiyaaColors.pink),
        hintStyle: const TextStyle(color: LiyaaColors.inkSoft),
        prefixIconColor: LiyaaColors.pink,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: const OutlineInputBorder(
          borderRadius: kCardRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: kCardRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: kCardRadius,
          borderSide: BorderSide(color: LiyaaColors.pink, width: 1.5),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: LiyaaColors.pink,
        selectionHandleColor: LiyaaColors.pink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LiyaaColors.pink,
          foregroundColor: LiyaaColors.dark,
          disabledBackgroundColor: LiyaaColors.plum,
          disabledForegroundColor: LiyaaColors.inkSoft,
          minimumSize: const Size.fromHeight(54),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LiyaaColors.pinkLight,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: Color(0x80F695C5), width: 1.4),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LiyaaColors.pink,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: LiyaaColors.pinkLight,
        contentTextStyle: const TextStyle(
          color: LiyaaColors.dark,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // aliases so old main.dart references keep working
  static ThemeData get light => dark;
  static ThemeData get theme => dark;
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0F0F13);
  static const Color surface = Color(0xFF16161E);
  static const Color foreground = Color(0xFFFFFFFF);
  static const Color fgNav = Color(0xFFA5ACBB);
  static const Color fgMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFF252530);

  // Card accent backgrounds
  static const Color cardTeal = Color(0xFF0C2626);
  static const Color cardPurple = Color(0xFF160D30);
  static const Color cardGreen = Color(0xFF0A2018);
  static const Color cardDark = Color(0xFF111118);
  static const Color cardSlate = Color(0xFF0E141E);
  static const Color cardWarm = Color(0xFF201410);
  static const Color cardMid = Color(0xFF1A1A24);

  // Accents
  static const Color accentSalmon = Color(0xFFE8705A);
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentGreen = Color(0xFF34D399);
  static const Color accentBlue = Color(0xFF60A5FA);

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accentTeal,
        secondary: accentSalmon,
      ),
      textTheme: GoogleFonts.spaceMonoTextTheme().apply(
        bodyColor: fgNav,
        displayColor: foreground,
      ),
    );
  }
}

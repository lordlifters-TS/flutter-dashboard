import 'package:flutter/material.dart';

class AppTheme {
  // ─── Brand Colors ───────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF00897B); // Teal Green (health)
  static const Color primaryBlue  = Color(0xFF1565C0); // Medical Blue
  static const Color accentOrange = Color(0xFFFF6F00); // Urgent/Alert
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningAmber = Color(0xFFF57F17);
  static const Color errorRed     = Color(0xFFC62828);
  static const Color bgLight      = Color(0xFFF5F7FA);
  static const Color cardWhite    = Color(0xFFFFFFFF);

  // ─── Light Theme ────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      secondary: primaryBlue,
      surface: cardWhite,
    ),
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: bgLight,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // ✅ FIXED: CardTheme → CardThemeData
    cardTheme: CardThemeData(
      color: cardWhite,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDDE0E5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDDE0E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: primaryGreen.withOpacity(0.1),
      labelStyle: const TextStyle(color: primaryGreen, fontFamily: 'Poppins'),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
    ),
  );

  // ─── Dark Theme ─────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Poppins',
  );

  // ─── Status Colors ──────────────────────────────────────────
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':   return warningAmber;
      case 'accepted':  return primaryBlue;
      case 'arrived':   return primaryGreen;
      case 'completed': return successGreen;
      case 'rejected':  return errorRed;
      case 'cancelled': return Colors.grey;
      case 'emergency': return errorRed;
      case 'urgent':    return accentOrange;
      case 'routine':   return primaryGreen;
      default:          return Colors.grey;
    }
  }
}
import 'package:flutter/material.dart';

class HabiticaColors {
  // Gray shades
  static const Color black = Color(0xFF1A181D);
  static const Color gray10 = Color(0xFF34313A);
  static const Color gray50 = Color(0xFF4E4A57);
  static const Color gray100 = Color(0xFF686274);
  static const Color gray200 = Color(0xFF787190);
  static const Color gray300 = Color(0xFFA5A1AC);
  static const Color gray400 = Color(0xFFC3C0C7);
  static const Color gray500 = Color(0xFFE1E0E3);
  static const Color gray600 = Color(0xFFECDEEE);
  static const Color gray700 = Color(0xFFF9F9F9);

  // Purple shades
  static const Color purple50 = Color(0xFF36205D);
  static const Color purple100 = Color(0xFF432874);
  static const Color purple200 = Color(0xFF4F2A93);
  static const Color purple300 = Color(0xFF6133B4);
  static const Color purple400 = Color(0xFF925CF3);
  static const Color purple500 = Color(0xFFBDA8FF);
  static const Color purple600 = Color(0xFFD5C8FF);

  // Blue shades
  static const Color blue1 = Color(0xFF033F5E);
  static const Color blue10 = Color(0xFF2995CD);
  static const Color blue50 = Color(0xFF46A7D9);
  static const Color blue100 = Color(0xFF50B5E9);
  static const Color blue500 = Color(0xFFA9DCF6);

  // Red shades
  static const Color red1 = Color(0xFF6C0406);
  static const Color red10 = Color(0xFFF23035);
  static const Color red50 = Color(0xFFF74E52);
  static const Color red100 = Color(0xFFFF6165);
  static const Color red500 = Color(0xFFFFB6B8);

  // Yellow shades
  static const Color yellow1 = Color(0xFF794B00);
  static const Color yellow5 = Color(0xFFEE9109);
  static const Color yellow10 = Color(0xFFFFA624);
  static const Color yellow50 = Color(0xFFFFB445);
  static const Color yellow100 = Color(0xFFFFBE5D);
  static const Color yellow500 = Color(0xFFFEEADA);

  // Maroon shades
  static const Color maroon10 = Color(0xFFB01515);
  static const Color maroon50 = Color(0xFFC92B2B);
  static const Color maroon100 = Color(0xFFDE3F3F);
  static const Color maroon500 = Color(0xFFF19595);

  // Orange shades
  static const Color orange1 = Color(0xFF733300);
  static const Color orange10 = Color(0xFFF47825);
  static const Color orange50 = Color(0xFFFA8537);
  static const Color orange100 = Color(0xFFF9944C);
  static const Color orange500 = Color(0xFFFEC8A7);

  // Teal shades
  static const Color teal1 = Color(0xFF005158);
  static const Color teal10 = Color(0xFF26A0AB);
  static const Color teal50 = Color(0xFF34BC51);
  static const Color teal100 = Color(0xFF38CAD7);
  static const Color teal500 = Color(0xFF8EEDF6);

  // Green shades
  static const Color green1 = Color(0xFF005737);
  static const Color green10 = Color(0xFF1CA372);
  static const Color green50 = Color(0xFF20B780);
  static const Color green100 = Color(0xFF24CC8F);
  static const Color green500 = Color(0xFF77F4A0);

  // Calculate colors
  static List<Color> calculateColors(DateTime createdAt, DateTime dueDate) {
    final totalDuration = dueDate.difference(createdAt).inMilliseconds.toDouble();
    final elapsedDuration = DateTime.now().difference(createdAt).inMilliseconds.toDouble();

    final progress = (elapsedDuration / totalDuration) * 100;

    if (progress < 20) {
      return [blue10, blue100];
    } else if (progress >= 20 && progress < 40) {
      return [green10, green100];
    } else if (progress >= 40 && progress < 60) {
      return [yellow10, yellow100];
    } else if (progress >= 60 && progress < 80) {
      return [orange10, orange100];
    } else if (progress >= 80 && progress < 100) {
      return [red10, red100];
    } else {
      return [maroon10, maroon100];
    }
  }

}

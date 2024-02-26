import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF26527A);
  static const Color button = Color(0xFF2C3E50);
  static const Color textPrimary = Color(0xFF152C5B);
  static const Color blue = Color(0xFF1787E7);
  static const Color yellowLight = Color(0xFFF6CE42);

  static const Color textGrey = Color(0xFF434343);

  static const Color white = Color(0xFFffffff);
  static const Color lightWhite = Color.fromARGB(255, 238, 238, 238);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFFF0000);
  static const Color gry = Color(0xFF8C93A3);
  static const Color lightBlack = Color(0xff161616);
  static const Color aqua = Color(0xff26DBDC);
  static const Color deepSkyBlue = Color(0xff1787E7);

  static const Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 30, 62, 94),
        Color(0xff3498DB),
      ]
      //     [
      //   Color.fromARGB(255, 22, 48, 75),
      //   Color.fromARGB(255, 39, 80, 121),
      //   Color.fromARGB(255, 48, 136, 194),
      // ],
      );
}

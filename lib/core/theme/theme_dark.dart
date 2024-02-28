// import 'package:up_down_app/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:roomrounds/core/extensions/app_theme_extension.dart';
import 'package:roomrounds/core/theme/app_theme.dart';

class ThemeDark extends AppTheme {
  ThemeData get theme => ThemeData(
      // fontFamily: 'youtube_sans',
      useMaterial3: true,
      primarySwatch: primarySwatch,
      extensions: [extension],
      cardColor: cardColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      canvasColor: cardColor,
      appBarTheme: const AppBarTheme(centerTitle: true),
      // fontFamily: FontFamily.poppins,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: errorColor,
        surface: cardColor,
        onSurface: Colors.black,
      ),
      inputDecorationTheme: inputDecorationTheme,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: onPrimary),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));

  @override
  MaterialColor get primarySwatch => createMaterialColor(primary);

  @override
  Color get primary => const Color(0x0026527a);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  @override
  Color get secondary => const Color(0xFF8C93A3);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  @override
  Color get errorColor => Colors.red;

  @override
  Color get scaffoldBackgroundColor => const Color(0xffFFFFFF);

  @override
  Color get cardColor => const Color(0xFF232323);

  @override
  Color get orange => const Color(0xFFFF8E7C);

  @override
  TextTheme get textTheme => const TextTheme();

  @override
  AppThemeExtension get extension => AppThemeExtension(
        orange: orange,
        extraLightGrey: Colors.grey.withOpacity(0.3),
        lightGrey: Colors.grey.withOpacity(0.7),
        vertical: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primary, secondary],
        ),
        horizontal: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [primary, secondary],
        ),
      );

  @override
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds.abs()).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds.abs()).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds.abs()).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        fillColor: onPrimary,
        errorStyle: textTheme.bodySmall?.copyWith(color: errorColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 0.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: errorColor),
        ),
      );
}

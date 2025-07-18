import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF26527A);
  static const Color button = Color(0xFF2C3E50);
  static const Color textPrimary = Color(0xFF152C5B);
  static const Color blue = Color(0xFF1787E7);
  static const Color orange = Color(0xffE67E22);

  static const Color textGrey = Color(0xFF434343);
  static const Color yellowDark = Color(0xffC29A0A);
  static const Color yellowLight = Color(0xffFFC700);

  static const Color white = Color(0xFFffffff);
  static const Color lightWhite =
      Color(0xFFF1F1F1); // Color.fromARGB(255, 238, 238, 238);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFFF0000);
  static const Color gry = Color(0xFF8C93A3);

  // static const Color lightGrey = Color(0xFFF1F1F1);
  static const Color darkGrey = Color(0xFF605E5E);
  static const Color lightBlack = Color(0xff161616);
  static const Color aqua = Color(0xff26DBDC);
  static const Color green = Color(0xffB9FFAD);
  static const Color greenDark = Color(0xff3E8633);
  static const Color deepSkyBlue = Color(0xff326FEA);
  static const Color divider = Color(0xFFD3D3D3);
  static const String pending = 'Pending';
  static const String resolved = 'Resolved';
  static const String requiredOutsideVendor = 'Required Outside Vendors';
  static const String needPurchases = 'Need Purchases';
  static const String unableToResolve = 'Unable to Resolve';
  static const String open = 'Open';

  // Define colors as static constants
  static final Color pendingColor = Color(0xFFFFFCE2);
  static final Color resolvedColor = Color(0xFFEAFFF3);
  static final Color vendorColor = Color(0xFFFDF0FF);
  static final Color purchasesColor = Color(0xFFFFDFE4);
  static final Color unableColor = Color(0xFFFFEDDD);
  static final Color openColor = Color(0xFFDCF6FF);

  // Get color based on status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return pendingColor;
      case 'resolved':
        return resolvedColor;
      case 'required outside vendor':
        return vendorColor;
      case 'need purchases':
        return purchasesColor;
      case 'unable to resolve':
        return unableColor;
      case 'open':
        return openColor;
      default:
        return openColor;
    }
  }

  static const Gradient profileGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff265780),
        Color(0xff24719C),
      ]);
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

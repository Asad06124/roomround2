import 'package:flutter/services.dart';

mixin InputFormatter {
  TextInputFormatter get noSpaceFormatter => FilteringTextInputFormatter.deny(RegExp(r'\s'));
  // only decimal numbers
  TextInputFormatter get decimalFormatter => FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));
}

import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray700 = fromHex('#636363');

  static Color black90099 = fromHex('#99000000');

  static Color blueGray50 = fromHex('#efeef3');

  static Color black900 = fromHex('#000000');

  static Color lightGreenA700 = fromHex('#47e91f');

  static Color blueA200 = fromHex('#5688f7');

  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

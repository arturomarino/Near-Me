import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyThemeLight {
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    
    brightness: Brightness.light,
    primaryColor: Colors.blue, // Change the primary color here
    scaffoldBackgroundColor: Colors.white,
    barBackgroundColor: Colors.white,
    textTheme: CupertinoTextThemeData(primaryColor: Colors.red)
  );
}

class MyThemeDark {
  static final CupertinoThemeData darkTheme = CupertinoThemeData(

      //primaryContrastingColor: Colors.black,
      brightness: Brightness.dark,
      primaryColor: Colors.blue, // Change the primary color here
      scaffoldBackgroundColor: Colors.white,
      barBackgroundColor: Colors.white,
      textTheme: CupertinoTextThemeData(primaryColor: Colors.red));
}
import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    unselectedWidgetColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.blue,
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColorDark: Colors.blue[900],
    
  );


  static final lightTheme = ThemeData(
    unselectedWidgetColor: Colors.black,
    scaffoldBackgroundColor: Colors.white
  );
}

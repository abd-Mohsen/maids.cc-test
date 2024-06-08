import 'package:flutter/material.dart';

import 'constants.dart';

///custom themes

class MyThemes {
  static ThemeData myDarkMode = ThemeData.dark().copyWith(
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff02979D),
      onPrimary: Colors.black,
      secondary: Color(0xff03DAC6),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      background: Color(0xff121212),
      onBackground: Color(0xffA4A4A4),
      surface: Color(0xff1e1e1e),
      onSurface: Color(0xffD7D7D7),
    ),
    textTheme: kMyTextTheme,
  );

  static ThemeData myLightMode = ThemeData.light().copyWith(
    splashColor: Colors.transparent,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xff02979D),
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.grey[300]!,
      onSurface: Colors.black,
    ),
    textTheme: kMyTextTheme,
  );
}

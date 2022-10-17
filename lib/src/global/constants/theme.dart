import 'package:flutter/material.dart';
import 'package:money_save/src/global/constants/strings.dart';

import 'app_colors.dart';

class MoneyTheme {
  static TextTheme lightTextTheme = const TextTheme(
    headline1: TextStyle(
      fontFamily: Strings.sfProText,
      fontSize: 45,
      fontWeight: FontWeight.w700,
    ),
    headline2: TextStyle(
      fontSize: 25.0,
      fontFamily: Strings.sfProText,
      fontWeight: FontWeight.w600,
    ),
    headline3: TextStyle(
      color: Color(0xff172b4d),
      fontSize: 16,
      //  fontFamily: Strings.sfUiDisplay,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
    ),
    headline4: TextStyle(
      //fontFamily: Strings.avenir,
      color: Color(0xff000000),
      fontSize: 15,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.15,
    ),
    headline5: TextStyle(
      //fontFamily: Strings.arial,
      color: Color(0xff26292a),
      fontSize: 36,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    ),
    headline6: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    subtitle1: TextStyle(
      fontFamily: Strings.sfProText,
      fontSize: 16,
      fontWeight: FontWeight.w200,
    ),
    subtitle2: TextStyle(
      // fontFamily: Strings.sfUiDisplay,
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
    ),
    bodyText1: TextStyle(
      color: AppColors.colorWhite,
      fontSize: 17.0,
      fontFamily: Strings.sfProText,
      fontWeight: FontWeight.w600,
    ),
    bodyText2: TextStyle(
      fontSize: 16.0,
      fontFamily: Strings.sfProText,
      fontWeight: FontWeight.w500,
    ),
    button: TextStyle(
      // fontFamily: Strings.avenir,
      color: AppColors.colorBlackButton,
      fontSize: 14,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.28,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.black;
          },
        ),
      ),
      textTheme: lightTextTheme,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xfff7b700),
      errorColor: const Color(0xffEA4335),
      highlightColor: const Color(0xffffffff),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xfff7b700),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
    );
  }
}

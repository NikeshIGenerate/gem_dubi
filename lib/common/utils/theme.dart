import 'package:flutter/material.dart';

ThemeData get themeData => ThemeData(
      useMaterial3: true,
      primarySwatch: whiteMaterialColor,
    );

const kDarkPrimary = Color(0xff553285);
const kDarkPrimaryDark = Color(0xff36175E);
const kDarkPrimaryLight = Color(0xff7B52AB);
const kDarkBackgroundColor = Color(0xff1e2630);
const kDarkCardColor = Color(0xff253341);

final defaultDarkTheme = ThemeData(brightness: Brightness.dark);

var whiteMaterialColor = const MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color.fromRGBO(0, 0, 0, 0.1),
    100: Color.fromRGBO(0, 0, 0, 0.2),
    200: Color.fromRGBO(0, 0, 0, 0.3),
    300: Color.fromRGBO(0, 0, 0, 0.4),
    400: Color.fromRGBO(0, 0, 0, 0.5),
    500: Color.fromRGBO(0, 0, 0, 0.6),
    600: Color.fromRGBO(0, 0, 0, 0.7),
    700: Color.fromRGBO(0, 0, 0, 0.8),
    800: Color.fromRGBO(0, 0, 0, 0.9),
    900: Color.fromRGBO(0, 0, 0, 1.0),
  },
);

ThemeData get darkThemeData => ThemeData(
      useMaterial3: false,
      primarySwatch: whiteMaterialColor,
      primaryColor: Colors.black,
      primaryColorDark: Colors.black,
      primaryColorLight: Colors.black,
      colorScheme: ColorScheme.fromSeed(
        secondary: Colors.black,
        brightness: Brightness.dark,
        onPrimary: Colors.white,
        seedColor: Colors.black,
        primary: Colors.white,
      ),
      textTheme: defaultDarkTheme.textTheme.apply(
        displayColor: Colors.white,
        bodyColor: Colors.white70,
      ),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kDarkCardColor,
          // hintStyle: const TextStyle(
          //   fontSize: 14,
          //   color: Colors.white30,
          // ),
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          // floatingLabelAlignment: FloatingLabelAlignment.center,
          // prefixIconColor: Colors.black,
          // suffixIconColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          // isDense: true,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 3,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: Colors.black,
      cardColor: kDarkCardColor,
      canvasColor: kDarkCardColor,
      cardTheme: const CardTheme(color: kDarkCardColor),
      chipTheme: ChipThemeData(
        backgroundColor: kDarkCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(300),
          side: BorderSide.none,
        ),
        side: BorderSide.none,
      ),
    );

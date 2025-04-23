import 'package:eftkdny/shared/styles/colors.dart';
import 'package:flutter/material.dart';





ThemeData lightTheme = ThemeData(
  colorSchemeSeed: SecondaryColor,
  scaffoldBackgroundColor: Colors.white,
  //  textTheme: GoogleFonts.robotoTextTheme(
  //   Theme.of(context).textTheme,

  fontFamily: 'Cairo',
  
  appBarTheme: const AppBarTheme(
    titleSpacing: 20.0,
    backgroundColor: DefaultColor,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo',
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: DefaultColor,
    unselectedItemColor: Colors.grey,
    backgroundColor: Colors.white,
    elevation: 20.0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: DefaultColor,
    shape: CircleBorder(),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Cairo',
      color: Colors.black,
    ),
  ),
  
);

ThemeData darkTheme = ThemeData(
  colorSchemeSeed: SecondaryColor,
  scaffoldBackgroundColor: Colors.grey[900],
  fontFamily: 'Cairo',
  appBarTheme: const AppBarTheme(
    titleSpacing: 20.0,
    backgroundColor: Colors.grey,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo',
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    backgroundColor: Colors.grey,
    elevation: 20.0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: DefaultColor,
    shape: CircleBorder(),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Cairo',
      color: Colors.white,
    ),
  ),
);

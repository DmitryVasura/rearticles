import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'SFPro',
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.red.shade900,
    onPrimary: Colors.white,
    primaryContainer: Colors.red.shade900,
    onPrimaryContainer: Colors.white,

    secondary: Colors.indigo.shade400,
    onSecondary: Colors.white,

    surface: Colors.grey.shade300,
    onSurface: Colors.black,
    surfaceContainer: Colors.grey.shade100,
    surfaceContainerHigh: Colors.grey.shade600,
    surfaceContainerHighest: Colors.black,

    error: Colors.red,
    onError: Colors.red.shade100,

    shadow: Colors.black.withAlpha(40),
  ),
  
  textTheme: TextTheme(
    bodySmall: TextStyle(
      fontSize: 14, 
      height: 1.4,
      color: Colors.grey.shade600
    ),
    bodyMedium: TextStyle(
      fontSize: 16
    ),
    headlineMedium: TextStyle(
      fontSize: 20, 
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
    headlineSmall: TextStyle(
      fontSize: 18, 
      fontWeight: FontWeight.w300,
      overflow: TextOverflow.ellipsis
    ),
    titleLarge: TextStyle(
      fontSize: 25, 
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),

  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.grey.shade300,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
);
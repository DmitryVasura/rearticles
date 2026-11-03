import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'SFPro',
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.red.shade700,
    onPrimary: Colors.white,
    primaryContainer: Colors.red.shade900,
    onPrimaryContainer: Colors.white,

    secondary: Colors.indigo.shade600,
    onSecondary: Colors.white,

    surface: Colors.grey.shade900,
    onSurface: Colors.white,
    surfaceContainer: Colors.grey.shade800,
    surfaceContainerHigh: Colors.grey.shade400,
    surfaceContainerHighest: Colors.white,
    
    error: Colors.red,
    onError: Colors.red.shade100,

    shadow: Colors.black.withAlpha(150),
  ),
  
  textTheme: TextTheme(
    bodySmall: TextStyle(
      fontSize: 14, 
      height: 1.4,
      color: Colors.grey.shade400,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      overflow: TextOverflow.ellipsis
    ),
    headlineMedium: TextStyle(
      fontSize: 20, 
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis
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
    backgroundColor: Colors.grey.shade900,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
);
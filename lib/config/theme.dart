import 'package:flutter/material.dart';

class AppTheme {

  static const Color mainColor = Color(0xFF4166F5);
  static const Color secondaryColor = Color(0xff516ab1);
  static const Color darkColor = Color(0xff2a344e);
  static const Color ascentColor = Color(0xFFffcc29);

  static ThemeData lightTheme = ThemeData(
      primaryColor: mainColor,
      hintColor: ascentColor,
      fontFamily: 'Poppins',
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ascentColor, // Or a different color for dark theme
        unselectedItemColor: ascentColor.withOpacity(0.6), // Optional
      ),
      scaffoldBackgroundColor:Colors.white,
      iconTheme: const IconThemeData(
        color: mainColor, // Or a different color for dark theme
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppTheme.mainColor,

      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.darkColor ,
        centerTitle: true, // Center the title
        titleTextStyle: TextStyle(
          fontSize: 16.0, // Set font size
          fontWeight: FontWeight.bold,
          color: Colors.white, // Set text color
        ),
      )
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: mainColor,
    hintColor: ascentColor,
    scaffoldBackgroundColor: Colors.white,
  );
}
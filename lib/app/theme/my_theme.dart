import 'package:flutter/material.dart';

MaterialColor customColor = MaterialColor(0xFF1C1A58, <int, Color>{
  50: Color(0xFFE0E0F7),
  100: Color(0xFFB3B3E0),
  200: Color(0xFF8080CC),
  300: Color(0xFF4D4D99),
  400: Color(0xFF1C1A58),
  500: Color(0xFF161540),
  600: Color(0xFF101231),
  700: Color(0xFF0A0A22),
  800: Color(0xFF040413),
  900: Color(0xFF000000),
});

ThemeData getMyTheme() {
  return ThemeData(
    useMaterial3: false,
    primarySwatch: customColor,
    fontFamily: "Poppins",
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.lightGreen,
    ),
  );
}

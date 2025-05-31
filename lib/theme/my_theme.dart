import 'package:flutter/material.dart';

ThemeData getMyTheme() {
  return ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.red,
    fontFamily: "Poppins",
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.lightGreen,
    ),
  );
}

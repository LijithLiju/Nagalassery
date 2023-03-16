import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
	
  final Color primaryColor = Color(0xff005b96);
  final Color backgroundColor = Color(0xffffffff);
  final Color accentColor = Color(0xff03396c);
  final Color buttonColor = Color(0xff011f4b);
  final Color textColor = Colors.black;
//  Color(0xff3425AF),
//  Color(0xffC56CD6),
  ThemeData themeData() {
    return ThemeData(
      fontFamily: 'Roboto',
      accentColor: accentColor,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      buttonColor: buttonColor,
      textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black,)),
      appBarTheme: AppBarTheme(color: primaryColor, brightness: Brightness.dark),
      hintColor: Colors.black,
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
      ),
	    visualDensity: VisualDensity.comfortable
    );
  }
}

import 'package:flutter/material.dart';

const customIconSize = 40;

final ThemeData lightTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xffff8201),
  accentColor: Color(0xffff8201),
  scaffoldBackgroundColor: Color(0xffffdb00),
  // canvasColor: Colors.transparent,
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xffff8201),
  ),
  iconTheme: IconThemeData(
    size: 40.0,
    color: Color(0xffff8201),
  ),
  textTheme: TextTheme(
    subhead: TextStyle(color: Colors.black, fontSize: 20),
    body1: TextStyle(color: Colors.black45),
  ),
  appBarTheme: AppBarTheme(
    color: Color(0xffffdb00),
    brightness: Brightness.light,
    textTheme: TextTheme(
      title: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(
      size: 80.0,
      color: Colors.black,
    ),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xff1f655d),
  accentColor: Color(0xff40bf7a),
  scaffoldBackgroundColor: Colors.grey[800],
  // canvasColor: Colors.transparent,
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xff1f655d),
  ),
  iconTheme: IconThemeData(
    size: 40.0,
    color: Color(0xff1f655d),
  ),
  textTheme: TextTheme(
    subhead: TextStyle(color: Color(0xff40bf7a), fontSize: 20),
    body1: TextStyle(color: Colors.white),
  ),
  appBarTheme: AppBarTheme(color: Color(0xff1f655d)),
);

import 'package:flutter/material.dart';
import 'package:my_podcast/widget/app_theme.dart';

// t could be ThemeName.light or ThemeName.dark
enum ThemeName { light, dark }
String enumParse(ThemeName t) => t.toString().split('.')[1];

// turn ThemeData into something iterable(ThemeName),
// so that we could use ListView.builder-item-index
final appThemeData = {ThemeName.light: lightTheme, ThemeName.dark: darkTheme};

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;

  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appThemeData[ThemeName.light];
    }
    return _themeData;
  }

  setTheme(ThemeName themeName) async {
    _themeData = appThemeData[themeName];
    notifyListeners();
  }
}

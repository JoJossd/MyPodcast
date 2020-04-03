import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_podcast/widget/app_theme.dart';

// t could be ThemeName.light or ThemeName.dark
enum ThemeName { light, dark }
String enumParse(ThemeName t) => t.toString().split('.')[1];

// turn ThemeData into something iterable(ThemeName),
// so that we could use ListView.builder-item-index
final appThemeData = {ThemeName.light: lightTheme, ThemeName.dark: darkTheme};

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;

  // shared_perference key
  final _themePreferenceKey = "theme_preference";

  // point of constructor: add extra operation when instantiating,
  // in this case _loadTheme()
  ThemeManager() {
    _loadTheme();
  }

  void _loadTheme() async {
    debugPrint("Entered loadTheme()");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int perferredTheme = prefs.getInt(_themePreferenceKey) ?? 0;
    _themeData = appThemeData[ThemeName.values[perferredTheme]];
    notifyListeners();
  }

  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appThemeData[ThemeName.light];
    }
    return _themeData;
  }

  setTheme(ThemeName themeName) async {
    _themeData = appThemeData[themeName];
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themePreferenceKey, ThemeName.values.indexOf(themeName));
  }
}

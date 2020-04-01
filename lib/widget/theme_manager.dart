import 'package:flutter/material.dart';
import 'package:my_podcast/page/app_theme.dart';

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;

  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appThemeData[ThemeName.light];
    }
    return _themeData;
  }

  setTheme(ThemeName theme) async {
    _themeData = appThemeData[theme];
    notifyListeners();
  }
}

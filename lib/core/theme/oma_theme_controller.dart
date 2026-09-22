import 'package:flutter/material.dart';

class OmaThemeController extends ChangeNotifier {
  OmaThemeController({ThemeMode initialThemeMode = ThemeMode.system})
    : _themeMode = initialThemeMode;

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) return;
    _themeMode = value;
    notifyListeners();
  }
}

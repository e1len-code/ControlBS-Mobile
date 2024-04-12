import 'package:flutter/material.dart';

class ThemeStuff {
  String themeString = "";

  ValueNotifier<ThemeMode> theme = ValueNotifier(ThemeMode.system);

  static ThemeStuff? _instance;
  static ThemeStuff instance() {
    _instance ??= ThemeStuff._init();
    return _instance!;
  }

  ThemeStuff._init() {
    theme.value = ThemeMode.system;
  }

  void updateValue(ThemeMode themes) {
    theme.value = themes;
    print(theme.value);
  }
}

import 'package:controlbs_mobile/color_schemes.g.dart';
import 'package:flutter/material.dart';

class ThemeStuff {
  ThemeData dark = ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
  ThemeData light =
      ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

  ValueNotifier<ThemeData> theme = ValueNotifier(
      ThemeData(useMaterial3: true, colorScheme: lightColorScheme));

  static ThemeStuff? _instance;
  static ThemeStuff get instance {
    _instance ??= ThemeStuff._init();
    return _instance!;
  }

  ThemeStuff._init() {
    theme.value = light;
  }

  void updateValue(ThemeData themes) {
    theme.value = themes;
    print(theme.value);
  }
}

class ChangeIconTheme {
  ValueNotifier<String> icon = ValueNotifier("");

  static ChangeIconTheme? _instance;
  static ChangeIconTheme get instance {
    _instance ??= ChangeIconTheme._init();
    return _instance!;
  }

  ChangeIconTheme._init() {
    icon.value = "light";
  }
  void updateValue(String iconValue) {
    icon.value = iconValue;
    print(icon.value);
  }
}

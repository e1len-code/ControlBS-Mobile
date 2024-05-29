import 'package:flutter/material.dart';

class CheckBoxStatusVListenable {
  String statusThemeCheck = "";
  ValueNotifier<int> statusCheck = ValueNotifier(1);
  ValueNotifier<String> urlStatusCheck = ValueNotifier("");

  static CheckBoxStatusVListenable? _instance;
  static CheckBoxStatusVListenable instance() {
    _instance ??= CheckBoxStatusVListenable._init();
    return _instance!;
  }

  CheckBoxStatusVListenable._init() {
    statusCheck.value = 1;
    statusCheckName(1);
  }

  void updateValue(int nroLine) {
    statusCheck.value = nroLine;
    statusCheckName(nroLine);
    //print(theme.value);
  }

  void updateTheme(String theme) {
    statusThemeCheck = theme;
  }

  void statusCheckName(int statusCheckValue) {
    if (statusThemeCheck == "dark") {
      switch (statusCheckValue) {
        case 1:
          urlStatusCheck.value = "assets/undraw_hora_entrada_dark.svg";
        case 2:
          urlStatusCheck.value = "assets/undraw_working_dark.svg";
        case 3:
          urlStatusCheck.value = "assets/undraw_breakfast_dark.svg";
        case 4:
          urlStatusCheck.value = "assets/undraw_departure_final_dark.svg";
        default:
          urlStatusCheck.value = "assets/undraw_working_dark.svg";
      }
    } else {
      switch (statusCheckValue) {
        case 1:
          urlStatusCheck.value = "assets/undraw_hora_entrada.svg";
        case 2:
          urlStatusCheck.value = "assets/undraw_working.svg";
        case 3:
          urlStatusCheck.value = "assets/undraw_breakfast.svg";
        case 4:
          urlStatusCheck.value = "assets/undraw_departure_final.svg";
        default:
          urlStatusCheck.value = "assets/undraw_working.svg";
      }
    }
    if (statusThemeCheck == 'system') {}
  }
}

enum StatusCheck { hourInitMorn, hourFinMorn, hourInitEven, hourFinEven }

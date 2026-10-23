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
          break;
        case 2:
          urlStatusCheck.value = "assets/undraw_working_dark.svg";
          break;
        case 3:
          urlStatusCheck.value = "assets/undraw_breakfast_dark.svg";
          break;
        case 4:
          urlStatusCheck.value = "assets/undraw_departure_final_dark.svg";
          break;
        default:
          urlStatusCheck.value = "assets/undraw_working_dark.svg";
      }
    } else {
      switch (statusCheckValue) {
        case 1:
          urlStatusCheck.value = "assets/undraw_hora_entrada.svg";
          break;
        case 2:
          urlStatusCheck.value = "assets/undraw_working.svg";
          break;
        case 3:
          urlStatusCheck.value = "assets/undraw_breakfast.svg";
          break;
        case 4:
          urlStatusCheck.value = "assets/undraw_departure_final.svg";
          break;
        default:
          urlStatusCheck.value = "assets/undraw_working.svg";
      }
    }
    if (statusThemeCheck == 'system') {}
  }

  int getStatusByTime(DateTime now) {
    final int hour = now.hour;
    if (hour >= 18) return 4; // 6pm salida
    if (hour >= 14) return 2; // 2pm trabajo
    if (hour >= 13) return 3; // 1pm almuerzo
    if (hour >= 9) return 1; // 9am entrada
    return 1;
  }

  void updateValueByTime([DateTime? now]) {
    final int newStatus = getStatusByTime(now ?? DateTime.now());
    updateValue(newStatus);
  }

  String getStatusLabel(int status) {
    switch (status) {
      case 1:
        return "Hora de entrada";
      case 2:
        return "Hora de trabajo";
      case 3:
        return "Hora de almuerzo";
      case 4:
        return "Hora de salida";
      default:
        return "Hora de trabajo";
    }
  }
}

enum StatusCheck { hourInitMorn, hourFinMorn, hourInitEven, hourFinEven }

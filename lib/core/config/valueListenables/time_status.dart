import 'dart:async';

import 'package:flutter/material.dart';

class TimeStatusVListenable {
  late Timer _timer;

  ValueNotifier<DateTime> timeStatus = ValueNotifier(DateTime.now());

  static TimeStatusVListenable? _instance;
  static TimeStatusVListenable instance() {
    _instance ??= TimeStatusVListenable._init();
    return _instance!;
  }

  TimeStatusVListenable._init() {
    timeStatus.value = DateTime.now();
  }

  void updateTime() {
    timeStatus.value = DateTime.now();
  }

  // Detiene el temporizador cuando ya no se necesita
  void dispose() {
    _timer.cancel();
  }
}

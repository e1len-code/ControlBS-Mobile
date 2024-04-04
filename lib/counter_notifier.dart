import 'package:flutter/material.dart';

class CounterNotifier {
  final ValueNotifier<int> count = ValueNotifier<int>(0);

  void incrementCount() {
    count.value++;
  }
}

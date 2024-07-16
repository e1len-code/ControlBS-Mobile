import 'package:flutter/material.dart';

class SnackWidget extends SnackBar {
  static showMessage(BuildContext context, String text,
          {bool isError = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackWidget(
            Text(
              text,
              style: TextStyle(
                  color: isError
                      ? Colors.white
                      : Theme.of(context).colorScheme.primaryContainer),
            ),
            backgroundColor: isError
                ? Colors.red
                : Theme.of(context).colorScheme.primaryContainer),
      );

  final Widget content;
  final Duration duration;
  final String label;
  final Color? backgroundColor;

  const SnackWidget(
    this.content, {
    Key? key,
    this.duration = const Duration(seconds: 3),
    this.label = 'label',
    this.backgroundColor,
  }) : super(
          content: content,
          duration: duration,
          backgroundColor: backgroundColor,
        );
}

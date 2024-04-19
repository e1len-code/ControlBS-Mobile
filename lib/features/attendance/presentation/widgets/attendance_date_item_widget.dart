import 'package:flutter/material.dart';

class AttendanceDateItemWidget extends StatelessWidget {
  const AttendanceDateItemWidget({super.key, required this.date});
  final String date;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(date),
        ));
  }
}

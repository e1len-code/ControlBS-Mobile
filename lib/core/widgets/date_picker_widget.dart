import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget(
      {super.key,
      required this.label,
      this.controller,
      this.suffixIcon,
      readOnly});

  final TextEditingController? controller;
  final String label;
  final Widget? suffixIcon;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final bool readOnly = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
        ),
        TextFormField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: widget.suffixIcon),
          controller: widget.controller,
          readOnly: readOnly,
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2025),
            ).then((value) {
              if (value != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(value);
                widget.controller!.text = formattedDate.toString();
              }
            });
          },
        ),
      ],
    );
  }
}

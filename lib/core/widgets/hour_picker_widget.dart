import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourPickerWidget extends StatefulWidget {
  const HourPickerWidget(
      {super.key,
      required this.label,
      required this.controller,
      this.suffixIcon,
      readOnly});

  final TextEditingController? controller;
  final String label;
  final Widget? suffixIcon;

  @override
  State<HourPickerWidget> createState() => HourPickerWidgetState();
}

class HourPickerWidgetState extends State<HourPickerWidget> {
  late TimeOfDay? timeOfDay = TimeOfDay.fromDateTime(
      DateFormat('HH:mm aa').parse(widget.controller!.text));
  final bool readOnly = false;
  late final controller = widget.controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //TextEditingController? controller = widget.controller;
  }

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
          readOnly: true,
          onTap: () async {
            final TimeOfDay? newTime = await showTimePicker(
              context: context,
              initialTime: controller!.text.isEmpty
                  ? TimeOfDay.now()
                  : TimeOfDay.fromDateTime(
                      DateFormat('HH:mm aa').parse(widget.controller!.text)),
              initialEntryMode: TimePickerEntryMode.input,
            );
            if (newTime != null) {
              timeOfDay = newTime;
              widget.controller!.text = newTime.format(context).toString();
            }
          },
        ),
      ],
    );
  }
}

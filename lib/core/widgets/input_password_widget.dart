import 'package:flutter/material.dart';

class InputPasswordWidget extends StatefulWidget {
  const InputPasswordWidget(
      {super.key,
      required this.label,
      this.controller,
      this.suffixIcon,
      readonly});

  final String label;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {
  final bool readOnly = false;

  bool _visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
        ),
        TextFormField(
          obscureText: !_visiblePassword,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                  isSelected: _visiblePassword,
                  onPressed: () {
                    setState(() {
                      _visiblePassword = !_visiblePassword;
                    });
                  },
                  icon: Icon(_visiblePassword
                      ? Icons.visibility_sharp
                      : Icons.visibility_off_sharp))),
          controller: widget.controller,
          readOnly: readOnly,
        ),
      ],
    );
  }
}

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget(
      {super.key,
      required this.label,
      this.controller,
      this.suffixIcon,
      readOnly});

  final TextEditingController? controller;
  final bool readOnly = false;
  final String label;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: hspaceL,
        ),
        Text(
          label,
        ),
        TextFormField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(), suffixIcon: suffixIcon),
          controller: controller,
          readOnly: readOnly,
        ),
      ],
    );
  }
}

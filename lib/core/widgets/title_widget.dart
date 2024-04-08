import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String? text;
  const TitleWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: fontSizeXXL * 2),
    );
  }
}

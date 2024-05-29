import 'package:controlbs_mobile/core/config/valueListenables/checkbox_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawSVGWidget extends StatefulWidget {
  const DrawSVGWidget({super.key});

  @override
  State<DrawSVGWidget> createState() => DrawSVGWidgetState();
}

class DrawSVGWidgetState extends State<DrawSVGWidget> {
  CheckBoxStatusVListenable checkBoxValueNotifier =
      CheckBoxStatusVListenable.instance();
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: checkBoxValueNotifier.urlStatusCheck,
        builder: ((context, url, child) {
          return Center(
            child: SvgPicture.asset(
              url,
              width: 200,
              height: 200,
            ),
          );
        }));
  }
}

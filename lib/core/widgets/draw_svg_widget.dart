import 'dart:async';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateStatusByHour();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateStatusByHour();
    });
  }

  void _updateStatusByHour() {
    if (!mounted) return;
    checkBoxValueNotifier.updateValueByTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: checkBoxValueNotifier.statusCheck,
        builder: (context, status, child) {
          return ValueListenableBuilder<String>(
              valueListenable: checkBoxValueNotifier.urlStatusCheck,
              builder: ((context, url, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        checkBoxValueNotifier.getStatusLabel(status),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SvgPicture.asset(
                        url,
                        width: 140,
                        height: 140,
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        min: 1,
                        max: 4,
                        divisions: 3,
                        value: (status >= 1 && status <= 4)
                            ? status.toDouble()
                            : 2.0,
                        onChanged: null,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('9am'),
                            Text('1pm'),
                            Text('2pm'),
                            Text('6pm'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }
}

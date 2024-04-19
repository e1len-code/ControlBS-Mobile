import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/utils/datetime_parsing.dart';
import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget(
      {super.key,
      required this.disabled,
      this.hour,
      required this.nroLine,
      this.cleanSelected});

  final DateTime? hour;
  final bool disabled;
  final int nroLine;
  final VoidCallback? cleanSelected;

  @override
  State<CheckBoxWidget> createState() => CheckBoxWidgetState();
}

class CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool selected = false;

  get nroLine => widget.nroLine;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          (!widget.disabled)
              ? InkWell(
                  onTap: () {
                    (widget.cleanSelected != null)
                        ? widget.cleanSelected!.call()
                        : null;
                    selected = true;
                  },
                  // onTap: widget.cleanSelected.call(),
                  child: Container(
                      decoration: BoxDecoration(
                          color: !widget.disabled
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onSecondary,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                        Icons.check_sharp,
                        color: !widget.disabled
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primaryContainer,
                        size: 50,
                      )),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: !widget.disabled
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    Icons.check_sharp,
                    color: !widget.disabled
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.primaryContainer,
                    size: 50,
                  )),
          Text(
            timeFormat(widget.hour),
            style: const TextStyle(fontSize: fontSizeS),
          )
        ],
      ),
    );
  }
}

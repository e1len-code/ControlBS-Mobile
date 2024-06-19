import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final List<Widget> children;
  const ItemWidget({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin:
            const EdgeInsets.symmetric(vertical: vspaceS, horizontal: hspaceM),
        padding:
            const EdgeInsets.symmetric(vertical: vspaceS, horizontal: hspaceM),
        decoration: BoxDecoration(
          color: /* Theme.of(context).primaryColor.withOpacity(0.3) */ /* Color(
              0XFFEEEEEE) */
              Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(children: children));
  }
}

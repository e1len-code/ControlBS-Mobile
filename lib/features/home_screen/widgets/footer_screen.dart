import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Desarrollado por ",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
            const Text(
              "Brain Systems",
              style: TextStyle(
                fontWeight: fontWeightBold,
              ),
            )
          ],
        ),
      ],
    );
  }
}

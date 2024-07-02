import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraTogglesrowWidget extends StatefulWidget {
  final List<CameraDescription> cameras;
  final CameraController? controller;
  final ValueChanged<CameraDescription> onNewCameraSelected;
  const CameraTogglesrowWidget(
      {Key? key,
      required this.cameras,
      required this.controller,
      required this.onNewCameraSelected})
      : super(key: key);

  @override
  State<CameraTogglesrowWidget> createState() => _CameraTogglesrowWidgetState();
}

class _CameraTogglesrowWidgetState extends State<CameraTogglesrowWidget> {
  void onChanged(CameraDescription? description) {
    if (description == null) {
      return;
    }

    widget.onNewCameraSelected(description);
  }

  /// Returns a suitable camera icon for [direction].
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    // This enum is from a different package, so a new value could be added at
    // any time. The example should keep working if that happens.
    // ignore: dead_code
    return Icons.camera;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> toggles = <Widget>[];

    if (widget.cameras.isEmpty) {
      return const Text('None');
    } else {
      for (final CameraDescription cameraDescription in widget.cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(
                getCameraLensIcon(
                  cameraDescription.lensDirection,
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),
              groupValue: widget.controller?.description,
              value: cameraDescription,
              onChanged: onChanged,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }
}

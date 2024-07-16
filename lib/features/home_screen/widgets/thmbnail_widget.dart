import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ThmbnailWidget extends StatefulWidget {
  final CameraController? controller;
  const ThmbnailWidget({
    super.key,
    required this.controller,
  });

  @override
  State<ThmbnailWidget> createState() => _ThmbnailWidgetState();
}

class _ThmbnailWidgetState extends State<ThmbnailWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      return const Center(
        child: Text('...'),
      );
    } else {
      return CameraPreview(widget.controller!);
    }
  }
}

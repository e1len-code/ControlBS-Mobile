import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CaptureControlRowWidgetPage extends StatefulWidget {
  final CameraController? controller;
  final VoidCallback onTakePictureButtonPressed;
  final VoidCallback onVideoRecordButtonPressed;
  final VoidCallback onPauseButtonPressed;
  final VoidCallback onResumeButtonPressed;
  final VoidCallback onStopButtonPressed;
  final VoidCallback onPausePreviewButtonPressed;
  const CaptureControlRowWidgetPage(
      {Key? key,
      required this.controller,
      required this.onTakePictureButtonPressed,
      required this.onVideoRecordButtonPressed,
      required this.onPauseButtonPressed,
      required this.onResumeButtonPressed,
      required this.onStopButtonPressed,
      required this.onPausePreviewButtonPressed})
      : super(key: key);

  @override
  _CaptureControlRowWidgetPageState createState() =>
      _CaptureControlRowWidgetPageState();
}

class _CaptureControlRowWidgetPageState
    extends State<CaptureControlRowWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.blue,
            onPressed: widget.controller != null &&
                    widget.controller!.value.isInitialized &&
                    !widget.controller!.value.isRecordingVideo
                ? widget.onTakePictureButtonPressed
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            color: Colors.blue,
            onPressed: widget.controller != null &&
                    widget.controller!.value.isInitialized &&
                    !widget.controller!.value.isRecordingVideo
                ? widget.onVideoRecordButtonPressed
                : null,
          ),
          IconButton(
            icon: widget.controller != null &&
                    widget.controller!.value.isRecordingPaused
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause),
            color: Colors.blue,
            onPressed: widget.controller != null &&
                    widget.controller!.value.isInitialized &&
                    widget.controller!.value.isRecordingVideo
                ? (widget.controller!.value.isRecordingPaused)
                    ? widget.onResumeButtonPressed
                    : widget.onPauseButtonPressed
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            color: Colors.red,
            onPressed: widget.controller != null &&
                    widget.controller!.value.isInitialized &&
                    widget.controller!.value.isRecordingVideo
                ? widget.onStopButtonPressed
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.pause_presentation),
            color: widget.controller != null &&
                    widget.controller!.value.isPreviewPaused
                ? Colors.red
                : Colors.blue,
            onPressed: widget.controller == null
                ? null
                : widget.onPausePreviewButtonPressed,
          ),
        ],
      ),
    );
  }
}

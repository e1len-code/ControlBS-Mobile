import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ModeControlRowWidgetPage extends StatefulWidget {
  final CameraController? controller;
  final bool enableAudio;
  final VoidCallback onAudioModeButtonPressed;
  const ModeControlRowWidgetPage(
      {Key? key,
      required this.controller,
      required this.enableAudio,
      required this.onAudioModeButtonPressed})
      : super(key: key);

  @override
  _ModeControlRowWidgetPageState createState() =>
      _ModeControlRowWidgetPageState();
}

class _ModeControlRowWidgetPageState extends State<ModeControlRowWidgetPage>
    with TickerProviderStateMixin {
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;

  @override
  initState() {
    super.initState();
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _flashModeControlRowAnimationController.dispose();
    super.dispose();
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: widget.controller?.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: widget.controller?.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: widget.controller?.value.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.always)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: widget.controller?.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      //showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
    }
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      //showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (widget.controller == null) {
      return;
    }

    try {
      await widget.controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      //_showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (widget.controller == null) {
      return;
    }

    try {
      await widget.controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      //_showCameraException(e);
      rethrow;
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (widget.controller != null) {
        final CameraController cameraController = widget.controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          //showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          // showInSnackBar(
          //     'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      //_showCameraException(e);
    }
  }

  Widget _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      foregroundColor: widget.controller?.value.focusMode == FocusMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      foregroundColor: widget.controller?.value.focusMode == FocusMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _focusModeControlRowAnimation,
      child: ClipRect(
        child: ColoredBox(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Focus Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: widget.controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                        : null,
                    onLongPress: () {
                      if (widget.controller != null) {
                        widget.controller!.setFocusPoint(null);
                      }
                      //showInSnackBar('Resetting focus point');
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: widget.controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: Colors.blue,
              onPressed:
                  widget.controller != null ? onFlashModeButtonPressed : null,
            ),
            // The exposure and focus mode are currently not supported on the web.
            ...!kIsWeb
                ? <Widget>[
                    IconButton(
                      icon: const Icon(Icons.filter_center_focus),
                      color: Colors.blue,
                      onPressed: widget.controller != null
                          ? onFocusModeButtonPressed
                          : null,
                    )
                  ]
                : <Widget>[],
            IconButton(
              icon: Icon(
                  widget.enableAudio ? Icons.volume_up : Icons.volume_mute),
              color: Colors.blue,
              onPressed: widget.controller != null
                  ? widget.onAudioModeButtonPressed
                  : null,
            ),
            IconButton(
              icon: Icon(
                  widget.controller?.value.isCaptureOrientationLocked ?? false
                      ? Icons.screen_lock_rotation
                      : Icons.screen_rotation),
              color: Colors.blue,
              onPressed: widget.controller != null
                  ? onCaptureOrientationLockButtonPressed
                  : null,
            ),
          ],
        ),
        _flashModeControlRowWidget(),
        //_exposureModeControlRowWidget(),
        _focusModeControlRowWidget(),
      ],
    );
  }
}

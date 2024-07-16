import 'dart:convert';

import 'package:controlbs_mobile/core/widgets/snack_widget.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/features/camera/presentation/widgets/camera_preview_widget.dart';
import 'package:controlbs_mobile/features/camera/presentation/widgets/camera_togglesrow_widget.dart';
import 'package:controlbs_mobile/features/camera/presentation/widgets/capture_controlrow_widget.dart';
import 'package:controlbs_mobile/features/camera/presentation/widgets/mode_controlrow_widget.dart';
import 'package:controlbs_mobile/features/file/domain/entities/file.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:controlbs_mobile/features/home_screen/widgets/thmbnail_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras = <CameraDescription>[];
  CameraController? cameraController;
  late final FileProvider fileProvider;
  late final AuthProvider authProvider;
  bool enableAudio = true;
  XFile? imageFile;
  XFile? videoFile;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;

  @override
  void initState() {
    super.initState();
    fileProvider = context.read<FileProvider>();
    authProvider = context.read<AuthProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _initializeCameraController(_cameras.first);
      }
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  void _logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    SnackWidget.showMessage(context, 'Error: ${e.code}\n${e.description}');
  }

  Future<XFile?> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      SnackWidget.showMessage(context, 'Error: select a camera first.');
      return null;
    }

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController!.takePicture();

      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      return cameraController!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraControllerInit = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    cameraController = cameraControllerInit;

    // If the controller is updated then update the UI.
    cameraControllerInit.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (kDebugMode) {
        print("Se ha iniciado la camara");
      }
      if (cameraControllerInit.value.hasError) {
        SnackWidget.showMessage(context,
            'Camera error ${cameraControllerInit.value.errorDescription}');
      }
    });

    try {
      await cameraControllerInit.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraControllerInit.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                cameraControllerInit
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        cameraControllerInit
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraControllerInit
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          SnackWidget.showMessage(context, 'You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          SnackWidget.showMessage(
              context, 'Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          // iOS only
          SnackWidget.showMessage(context, 'Camera access is restricted.');
        case 'AudioAccessDenied':
          SnackWidget.showMessage(context, 'You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          SnackWidget.showMessage(
              context, 'Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          // iOS only
          SnackWidget.showMessage(context, 'Audio access is restricted.');
        default:
          _showCameraException(e);
          break;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          // videoController?.dispose();
          // videoController = null;
        });
        bool saved = false;
        if (imageFile != null) {
          imageFile!.readAsBytes().then((value) async {
            saved = await fileProvider.save(File(
                fileiden: 0,
                filename: authProvider.authResponse.id.toString(),
                filetype: 'image/jpg',
                filepath: 'imgs/${authProvider.authResponse.id}.jpg',
                fileba64: base64Encode(value)));
            if (mounted) {
              saved
                  ? SnackWidget.showMessage(
                      context, 'la imagen se guardo correctamente')
                  : SnackWidget.showMessage(
                      context, 'Error al guardar la imagennnnnnnnnn');
            }
          });
        }
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (cameraController != null) {
      _onNewCameraSelected(cameraController!.description);
    }
  }

  Future<void> startVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      SnackWidget.showMessage(context, 'Error: select a camera first.');
      return;
    }

    if (cameraController!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController!.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      SnackWidget.showMessage(context, 'Video recording paused');
    });
  }

  Future<void> pauseVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController!.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      SnackWidget.showMessage(context, 'Video recording resumed');
    });
  }

  Future<void> resumeVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController!.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        SnackWidget.showMessage(context, 'Video recorded to ${file.path}');
        videoFile = file;
        //_startVideoPlayer();
      }
    });
  }

  Future<XFile?> stopVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController!.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> onPausePreviewButtonPressed() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      SnackWidget.showMessage(context, 'Error: select a camera first.');
      return;
    }

    if (cameraController!.value.isPreviewPaused) {
      await cameraController!.resumePreview();
    } else {
      await cameraController!.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          centerTitle: true,
          toolbarHeight: 80,
          title: Center(
            child: ModeControlRowWidgetPage(
                controller: cameraController,
                enableAudio: enableAudio,
                onAudioModeButtonPressed: onAudioModeButtonPressed),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: cameraController != null &&
                                  cameraController!.value.isRecordingVideo
                              ? Colors.red
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                      child: CameraPreviewWidget(controller: cameraController),
                    ),
                  ),
                ),
              ),
            ),
            CaptureControlRowWidgetPage(
              controller: cameraController,
              onTakePictureButtonPressed: onTakePictureButtonPressed,
              onVideoRecordButtonPressed: onVideoRecordButtonPressed,
              onPauseButtonPressed: onPauseButtonPressed,
              onResumeButtonPressed: onResumeButtonPressed,
              onStopButtonPressed: onStopButtonPressed,
              onPausePreviewButtonPressed: onPausePreviewButtonPressed,
            ),
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CameraTogglesrowWidget(
                        cameras: _cameras,
                        controller: cameraController,
                        onNewCameraSelected: _onNewCameraSelected),
                    ThmbnailWidget(controller: cameraController),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

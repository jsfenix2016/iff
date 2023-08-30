import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';

import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/PushAlert/Controller/push_alert_controller.dart';
import 'package:camera/camera.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';

class PushAlertPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const PushAlertPage({Key? key, required this.contactZone}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.
  final ContactZoneRiskBD contactZone;
  @override
  State<PushAlertPage> createState() => _PushAlertPageState();
}

class _PushAlertPageState extends State<PushAlertPage> {
  final PushAlertController pushVC = Get.put(PushAlertController());
  final _prefs = PreferenceUser();
  bool _isRecording = false;
  late CameraController _cameraController;
  late CameraController _cameraControllerfront;
  late bool isActive = false;
  bool _isLoading = true;
  bool isMenu = false;
  bool useTwoCamera = false;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  late final AndroidDeviceInfo info;

  @override
  void initState() {
    checkpremium();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      // Iniciar la grabación de video
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_prefs.getUserFree == false) {
      _cameraController.dispose();
      _cameraControllerfront.dispose();
    }
    super.dispose();
  }

  _initCamera() async {
    setState(() => _isLoading = true);

    print(info);

    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();

    if (info.brand == 'samsung' && info.model.contains("SM-G")) {
      final front = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
      _cameraControllerfront = CameraController(front, ResolutionPreset.max);
      await _cameraControllerfront.initialize();
    }
    setState(() => _isLoading = false);
  }

  // Future<void> setupCameras() async {
  //   setState(() => _isLoading = true);
  //   final cameras = await availableCameras();
  //   final front = cameras.firstWhere(
  //       (camera) => camera.lensDirection == CameraLensDirection.front);
  //   final back = cameras.firstWhere(
  //       (camera) => camera.lensDirection == CameraLensDirection.back);

  //   final deviceInfo = DeviceInfoPlugin();
  //   final androidInfo = await deviceInfo.androidInfo;

  //   if (androidInfo.model.contains("SM-G")) {
  //     // Samsung Galaxy S models
  //     _cameraControllerfront = CameraController(front, ResolutionPreset.max);
  //     _cameraController = CameraController(back, ResolutionPreset.max);
  //     useTwoCamera = true;
  //   } else {
  //     // Other devices
  //     _cameraController = CameraController(back, ResolutionPreset.max);
  //   }

  //   await _cameraController.initialize();
  // }

  void checkpremium() async {
    if (_prefs.getUserFree == false || _prefs.getUserPremium) {
      info = await deviceInfoPlugin.androidInfo;
      _initCamera();
    } else {
      setState(() => _isLoading = false);
    }
  }

  _recordVideo() async {
    if (_isRecording) {
      stopRecording();
    } else {
      await _cameraController.startVideoRecording();
      if (info.brand == 'samsung' && info.model.contains("SM-G")) {
        await _cameraControllerfront.startVideoRecording();
      }
      setState(() => _isRecording = true);
    }
  }

  Future<void> saveFree() async {
    setState(() {
      _isLoading = true;
      _isRecording = false;
    });

    var taskIds = await pushVC.updateVideo(widget.contactZone, "", "");
    if (taskIds.isNotEmpty) {
      Route route = MaterialPageRoute(
        builder: (context) =>
            CancelAlertPage(contactRisk: widget.contactZone, taskdIds: taskIds),
      );
      Navigator.pushReplacement(context, route);
    } else {
      Future.sync(() =>
          {showSaveAlert(context, Constant.info, Constant.changeGeneric)});
    }
    setState(() => _isLoading = false);
  }

  late XFile? filefront = null;
  void stopRecording() async {
    setState(() {
      _isLoading = true;
      _isRecording = false;
    });
    final file = await _cameraController.stopVideoRecording();
    if (info.brand == 'samsung' && info.model.contains("SM-G")) {
      filefront = await _cameraControllerfront.stopVideoRecording();
    }
    if (file.path.isNotEmpty) {
      // Detener la grabación de video y detener el timer
      var taskIds = await pushVC.updateVideo(widget.contactZone, file.path,
          filefront == null ? '' : filefront!.path);
      if (taskIds.isNotEmpty) {
        Route route = MaterialPageRoute(
          builder: (context) => CancelAlertPage(
              contactRisk: widget.contactZone, taskdIds: taskIds),
        );
        Navigator.pushReplacement(context, route);
      } else {
        Future.sync(() =>
            {showSaveAlert(context, Constant.info, Constant.changeGeneric)});
      }
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
      Future.sync(() => {
            showSaveAlert(context, Constant.info,
                "Se produjo un error al detener la grabación")
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingIndicator(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: isMenu
            ? AppBar(
                backgroundColor: Colors.brown,
                title: Text(
                  "Alerta zona de riesgo",
                  style: textForTitleApp(),
                ),
              )
            : null,
        body: GestureDetector(
          onTapDown: (details) {
            if (_prefs.getUserFree == false) {
              _recordVideo();
            }
          },
          onTapUp: (details) {
            if (_prefs.getUserFree == false) {
              _recordVideo();
            } else {
              saveFree();
              setState(() => _isLoading = false);
            }
          },
          onPanEnd: (details) {
            if (_prefs.getUserFree == false) {
              _recordVideo();
            } else {
              saveFree();
              setState(() => _isLoading = false);
            }
          },
          child: Container(
            decoration: decorationCustomPush(),
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: _isLoading
                            ? const SizedBox.shrink()
                            : _prefs.getUserPremium
                                ? CameraPreview(_cameraController)
                                : const SizedBox.shrink()),
                  ),
                ),
                (useTwoCamera)
                    ? Positioned(
                        top: 160,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: SizedBox(
                              height: 100,
                              width: 100,
                              child: _isLoading
                                  ? const SizedBox.shrink()
                                  : _prefs.getUserPremium
                                      ? CameraPreview(_cameraControllerfront)
                                      : const SizedBox.shrink()),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                Positioned(
                  top: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 347,
                        width: 363,
                        child: Image.asset(
                          fit: BoxFit.cover,
                          scale: 1,
                          'assets/images/alertButton.png',
                          opacity: const AlwaysStoppedAnimation(.3),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        height: 204,
                        width: 200,
                        child: Image.asset(
                          fit: BoxFit.contain,
                          scale: 0.6,
                          'assets/images/Ellipse 198.png',
                          opacity: const AlwaysStoppedAnimation(.3),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 150,
                  child: Container(
                    height: 100,
                    width: size.width,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Mantén pulsada la pantalla en todo momento.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 24.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(75, 72, 72, 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/PushAlert/Controller/push_alert_controller.dart';
import 'package:camera/camera.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/Utils/Widgets/recoder_count.dart';

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
  bool isReadyToRecord = false;
  bool isMenu = false;
  bool useTwoCamera = false;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  late final AndroidDeviceInfo info;

  late XFile? filefront = null;
  late XFile? fileback = null;

  @override
  void initState() {
    super.initState();
    checkpremium();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      // Iniciar la grabación de video
    });

    starTap();
  }

  @override
  void dispose() async {
    super.dispose();
    if (_prefs.getUserFree == false) {
      await _cameraController.dispose();
      if (info.brand == 'samsung' && info.model.contains("SM-G")) {
        await _cameraControllerfront.dispose();
      }
    }
  }

  _initCamera() async {
    setState(() => _isLoading = true);

    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final front = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
      _cameraController = CameraController(front, ResolutionPreset.max);

      await _cameraController.initialize();
      await _cameraController.prepareForVideoRecording();

      if (info.brand == 'samsung' && info.model.contains("SM-G")) {
        final front = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);
        _cameraControllerfront = CameraController(front, ResolutionPreset.max);
        await _cameraControllerfront.initialize();
        await _cameraControllerfront.prepareForVideoRecording();
      }
    }
    // Una vez que los controladores de la cámara están inicializados,
    // establece _isReadyToRecord en true para indicar al usuario que puede tocar para grabar.
    setState(() {
      _isLoading = false;
      isReadyToRecord = true;
    });
  }

  void checkpremium() async {
    if (_prefs.getUserFree == false || _prefs.getUserPremium) {
      info = await deviceInfoPlugin.androidInfo;
      _initCamera();
    } else {
      setState(() => _isLoading = false);
    }
  }

  _starRecoding() async {
    setState(() => _isRecording = true);

    await Future.wait([
      _cameraController.prepareForVideoRecording(),
      _cameraController.startVideoRecording()
    ]);
    print('Grabando');

    if (info.brand == 'samsung' && info.model.contains("SM-G")) {
      if (!_cameraControllerfront.value.isInitialized) {
        await Future.wait([
          _cameraControllerfront.prepareForVideoRecording(),
          _cameraControllerfront.startVideoRecording()
        ]);
      }
    }
    if (!_cameraController.value.isRecordingVideo) {
      Future.sync(() => {
            showSaveAlert(context, Constant.info,
                'Nose ha iniciado la grabación toque de nuevo la pantalla')
          });
    }
  }

  _recordVideo() async {
    if (_isRecording) {
      stopRecording();
    } else {
      // await _cameraController.startVideoRecording();
      // if (info.brand == 'samsung' && info.model.contains("SM-G")) {
      //   await _cameraControllerfront.startVideoRecording();
      // }
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
      _prefs.setSelectContactRisk = widget.contactZone.id;
      Get.offAll(
        CancelAlertPage(taskIds: taskIds),
      );
    } else {
      Future.sync(() =>
          {showSaveAlert(context, Constant.info, Constant.changeGeneric)});
    }
    setState(() => _isLoading = false);
  }

  void stopRecording() async {
    setState(() {
      _isLoading = true;
      _isRecording = false;
    });

    if (!_prefs.getUserFree || _prefs.getUserPremium) {
      try {
        if (_cameraController.value.isRecordingVideo) {
          fileback = await _cameraController.stopVideoRecording();
        }

        if (info.brand == 'samsung' && info.model.contains("SM-G")) {
          if (_cameraControllerfront.value.isRecordingVideo) {
            filefront = await _cameraControllerfront.stopVideoRecording();
          }
        }

        if (fileback != null && fileback!.path.isNotEmpty) {
          // Detener la grabación de video y detener el timer
          var taskIds = await pushVC.updateVideo(
            widget.contactZone,
            fileback!.path,
            filefront == null ? '' : filefront!.path,
          );

          if (taskIds.isNotEmpty) {
            _prefs.setSelectContactRisk = widget.contactZone.id;
          } else {
            showSaveAlert(context, Constant.info, Constant.changeGeneric);
          }
        } else {
          Future.sync(() => {
                showSaveAlert(context, Constant.info,
                    'Nose ha iniciado la grabación toque de nuevo la pantalla')
              });
        }
      } catch (e) {
        print(e);
        showSaveAlert(
          context,
          Constant.info,
          "Se produjo un error al detener la grabación",
        );
      }

      setState(() => _isLoading = false);
    } else {
      var taskIds = await pushVC.updateVideo(widget.contactZone, '', '');
      if (taskIds.isEmpty) {
        showSaveAlert(context, Constant.info, Constant.changeGeneric);
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingIndicator(
      isLoading: _isLoading && isReadyToRecord,
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: isMenu
              ? AppBar(
                  backgroundColor: Colors.brown,
                  title: Text(
                    "Alerta zona de riesgo",
                    style: textForTitleApp(),
                  ),
                )
              : null,
          body: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: GestureDetector(
              onTapDown: (details) {
                if (_prefs.getUserFree == false && isReadyToRecord) {
                  _starRecoding();
                }
              },
              onTapUp: (details) {
                if (_prefs.getUserFree == false) {
                  stopRecording();
                } else {
                  saveFree();
                }
              },
              onPanEnd: (details) {
                if (_prefs.getUserFree == false) {
                  stopRecording();
                } else {
                  saveFree();
                }
              },
              child: Container(
                decoration: decorationCustomPush(),
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    // Positioned(
                    //   top: 50,
                    //   right: 10,
                    //   child: RecoderCount(
                    //     onChanged: (Duration value) {},
                    //     activate: _isRecording,
                    //   ),
                    // ),
                    Positioned(
                      top: 50,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: _isLoading && !isReadyToRecord
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
                                  child: _isLoading && !isReadyToRecord
                                      ? const SizedBox.shrink()
                                      : _prefs.getUserPremium
                                          ? CameraPreview(
                                              _cameraControllerfront)
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
                            'Mantén pulsada la pantalla en todo momento',
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
        ),
      ),
    );
  }
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
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/FallDetected/Controller/fall_detectedController.dart';

import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:camera/camera.dart';

class PushAlertPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const PushAlertPage({Key? key, required this.contactZone}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.
  final ContactZoneRiskBD contactZone;
  @override
  State<PushAlertPage> createState() => _PushAlertPageState();
}

class _PushAlertPageState extends State<PushAlertPage> {
  final FallDetectedController fallVC = Get.put(FallDetectedController());
  bool _isRecording = false;
  late CameraController _cameraController;
  late bool isActive = false;
  bool _isLoading = true;
  bool isMenu = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      // Iniciar la grabación de video
    });
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      stopRecording();
    } else {
      await _cameraController.prepareForVideoRecording();

      await _cameraController.startVideoRecording();
      _elapsedTime = 0;
      startRecording();
      setState(() => _isRecording = true);
    }
  }

  int _elapsedTime = 0;
  late Timer _timer;
  void startRecording() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void stopRecording() async {
    final file = await _cameraController.stopVideoRecording();
    setState(() => _isRecording = false);

    // Detener la grabación de video y detener el timer
    _timer.cancel();

    var video = await GallerySaver.saveVideo(file.path);
    Route route = MaterialPageRoute(
      builder: (context) => CancelAlertPage(
        contactRisk: widget.contactZone,
      ),
    );
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: isMenu
          ? AppBar(
              backgroundColor: Colors.black,
              title: const Text('Alerta zona de riesgo'),
            )
          : null,
      body: GestureDetector(
        onTapDown: (details) {
          _recordVideo();
        },
        onTapUp: (details) {
          _recordVideo();
        },
        onPanEnd: (details) {
          _recordVideo();
        },
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 347,
                      width: size.width,
                      child: Image.asset(
                        fit: BoxFit.fill,
                        scale: 0.5,
                        'assets/images/alertButton.png',
                        height: 340,
                        width: 340,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 150,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
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
                          color: const Color.fromRGBO(75, 72, 72, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

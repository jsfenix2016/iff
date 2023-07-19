import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/PushAlert/Controller/push_alert_controller.dart';
import 'package:camera/camera.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
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
  bool _isRecording = false;
  late CameraController _cameraController;
  late bool isActive = false;
  bool _isLoading = true;
  bool isMenu = false;

  @override
  void initState() {
    _initCamera();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      // Iniciar la grabación de video
    });

    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    setState(() => _isLoading = true);
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
      await _cameraController.startVideoRecording();

      setState(() => _isRecording = true);
    }
  }

  void stopRecording() async {
    setState(() {
      _isLoading = true;
      _isRecording = false;
    });
    final file = await _cameraController.stopVideoRecording();
    if (file.path.isNotEmpty) {
      // Detener la grabación de video y detener el timer
      var taskIds = await pushVC.updateVideo(widget.contactZone, file.path);
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
                  top: 50,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: _isLoading
                            ? const SizedBox.shrink()
                            : CameraPreview(_cameraController)),
                  ),
                ),
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
      ),
    );
  }
}

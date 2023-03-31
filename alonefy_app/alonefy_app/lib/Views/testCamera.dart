import 'dart:io';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/utils.dart';

import 'package:flutter/material.dart';

import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class TestCameraPage extends StatefulWidget {
  const TestCameraPage({super.key});

  @override
  State<TestCameraPage> createState() => _TestCameraPageState();
}

class _TestCameraPageState extends State<TestCameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late List<CameraDescription> cameras;
  late CameraController firstCameraController;
  late CameraController secondCameraController;
  late XFile _videoFile;
  late XFile _video2File;
  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    firstCameraController.dispose();
    secondCameraController.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      final Directory directory = await getTemporaryDirectory();
      var _videoPath = '${directory.path}/video.mp4';
      await firstCameraController.startVideoRecording();
    } on CameraException catch (e) {
      // manejar la excepción
    }
  }

  _initCamera() async {
    // Obtener una lista de cámaras disponibles en el dispositivo
    final cameras = await availableCameras();

    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    firstCameraController = CameraController(front, ResolutionPreset.medium);

    final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    secondCameraController = CameraController(back, ResolutionPreset.medium);
    await firstCameraController.initialize();

    await secondCameraController.initialize();
  }

  late XFile _videoFile3;
  Future initCameras() async {
    // Iniciar la grabación de video en ambas cámaras
    // await firstCameraController.prepareForVideoRecording();
    await firstCameraController.startVideoRecording();
    await secondCameraController.startVideoRecording();

    // await secondCameraController.startVideoRecording();
    _isRecording = true;
    _isLoading = false;

    // Enviar los archivos de video al backend
    // final response = await http.post('https://backend.com/upload', body: {
    //   'firstVideo': firstVideoPath,
    //   'secondVideo': secondVideoPath,
    // });
    setState(() {});
    print('Videos subidos con éxito');
  }

  void stopCameras() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

    var file = await firstCameraController.stopVideoRecording();

    String filePath = '${appDocumentsDirectory.path}/${file.name}';
    File newVideoFile = File(filePath);
    // final File video = File(file.path);
    // var save = await GallerySaver.saveVideo(video.path);

// Esperar un tiempo para que se graben los videos

    // var save2 = await GallerySaver.saveVideo(file2.path);
    try {
// Detiene la grabación de video

      // Crea un nuevo archivo de video permanente en la ubicación deseada

      // Mueve el archivo de video temporal al archivo permanente
      // await videoFile.saveTo(videoFile.path);
      GallerySaver.saveVideo(newVideoFile.path).then((path) {
        _isLoading = true;
        firstCameraController.dispose();
        setState(() => _isRecording = false);
      });

      await Future.delayed(Duration(seconds: 2));

      var file2 = await secondCameraController.stopVideoRecording();
      GallerySaver.saveVideo(file2.path).then((path) {
        _isLoading = true;
        setState(() => _isRecording = false);
      });
    } catch (e) {
      print(e);
      return Future.error('Error al iniciar la grabación de video: $e');
    }

    // String videoFrontfilePath = '${appDocumentsDirectory.path}/videoFront.mp4';
    // File newvideoFrontFile = File(videoFrontfilePath);

    // Mueve el archivo de video temporal al archivo permanente
    // await videoFrontFile.saveTo(newvideoFrontFile.path);

    // _isLoading = true;
    // setState(() => _isRecording = false);
    // Detener la grabación de video en ambas cámaras
    // var a = await firstCameraController.stopVideoRecording();
    // var b = await secondCameraController.stopVideoRecording();

    // Obtener la ruta del directorio de documentos
    // final Directory directory = await getApplicationDocumentsDirectory();

// Crear una ruta de archivo única para la imagen
    // final String filePath =
    // '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

// Guardar la imagen en la ruta de archivo
    // final File file = File(filePath);
    // await file.writeAsBytes(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: SizedBox(
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: size.width,
                height: size.height - 120,
                child: ListView(
                  children: [
                    Positioned(
                      top: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 128.0, left: 50, right: 50, bottom: 30),
                        child: Container(
                          color: Colors.transparent,
                          width: size.width,
                          child: Text(
                            Constant.hoursSleepAndWakeup,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 24.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //                 if (_isLoading) {
                    //    ;
                    // } else {
                    //    Center(
                    //     child: Stack(
                    //       alignment: Alignment.bottomCenter,
                    //       children: [
                    //         CameraPreview(_cameraController),
                    //         Padding(
                    //           padding: const EdgeInsets.all(0),
                    //           child: FloatingActionButton(
                    //             backgroundColor: Colors.red,
                    //             child: Icon(_isRecording ? Icons.stop : Icons.circle),
                    //             onPressed: () => _recordVideo(),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // },
                    _isLoading
                        ? Container(
                            color: Colors.white,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : CameraPreview(firstCameraController),
                    Container(
                      height: 20,
                      color: Colors.amber,
                    ),
                    _isLoading
                        ? Container(
                            color: Colors.white,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : CameraPreview(secondCameraController),
                  ],
                ),
              ),
              Positioned(
                bottom: 70,
                child: SizedBox(
                  width: size.width,
                  child: Center(
                    child: ElevateButtonFilling(
                      onChanged: (value) {
                        initCameras();
                      },
                      mensaje: "Agregar",
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: SizedBox(
                  width: size.width,
                  child: Center(
                    child: ElevateButtonFilling(
                      onChanged: (value) {
                        stopCameras();
                      },
                      mensaje: Constant.continueTxt,
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

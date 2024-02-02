import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

import 'package:native_image_cropper/native_image_cropper.dart';

import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage(
      {super.key, required this.selectPhoto, required this.bytes});
  final Uint8List bytes;
  final ValueChanged<dynamic> selectPhoto;
  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  File? foto;
  Uint8List? bytesTemp;
  String img64 = "";
  late CropController controller;

  @override
  void initState() {
    super.initState();
    controller = CropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Edición imagen",
          style: textForTitleApp(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            decoration: decorationCustom(),
            width: size.width,
            height: size.height,
            child: Container(
              height: size.height,
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: size.height - 300,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CropPreview(
                        maskOptions: const MaskOptions(aspectRatio: 1),
                        controller: controller,
                        bytes: widget.bytes,
                        mode: CropMode.oval,
                        hitSize: 30,
                        dragPointSize: 10,
                      ),
                    ),
                  ),
                  img64 != ""
                      ? Image.memory(bytesTemp!,
                          fit: BoxFit.cover, width: 100, height: 100.0)
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevateButtonFilling(
                        showIcon: false,
                        onChanged: (value) async {
                          bytesTemp = await controller.crop();
                          img64 = base64Encode(bytesTemp!);
                          Directory appDocDirectory =
                              await getApplicationDocumentsDirectory();

                          final file = File(join(appDocDirectory.uri.path,
                              'crop_${DateTime.now()}.jpg'));

                          await file.exists().then((isThere) {
                            isThere
                                ? print('')
                                : Directory(
                                        '${appDocDirectory.uri.path}${DateTime.now()}')
                                    .createSync(recursive: true);
                          });
                          file.writeAsBytesSync(bytesTemp!,
                              mode: FileMode.append);

                          // File newcrop =
                          //     convertUint8ListToFile(bytes!, "crop.jpg");

                          setState(() {
                            // widget.selectPhoto(file);
                            Navigator.of(context).pop(file);
                          });
                        },
                        mensaje: "Recortar",
                        img: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

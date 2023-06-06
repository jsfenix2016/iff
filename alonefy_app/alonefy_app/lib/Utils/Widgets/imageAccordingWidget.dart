import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Importa el paquete para trabajar con archivos

class ImageFanWidget extends StatefulWidget {
  ImageFanWidget(
      {super.key,
      required this.onChanged,
      required this.listImg,
      required this.isEdit});
  final ValueChanged<List<File>> onChanged;
  List<Uint8List> listImg;
  bool isEdit;
  @override
  State<ImageFanWidget> createState() => _ImageFanWidgetState();
}

class _ImageFanWidgetState extends State<ImageFanWidget> {
  List<File> imagePaths = [File(''), File(''), File('')];

  // Future<List<Uint8List>> convertImageData() async {
  //   List<Uint8List> temp = [];

  //   Uint8List? bytes;
  //   String img64 = "";

  //   for (var i = 0; i < imagePaths.length; i++) {
  //     var path = File(imagePaths[i].path);

  //     Uint8List? bytes;
  //     String img64 = "";

  //     if (path.path != "") {
  //       bytes = path.readAsBytesSync();
  //       img64 = base64Encode(bytes);
  //       temp.insert(i, bytes);
  //     }
  //   }

  //   return temp;
  // }

  Future<void> _pickImage(int index) async {
    // ImagePicker picker = ImagePicker();
    // PickedFile? pickedImage =
    //     await picker.getImage(source: ImageSource.gallery);
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File file;
    setState(() {
      if (image != null) {
        file = File(image.path);
        imagePaths.removeAt(index);
        imagePaths.insert(index, file);
        widget.onChanged(imagePaths);
      }
    });
  }

  // Función para convertir Uint8List en Image
  // Image convertUint8ListToImage(Uint8List data) {
  //   final image = Image.memory(data);
  //   return image;
  // }

  @override
  void initState() {
    super.initState();
  }

  // void convertImg() {
  //   for (var i = 0; i < widget.listImg.length; i++) {
  //     var file = File(widget.listImg[i].toString());
  //     imagePaths.removeAt(i);
  //     imagePaths.insert(i, file);
  //   }
  //   setState(() {});
  // }

  Offset imageOffset = const Offset(0, 0);
  double imageRotation = -0.3;
  File imagePath = File("");
  bool isImageSelected = false;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(imagePaths.length, (index) {
          if (widget.listImg.isEmpty) {
            imagePath = imagePaths[index];
            isImageSelected = imagePath.path != '';
          } else if (index >= widget.listImg.length) {
            isImageSelected = false;
          } else {
            isImageSelected = true;
          }
          if (index == 0) {
            imageOffset = const Offset(0, 0);
            imageRotation = -0.3;
          } else if (index == 1) {
            imageOffset = const Offset(0, -10);
            imageRotation = 0;
          } else if (index == 2) {
            imageOffset = const Offset(0, 0);
            imageRotation = 0.3;
          }

          return GestureDetector(
            onTap: () {
              _pickImage(index);
            },
            child: Transform.translate(
              offset: imageOffset,
              child: Transform.rotate(
                angle: imageRotation,
                child: isImageSelected
                    ? (widget.listImg.isNotEmpty)
                        ? Image.memory(
                            widget.listImg[index],
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            imagePath,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          )
                    : Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 153, 169, 255)
                                  .withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                          border: Border.all(color: ColorPalette.principal),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/icons8.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
              ),
            ),
          );
        }));
  }
}

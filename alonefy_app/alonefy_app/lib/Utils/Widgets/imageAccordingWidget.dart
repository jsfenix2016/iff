import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Importa el paquete para trabajar con archivos

class ImageFanWidget extends StatefulWidget {
  const ImageFanWidget({super.key, required this.onChanged});
  final ValueChanged<List<File>> onChanged;
  @override
  State<ImageFanWidget> createState() => _ImageFanWidgetState();
}

class _ImageFanWidgetState extends State<ImageFanWidget> {
  List<File> imagePaths = [File(''), File(''), File('')];

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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Imagen 1 con rotación
        GestureDetector(
          onTap: () {
            _pickImage(0);
          },
          child: Transform.translate(
            offset: const Offset(0, 0), // Desplazamiento hacia la izquierda
            child: Transform.rotate(
              angle: -0.3,
              child: imagePaths[0].path == ''
                  ? Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 153, 169, 255)
                                .withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: const BorderRadius.all(Radius.circular(
                                0.0) //                 <--- border radius here
                            ),
                        border: Border.all(color: ColorPalette.principal),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/icons8.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Image.file(
                      imagePaths[0],
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),

        // Imagen 2
        // SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _pickImage(1);
          },
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: imagePaths[1].path == ''
                ? Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 153, 169, 255)
                              .withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(
                              0.0) //                 <--- border radius here
                          ),
                      border: Border.all(color: ColorPalette.principal),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/icons8.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Image.file(
                    imagePaths[1],
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        // Imagen 3 con rotación
        // SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _pickImage(2);
          },
          child: Transform.translate(
            offset: const Offset(0, 0), // Desplazamiento hacia la derecha
            child: Transform.rotate(
              angle: 0.3,
              child: imagePaths[2].path == ''
                  ? Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 153, 169, 255)
                                .withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: const BorderRadius.all(Radius.circular(
                                0.0) //                 <--- border radius here
                            ),
                        border: Border.all(color: ColorPalette.principal),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/icons8.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Image.file(
                      imagePaths[2],
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

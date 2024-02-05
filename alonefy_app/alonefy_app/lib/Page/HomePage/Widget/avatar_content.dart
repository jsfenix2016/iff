import 'dart:io';
import 'dart:typed_data';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Page/HomePage/Widget/edit_image.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_image_cropper/native_image_cropper.dart';

class AvatarUserContent extends StatefulWidget {
  const AvatarUserContent(
      {super.key, required this.user, required this.selectPhoto});
  final User? user;
  final ValueChanged<dynamic> selectPhoto;
  @override
  State<AvatarUserContent> createState() => _AvatarContentState();
}

class _AvatarContentState extends State<AvatarUserContent> {
  File? foto;
  final _picker = ImagePicker();
  Uint8List? bytes;
  String img64 = "";
  final controller = CropController();
  //capturar imagen de la galeria de fotos
  Future getImageGallery(ImageSource origen) async {
    final XFile? image = await _picker.pickImage(source: origen);
    File file;

    if (image != null) {
      file = File(image.path);
      setState(() {
        foto = file;
      });
    }

    if (foto!.path != "") {
      bytes = foto!.readAsBytesSync();
    }

    if (foto != null) {
      var a = await Navigator.push(
        RedirectViewNotifier.storedContext!,
        MaterialPageRoute(
          builder: (context) => EditImagePage(
            bytes: bytes!,
            selectPhoto: (value) async {
              setState(() {});
            },
          ),
        ),
      );
      if (a != null) {
        foto = a;
        widget.selectPhoto(a);
      } else {
        foto = null;
        setState(() {});
      }
    }
  }

  File convertUint8ListToFile(Uint8List uint8List, String fileName) {
    final buffer = uint8List.buffer;
    return File(fileName)
      ..writeAsBytesSync(
          buffer.asUint8List(uint8List.offsetInBytes, uint8List.lengthInBytes));
  }

  Widget _mostrarFoto() {
    return GestureDetector(
      onTap: (() async {
        prefs.setOpenGalery = (true);
        getImageGallery(ImageSource.gallery);
      }),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(
              Radius.circular(75.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: DecorationImage(
            image: (foto != null ||
                    widget.user != null && widget.user!.pathImage != "")
                ? (foto != null
                    ? FileImage(foto!, scale: 0.5)
                    : getImage(widget.user!.pathImage).image)
                : const AssetImage("assets/images/icons8.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AvatarGlow(
        glowColor: Colors.white,
        endRadius: 190.0,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: Material(
          elevation: 8.0,
          shape: const CircleBorder(),
          child: _mostrarFoto(),
        ),
      ),
    );
  }
}

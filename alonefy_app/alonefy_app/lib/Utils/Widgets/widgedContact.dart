import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class WidgetContact extends StatelessWidget {
  const WidgetContact(
      {super.key,
      required this.displayName,
      required this.img,
      required this.delete,
      required this.onDelete});
  final String displayName;
  final Uint8List? img;
  final bool delete;
  final void Function(bool) onDelete;
  Widget _mostrarFoto() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 89,
        height: 89,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
              Radius.circular(79.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: DecorationImage(
            image: img != null
                ? Image.memory(img!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250.0)
                    .image
                : const AssetImage("assets/images/icons8.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Image getImage(String urlImage) {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return Image.memory(bytesImages,
        fit: BoxFit.cover, width: double.infinity, height: 250.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(169, 146, 125, 0.5),
        borderRadius: BorderRadius.all(
            Radius.circular(100.0) //                 <--- border radius here
            ),
      ),
      height: 89,
      width: 290,
      child: Stack(
        children: [
          _mostrarFoto(),
          Positioned(
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
              height: 89,
              width: 190,
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    height: 79,
                    width: 150,
                    child: Center(
                      child: Text(
                        displayName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 14.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                    ),
                    height: 30,
                    width: 30,
                    child: IconButton(
                      iconSize: 30,
                      color: ColorPalette.principal,
                      onPressed: () {
                        if (delete) {
                          onDelete(delete);
                        }
                      },
                      icon: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: delete
                                ? const AssetImage('assets/images/Error.png')
                                : const AssetImage(
                                    'assets/images/plussWhite.png'),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

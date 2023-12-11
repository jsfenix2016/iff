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
      required this.onDelete,
      required this.isFilter,
      required this.isExpanded,
      required this.onExpanded});
  final String displayName;
  final Uint8List? img;
  final bool delete;
  final bool isFilter;
  final bool isExpanded;
  final void Function(bool) onDelete;
  final void Function(bool) onExpanded;
  Widget _mostrarFoto() {
    return GestureDetector(
      onTap: expandContact,
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

  void expandContact() {
    print("object");
    if (isExpanded) {
      onExpanded(false);
    } else {
      onExpanded(true);
    }
  }

  Image getImage(String urlImage) {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return Image.memory(bytesImages,
        fit: BoxFit.cover, width: double.infinity, height: 250.0);
  }

  @override
  Widget build(BuildContext context) {
    print(isFilter);
    print(isExpanded);
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(169, 146, 125, 0.5),
        borderRadius: BorderRadius.all(
            Radius.circular(100.0) //                 <--- border radius here
            ),
      ),
      height: 89,
      width: 320,
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
              width: 210,
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    height: 79,
                    width: isFilter
                        ? 170
                        : isExpanded
                            ? 130
                            : 130,
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
                  Visibility(
                    visible: isFilter || isExpanded,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100),
                          topRight: Radius.circular(100),
                        ),
                      ),
                      height: 40,
                      width: 40,
                      child: IconButton(
                        iconSize: 60,
                        color: ColorPalette.principal,
                        onPressed: () {
                          if (delete) {
                            onDelete(delete);
                          }
                        },
                        icon: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: delete
                                  ? const AssetImage(
                                      'assets/images/Group 533.png')
                                  : const AssetImage(
                                      'assets/images/plussWhite.png'),
                              fit: BoxFit.contain,
                            ),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isFilter && !isExpanded,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          height: 30,
                          width: 30,
                          child: IconButton(
                            iconSize: 30,
                            color: ColorPalette.principal,
                            onPressed: expandContact,
                            icon: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/Vector-2.png'),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            height: 35,
                            width: 35,
                            child: IconButton(
                              iconSize: 20,
                              color: Colors.white.withAlpha(170),
                              onPressed: expandContact,
                              icon: Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                        ),
                      ],
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

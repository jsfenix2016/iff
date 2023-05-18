import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/EditContact/PageView/editContact.dart';

class CellContactStatus extends StatefulWidget {
  const CellContactStatus(
      {super.key, required this.contact, required this.onChanged});
  final ContactBD contact;

  final ValueChanged<ContactBD> onChanged;
  @override
  State<CellContactStatus> createState() => _CellContactStatusState();
}

class _CellContactStatusState extends State<CellContactStatus> {
  Uint8List? photo;
  Widget _mostrarFoto(Uint8List? img) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 79,
        height: 79,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
              Radius.circular(79.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: DecorationImage(
            image: (img != null)
                ? Image.memory(img,
                        fit: BoxFit.cover, width: 100, height: 100.0)
                    .image
                : const AssetImage("assets/images/icons8.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Color getColorStatus(String status) {
    switch (status) {
      case "Pendiente":
        return ColorPalette.pendingContact;

      case "Aceptado":
        return ColorPalette.aceptedContact;

      case "Rechazado":
        return ColorPalette.refusedContact;

      default:
        ColorPalette.pendingContact;
    }
    return ColorPalette.pendingContact;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(169, 146, 125, 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(100.0), //                 <--- border radius here
        ),
      ),
      height: 79,
      width: 280,
      child: Stack(
        children: [
          _mostrarFoto(widget.contact.photo),
          Positioned(
            right: 0,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
                height: 79,
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      height: 79,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 30,
                              width: 150,
                              child: Text(
                                widget.contact.displayName,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.barlow(
                                  fontSize: 18.0,
                                  wordSpacing: 1,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            height: 26,
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 4.0, right: 48),
                                decoration: BoxDecoration(
                                  color: getColorStatus(
                                      widget.contact.requestStatus),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                height: 24,
                                width: 77,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Center(
                                    child: Text(
                                      widget.contact.requestStatus,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.barlow(
                                        fontSize: 14.0,
                                        wordSpacing: 1,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(100),
                            topRight: Radius.circular(100),
                          ),
                        ),
                        height: 79,
                        width: 50,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                height: 40,
                                width: 50,
                                child: IconButton(
                                  iconSize: 15,
                                  color: ColorPalette.principal,
                                  onPressed: () {
                                    print("delete contact");
                                    widget.onChanged(widget.contact);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: ColorPalette.principal,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                  ),
                                ),
                                height: 40,
                                width: 50,
                                child: IconButton(
                                  iconSize: 15,
                                  color: ColorPalette.principal,
                                  onPressed: () {
                                    print("edit contact");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditContact(
                                          contact: widget.contact,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: ColorPalette.principal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

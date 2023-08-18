import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/activityDay.dart';

import 'package:flutter/material.dart';

class CardContact extends StatefulWidget {
  const CardContact(
      {Key? key,
      required this.onChanged,
      required this.name,
      required this.photo,
      required this.visible,
      required this.isSelect})
      : super(key: key);
  final String name;
  final Uint8List? photo;
  final bool visible;
  final bool isSelect;
  final ValueChanged<bool> onChanged;
  @override
  // ignore: library_private_types_in_public_api
  State createState() => _CardContactState();
}

class _CardContactState extends State<CardContact> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

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
      width: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 0, child: _mostrarFoto(widget.photo)),
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
                width: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      height: 79,
                      width: 200,
                      child: Center(
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.center,
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
                    Visibility(
                      visible: widget.visible,
                      child: Container(
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
                          iconSize: 23,
                          color: ColorPalette.principal,
                          onPressed: () {
                            widget.onChanged(true);
                          },
                          icon: Container(
                            height: 22.77,
                            width: 20.48,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: widget.isSelect
                                    ? const AssetImage(
                                        'assets/images/pencil.png')
                                    : const AssetImage(
                                        'assets/images/plussWhite.png'),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
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

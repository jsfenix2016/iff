import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Utils/Widgets/imageAccordingWidget.dart';

class CellDateRisk extends StatefulWidget {
  const CellDateRisk({super.key, required this.logAlert});
  final LogAlertsBD logAlert;
  @override
  State<CellDateRisk> createState() => _CellDateRiskState();
}

class _CellDateRiskState extends State<CellDateRisk> {
  int _currentIndex = 0;

  List<File> imagePaths = [File(''), File(''), File('')];
  List<Uint8List> imageData = [];

  Image getImage(String urlImage) {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return Image.memory(bytesImages,
        fit: BoxFit.fill, width: double.infinity, height: 250.0);
  }

  Widget getImageFile(File urlImage) {
    return urlImage.path == ''
        ? Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3), // changes position of shadow
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
            fit: BoxFit.fitHeight,
            scale: 3,
            urlImage,
            height: double.infinity,
            width: double.infinity,
          );
  }

  Widget getImageData(Uint8List img) {
    return Image.memory(
      fit: BoxFit.fitHeight,
      scale: 3,
      img,
      height: double.infinity,
      width: double.infinity,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 120,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                iconSize: 35,
                color: ColorPalette.principal,
                onPressed: () {},
                icon: searchImageForIcon(widget.logAlert.type),
              ),
              Container(
                width: 200,
                color: Colors.transparent,
                child: Text(
                  "Cita - ${widget.logAlert.time.day}-${widget.logAlert.time.month}-${widget.logAlert.time.year} | ${widget.logAlert.time.hour.toString().padLeft(2, '0')}-${widget.logAlert.time.minute.toString().padLeft(2, '0')}",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.barlow(
                    fontSize: 14.0,
                    wordSpacing: 1,
                    letterSpacing: 0.01,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageFanWidget(
                onChanged: (List<File> value) {
                  imagePaths = value;
                  setState(() {});
                },
                listImg: widget.logAlert.photoDate!,
                isEdit: false,
              ),
              Visibility(
                visible: widget.logAlert.photoDate!.isEmpty ? false : true,
                child: IconButton(
                  onPressed: () {
                    //action coe when button is pressed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: SizedBox(
                            child: Column(
                              children: [
                                Expanded(
                                  child: getImageData(widget
                                      .logAlert.photoDate![_currentIndex]),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        _currentIndex = (_currentIndex - 1) %
                                            widget.logAlert.photoDate!.length;
                                        if (_currentIndex < 0) {
                                          _currentIndex = widget
                                                  .logAlert.photoDate!.length -
                                              1;
                                        }
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        _currentIndex = (_currentIndex + 1) %
                                            widget.logAlert.photoDate!.length;
                                        (context as Element).markNeedsBuild();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.preview,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

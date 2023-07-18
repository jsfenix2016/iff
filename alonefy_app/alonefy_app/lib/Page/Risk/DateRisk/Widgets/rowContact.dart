import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

import 'package:intl/intl.dart';

class RowContact extends StatefulWidget {
  const RowContact(
      {Key? key,
      required this.onChanged,
      required this.onChangedDelete,
      required this.index,
      required this.contactRisk,
      required this.onCancel})
      : super(key: key);

  final int index;

  final ValueChanged<bool> onChanged;
  final ValueChanged<bool> onChangedDelete;
  final ValueChanged<bool> onCancel;
  final ContactRiskBD contactRisk;
  @override
  State createState() => _RowContactState();
}

class _RowContactState extends State<RowContact> {
  late String timeLblAM = "00:00 AM";
  DateTime now = DateTime.now();
  DateFormat format = DateFormat();

  @override
  void initState() {
    format = DateFormat("HH:mm");

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    // myFocusNode.dispose();
    super.dispose();
  }

  Color _getColor(
      DateTime endTime, DateTime startTime, bool isActive, bool isProgrammed) {
    DateTime now = DateTime.now();
    bool isAfter = startTime.isAfter(endTime);
    bool isBefore = startTime.isBefore(endTime);

    if (isActive && !isProgrammed && !isAfter) {
      // La cita está activa y no está programada, se muestra en amarillo
      return ColorPalette.principal.withAlpha(900);
    } else if (!isActive && isProgrammed && isBefore) {
      // La cita está programada y aún no ha comenzado, se muestra en azul
      return Colors.blueAccent.withAlpha(900);
    } else if (isAfter && isActive) {
      // La cita ha finalizado, se muestra en rojo
      return Colors.red.withAlpha(900);
    } else {
      // La cita no ha comenzado aún y no está programada, se muestra en un color por defecto
      return const Color.fromRGBO(11, 11, 10, 0.6);
    }
  }

  Color getColor(ContactRiskBD contactRisk) {
    DateTime starTime = parseContactRiskDate(contactRisk.timeinit);
    DateTime endTime = parseContactRiskDate(contactRisk.timefinish);
    return _getColor(
        endTime, starTime, contactRisk.isActived, contactRisk.isprogrammed);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: getColor(widget.contactRisk),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4.0, right: 4),
              child: Container(
                color: Colors.transparent,
                height: 30,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 105,
                      color: Colors.transparent,
                      child: Text(
                        "Hora de inicio:",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.barlow(
                          fontSize: 16.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      parseTimeString(widget.contactRisk.timeinit),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: (() {
                        widget.onChanged(true);
                      }),
                      icon: const Icon(
                        Icons.edit,
                        color: ColorPalette.principal,
                      ),
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: (() {
                        widget.onChangedDelete(true);
                      }),
                      icon: const Icon(
                        Icons.delete,
                        color: ColorPalette.principal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 30,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 110,
                    color: Colors.transparent,
                    child: Text(
                      "Hora de fin:",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 0.001,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 90,
                    color: Colors.transparent,
                    child: Text(
                      parseTimeString(widget.contactRisk.timefinish),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 90,
                    color: Colors.transparent,
                    child: Center(
                      child: IconButton(
                        iconSize: 20,
                        onPressed: (() {}),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 0.0, right: 0),
              child: Container(
                color: Colors.transparent,
                height: 40,
                width: double.infinity,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 8),
                      child: Container(
                        width: 100,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Avisar a:",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 108.0, top: 8),
                      child: Text(
                        widget.contactRisk.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 16.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 8),
                      child: Container(
                        width: 80,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Asunto:",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 108.0, right: 8),
                      child: Container(
                        height: 100,
                        color: Colors.transparent,
                        child: Text(
                          widget.contactRisk.messages,
                          maxLines: 3,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.barlow(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            letterSpacing: 0.001,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: (widget.contactRisk.isActived ||
                      widget.contactRisk.isprogrammed) &&
                  widget.contactRisk.code != '',
              child: ElevateButtonFilling(
                onChanged: (value) {
                  widget.onCancel(true);
                },
                mensaje: 'Cancelar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

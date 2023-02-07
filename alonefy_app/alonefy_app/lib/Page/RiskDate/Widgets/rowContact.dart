import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/activityDay.dart';

import 'package:flutter/material.dart';

class RowContact extends StatefulWidget {
  const RowContact({
    Key? key,
    required this.onChanged,
    required this.hoursIni,
    required this.hoursFinish,
    required this.name,
    required this.message,
  }) : super(key: key);

  final String hoursIni;
  final String hoursFinish;
  final String name;
  final String message;
  final ValueChanged<bool> onChanged;
  @override
  // ignore: library_private_types_in_public_api
  _RowContactState createState() => _RowContactState();
}

class _RowContactState extends State<RowContact> {
  late String timeLblAM = "00:00 AM";
  List<ActivityDay> listTemp = [];
  ActivityDay activityAndInactivity = ActivityDay();
  late FocusNode myFocusNode;

  void _sendRestDay(ActivityDay rest) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: const Color.fromRGBO(169, 146, 125, 0.8),
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
                    Text(
                      "Hora de inicio:",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.hoursIni,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 20.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Positioned(
                      right: 1,
                      child: IconButton(
                        iconSize: 20,
                        onPressed: (() {
                          widget.onChanged(true);
                        }),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.amber,
                        ),
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
                  Text(
                    "Hora de fin:",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.barlow(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 70,
                    color: Colors.transparent,
                    child: Text(
                      widget.hoursFinish,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 20.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
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
              padding: const EdgeInsets.only(top: 4, left: 0.0, right: 0),
              child: Container(
                color: Colors.transparent,
                height: 30,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Avisar a:",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 70,
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
            ),
            Container(
              color: Colors.transparent,
              height: 60,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Asunto:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 220,
                    color: Colors.transparent,
                    child: Text(
                      widget.message,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

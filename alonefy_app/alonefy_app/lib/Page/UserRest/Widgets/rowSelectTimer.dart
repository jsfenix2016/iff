import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restday.dart';

class RowSelectTimer extends StatefulWidget {
  const RowSelectTimer(
      {super.key,
      required this.onChanged,
      required this.timeLblAM,
      required this.timeLblPM,
      required this.index});
  final ValueChanged<RestDay> onChanged;
  final String timeLblAM;
  final String timeLblPM;
  final int index;
  @override
  State<RowSelectTimer> createState() => _RowSelectTimerState();
}

class _RowSelectTimerState extends State<RowSelectTimer> {
  late RestDay restDay;
  late String _timeLblAM = "00:00";
  late String _timeLblPM = "00:00";
  @override
  @override
  void initState() {
    restDay = RestDay();
    restDay.id = 0;
    restDay.timeSleep = _timeLblPM;
    restDay.timeWakeup = _timeLblAM;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () async {
                  _timeLblAM = await displayTimePicker(context, 'timeWakeup');
                  restDay.timeWakeup = _timeLblAM;
                  restDay.timeSleep = widget.timeLblPM;
                  restDay.id = widget.index;
                  widget.onChanged(restDay);
                  setState(() {});
                },
                child: Column(
                  children: [
                    SizedBox(
                      child: Image.asset(
                        scale: 1,
                        fit: BoxFit.fill,
                        'assets/images/Group 979.png',
                        height: 24,
                        width: 44,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.timeLblAM,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 30.0,
                        wordSpacing: 1,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                _timeLblPM = await displayTimePicker(context, 'timeSleep');
                restDay.timeSleep = _timeLblPM;
                restDay.timeWakeup = widget.timeLblAM;
                restDay.id = widget.index;
                widget.onChanged(restDay);
                setState(() {});
              },
              child: Container(
                height: 83,
                color: Colors.transparent,
                child: Column(
                  children: [
                    SizedBox(
                      child: Image.asset(
                        scale: 1,
                        fit: BoxFit.fill,
                        'assets/images/Ellipse 185.png',
                        height: 30,
                        width: 29,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.timeLblPM,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 30.0,
                        wordSpacing: 1,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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

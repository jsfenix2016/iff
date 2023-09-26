import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:intl/intl.dart';

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

  Duration duration = const Duration(hours: 00, minutes: 00);

  int hoursPositionPicker1 = 0;
  int minutesPositionPicker1 = 0;
  int hoursPositionPicker2 = 0;
  int minutesPositionPicker2 = 0;

  String hoursPicker1 = "00";
  String hoursPicker2 = "00";
  String minutesPicker1 = "00";
  String minutesPicker2 = "00";

  Map<String, String> minutes = {};
  @override
  void initState() {
    restDay = RestDay();
    restDay.id = widget.index;
    restDay.timeSleep = widget.timeLblPM;
    restDay.timeWakeup = widget.timeLblAM;
    generateHoursMap();
    var time1 = widget.timeLblPM.contains(" ")
        ? widget.timeLblPM.split(" ")[1].split(":")
        : widget.timeLblPM.split(":");
    var time2 = widget.timeLblAM.contains(" ")
        ? widget.timeLblAM.split(" ")[1].split(":")
        : widget.timeLblAM.split(":");
    hoursPicker2 = time1[0];
    minutesPicker2 = time1[1];
    hoursPicker1 = time2[0];
    minutesPicker1 = time2[1];

    hoursPositionPicker1 = int.parse(hoursPicker1);

    minutesPositionPicker1 = int.parse(minutesPicker1);
    hoursPositionPicker2 = int.parse(hoursPicker2);

    minutesPositionPicker2 = int.parse(minutesPicker2);

    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant RowSelectTimer oldWidget) {
  //   // TODO: implement didUpdateWidget

  //   var time1 = widget.timeLblPM.contains(" ")
  //       ? widget.timeLblPM.split(" ")[1].split(":")
  //       : widget.timeLblPM.split(":");
  //   var time2 = widget.timeLblAM.contains(" ")
  //       ? widget.timeLblAM.split(" ")[1].split(":")
  //       : widget.timeLblAM.split(":");
  //   hoursPicker2 = time1[0];
  //   minutesPicker2 = time1[1];
  //   hoursPicker1 = time2[0];
  //   minutesPicker1 = time2[1];

  //   hoursPositionPicker1 = int.parse(hoursPicker1);

  //   minutesPositionPicker1 = int.parse(minutesPicker1);
  //   hoursPositionPicker2 = int.parse(hoursPicker2);

  //   minutesPositionPicker2 = int.parse(minutesPicker2);
  //   super.didUpdateWidget(oldWidget);
  // }

  String _formatDateTime(DateTime dateTime) {
    // Personaliza el formato de la fecha y hora según tus necesidades
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  late final DateTime initialDateTime = DateTime.now();

  Widget getFutureColumnPicker(
      int initialPosition1, int initialPosition2, int pickerId) {
    return FutureBuilder<Widget>(
        future:
            calculateColumnPicker(initialPosition1, initialPosition2, pickerId),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Container();
          }
        });
  }

  Future<Widget> calculateColumnPicker(
      int initialPosition1, int initialPosition2, int pickerId) {
    return Future<Widget>.delayed(const Duration(milliseconds: 50),
        () => getColumnPicker(initialPosition1, initialPosition2, pickerId));
  }

  void generateHoursMap() {
    for (int i = 0; i <= 59; i++) {
      String hourString = i.toString().padLeft(2, '0');
      minutes[hourString] = hourString;
    }
    print(minutes);
    setState(() {});
  }

  Widget getColumnPicker(
      int initialPosition1, int initialPosition2, int pickerId) {
    return Column(
      children: [
        Row(
          children: [
            getPicker(initialPosition1, Constant.hours, pickerId),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                ":",
                style: GoogleFonts.barlow(
                  fontSize: 24.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            getPicker(initialPosition2, minutes, pickerId)
          ],
        )
      ],
    );
  }

  var item = "";
  Widget getPicker(
      int initialPosition, Map<String, String> time, int pickerId) {
    return SizedBox(
      width: 60,
      height: 120,
      child: CupertinoPicker(
        diameterRatio: 2,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          background: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        onSelectedItemChanged: (int value) {
          var selectedValue = time.values.elementAt(value);
          if (pickerId == 0 && time == Constant.hours) {
            hoursPicker1 = selectedValue;
          } else if (pickerId == 0 && time == minutes) {
            minutesPicker1 = selectedValue;
          } else if (pickerId == 1 && time == Constant.hours) {
            hoursPicker2 = selectedValue;
          } else if (pickerId == 1 && time == minutes) {
            minutesPicker2 = selectedValue;
          }
          if (pickerId == 0) {
            restDay.timeWakeup = "$hoursPicker1:$minutesPicker1:00";
            // restDay.timeWakeup =
            //     "${initialDateTime.year}-${initialDateTime.month}-${initialDateTime.day} $hoursPicker1:$minutesPicker1";
          } else {
            // restDay.timeSleep =
            //     "${initialDateTime.year}-${initialDateTime.month}-${initialDateTime.day} $hoursPicker2:$minutesPicker2";
            restDay.timeSleep = "$hoursPicker2:$minutesPicker2:00";
          }
          widget.onChanged(restDay);
        },
        scrollController:
            FixedExtentScrollController(initialItem: initialPosition),
        itemExtent: 60.0,
        children: [
          for (var value in time.values) ...[
            Container(
              height: 24,
              width: 120,
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 24.0,
                      wordSpacing: 1,
                      letterSpacing: 0.001,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        key: Key(widget.index.toString()),
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Image.asset(
                      scale: 1,
                      fit: BoxFit.fill,
                      'assets/images/dormir (6).png',
                      height: 30,
                      width: 29,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getFutureColumnPicker(
                          hoursPositionPicker2, minutesPositionPicker2, 1),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              key: Key(widget.index.toString()),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(
                      scale: 1,
                      fit: BoxFit.cover,
                      'assets/images/reloj (3).png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getFutureColumnPicker(
                          hoursPositionPicker1, minutesPositionPicker1, 0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

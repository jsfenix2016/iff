import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  @override
  void initState() {
    restDay = RestDay();
    restDay.id = widget.index;
    restDay.timeSleep = widget.timeLblPM;
    restDay.timeWakeup = widget.timeLblAM;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        key: Key(widget.index.toString()),
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              key: Key(widget.index.toString()),
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(
                    child: Image.asset(
                      scale: 1,
                      fit: BoxFit.fill,
                      'assets/images/Group 979.png',
                      height: 30,
                      width: 54,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 230,
                    height: 80,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                        primaryColor: CupertinoColors.white,
                        barBackgroundColor: CupertinoColors.black,
                        scaffoldBackgroundColor: CupertinoColors.black,
                        textTheme: CupertinoTextThemeData(
                          primaryColor: CupertinoColors.white,
                          textStyle: TextStyle(color: Colors.transparent),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        key: const Key('wakeup'),
                        initialDateTime: parseDurationRow(restDay.timeWakeup),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (value) {
                          var timeLblAM = value.toString();
                          restDay.timeWakeup = timeLblAM;
                          restDay.timeSleep = restDay.timeSleep != '00:00'
                              ? restDay.timeSleep
                              : widget.timeLblPM;
                          restDay.id = widget.index;

                          widget.onChanged(restDay);

                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
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
                SizedBox(
                  width: 230,
                  height: 80,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.dark,
                      primaryColor: CupertinoColors.white,
                      barBackgroundColor: CupertinoColors.black,
                      scaffoldBackgroundColor: CupertinoColors.black,
                      textTheme: CupertinoTextThemeData(
                        primaryColor: CupertinoColors.white,
                        textStyle: TextStyle(color: Colors.transparent),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      key: const Key('timeSleep'),
                      initialDateTime: parseDurationRow(restDay.timeSleep),
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      onDateTimeChanged: (value) {
                        var timeLblPM = value.toString();
                        restDay.timeWakeup = restDay.timeWakeup != '00:00'
                            ? restDay.timeWakeup
                            : widget.timeLblAM;
                        restDay.timeSleep = timeLblPM;

                        restDay.id = widget.index;
                        widget.onChanged(restDay);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

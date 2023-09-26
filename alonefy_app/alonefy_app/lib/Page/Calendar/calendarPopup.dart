import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/main.dart';

import 'package:jiffy/jiffy.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class RangeDateTime {
  DateTime? from;
  DateTime? to;
}

Future<RangeDateTime?> showCalendar(BuildContext context) async {
  return showGeneralDialog<RangeDateTime>(
    context: context,
    barrierColor: Colors.black12.withOpacity(1), // Background color
    barrierDismissible: false,
    barrierLabel: 'Dialog',
    pageBuilder: (_, __, ___) {
      return CalendarPopup();
    },
  );
}

RangeDateTime _getRangeDate() {
  var rangeDateTime = RangeDateTime();
  rangeDateTime.from = _from;
  rangeDateTime.to = _to;

  return rangeDateTime;
}

String getFrom() {
  return Jiffy(_from!).format('MMMM yyyy');
}

DateTime? _from;
DateTime? _to;

class CalendarPopup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarPopupState();
}

class CalendarPopupState extends State<CalendarPopup> {
  final List<String> _days = List.filled(42, "");
  final List<bool> _paintedDays = List.filled(42, false);
  var _currentDate = DateTime.now();

  String _monthWithYear = "";

  List<String> daysOfWeek = ["Lu", "Ma", "Mi", "Ju", "Vi", "Sá", "Do"];

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(milliseconds: 400),
    () => 'Data Loaded',
  );

  void updateMonthWithYear() async {
    await Jiffy.locale("es");
    var monthWithYear =
        Jiffy(_currentDate).format('MMMM yyyy').capitalizeFirst!;
    setState(() {
      _monthWithYear = monthWithYear;
    });
  }

  int getDaysOfMonth() {
    var days = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    return days;
  }

  void fillCalendarWithMonthDays() async {
    var tempDate = DateTime(_currentDate.year, _currentDate.month, 1);
    var weekDay = tempDate.weekday;

    var dayNumber = 1;
    var calendarIndex = 0;

    for (var index = 0; index < _days.length; index++) {
      if (weekDay == (index + 1) && index < 7) {
        _days[index] = dayNumber.toString();
        dayNumber++;
        calendarIndex = index + 1;
        break;
      } else {
        _days[index] = "";
      }
    }

    for (var index = 2; index <= getDaysOfMonth(); index++) {
      _days[calendarIndex] = index.toString();
      calendarIndex++;
    }

    for (var index = calendarIndex; index < _days.length; index++) {
      _days[index] = "";
    }

    //setState(() {});
  }

  void nextMonth() {
    _currentDate = Jiffy(_currentDate).add(months: 1).dateTime;
  }

  void previousMonth() {
    _currentDate = Jiffy(_currentDate).subtract(months: 1).dateTime;
  }

  void selectDay(int index) {
    var selectedDay = int.parse(_days[index]);
    var selectedDate =
        DateTime(_currentDate.year, _currentDate.month, selectedDay);

    if (_from == null) {
      _from = selectedDate;
    } else if (_from != null && _to != null) {
      _to = null;
      _from = selectedDate;
    } else {
      if (_from!.isAtSameMomentAs(selectedDate) ||
          _from!.isBefore(selectedDate)) {
        _to = selectedDate;
      } else {
        _to = DateTime(_from!.year, _from!.month, _from!.day);
        _from = selectedDate;
      }
    }

    //setState(() {
    //});
  }

  void paintSelectedDays() {
    if (_from != null && _to != null) {
      var minCurrentDate = DateTime(_currentDate.year, _currentDate.month, 1);
      var maxCurrentDate =
          DateTime(_currentDate.year, _currentDate.month + 1, 1);

      DateTime? tempFrom;
      DateTime? tempTo;

      if (!_to!.isBefore(minCurrentDate) && _from!.isBefore(maxCurrentDate)) {
        if (_from!.isBefore(minCurrentDate)) {
          tempFrom = DateTime(_currentDate.year, _currentDate.month, 1);
        } else {
          tempFrom = DateTime(_from!.year, _from!.month, _from!.day);
        }

        if (_to!.isAtSameMomentAs(maxCurrentDate) ||
            _to!.isAfter(maxCurrentDate)) {
          tempTo = DateTime(_currentDate.year, _currentDate.month + 1, 0);
        } else {
          tempTo = DateTime(_to!.year, _to!.month, _to!.day);
        }
      }

      for (var index = 0; index < _days.length; index++) {
        _paintedDays[index] = false;

        if (_days[index] != "") {
          if (!_to!.isBefore(minCurrentDate) &&
              _from!.isBefore(maxCurrentDate)) {
            if (int.parse(_days[index]) >= tempFrom!.day &&
                int.parse(_days[index]) <= tempTo!.day) {
              _paintedDays[index] = true;
            }
          }
        }
      }
    } else if (_from != null) {
      if (_currentDate.year == _from!.year &&
          _currentDate.month == _from!.month) {
        for (var index = 0; index < _days.length; index++) {
          if (_days[index] != "" && int.parse(_days[index]) == _from!.day) {
            for (var i = 0; i < _paintedDays.length; i++) {
              _paintedDays[i] = false;
            }
            _paintedDays[index] = true;
            break;
          }
        }
      } else {
        for (var i = 0; i < _paintedDays.length; i++) {
          _paintedDays[i] = false;
        }
      }
    }

    //setState(() {});
  }

  @override
  void initState() {
    super.initState();
    starTap();
    _currentDate = DateTime.now();
    _from = null;
    _to = null;
    updateMonthWithYear();
    fillCalendarWithMonthDays();
    paintSelectedDays();
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            decoration: decorationCustom(),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(36, 70, 36, 0),
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        decoration: BoxDecoration(
                            color: ColorPalette.backgroundDarkGrey,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  previousMonth();
                                  updateMonthWithYear();
                                  fillCalendarWithMonthDays();
                                  paintSelectedDays();
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                _monthWithYear,
                                style: GoogleFonts.barlow(
                                  fontSize: 16.0,
                                  wordSpacing: 1,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  nextMonth();
                                  updateMonthWithYear();
                                  fillCalendarWithMonthDays();
                                  paintSelectedDays();
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ))),
                Padding(
                    padding: const EdgeInsets.fromLTRB(36, 24, 36, 0),
                    child: Row(
                      children: [
                        for (var index = 0;
                            index < daysOfWeek.length;
                            index++) ...[getDayOfWeek(index)]
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(36, 8, 36, 0),
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                          color: ColorPalette.calendarNumber),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(36, 0, 36, 8),
                    child: FutureBuilder<String>(
                        future: _calculation,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return GridView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7),
                                itemCount: _days.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return Container(
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        child: Text(
                                          _days[index],
                                          style: GoogleFonts.barlow(
                                            fontSize: 16.0,
                                            wordSpacing: 1,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.bold,
                                            color: _paintedDays[index]
                                                ? ColorPalette.calendarNumber
                                                : ColorPalette
                                                    .calendarNumberGrey,
                                          ),
                                        ),
                                        onPressed: () {
                                          selectDay(index);
                                          paintSelectedDays();
                                          setState(() {});
                                        },
                                      ));
                                });
                          } else {
                            return GridView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7),
                                itemCount: _days.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _days[index],
                                      style: GoogleFonts.barlow(
                                        fontSize: 16.0,
                                        wordSpacing: 1,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.bold,
                                        color: ColorPalette.calendarNumberGrey,
                                      ),
                                    ),
                                  );
                                });
                          }
                        })),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 24, 36, 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(219, 177, 42, 1),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    height: 42,
                    child: Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size.fromWidth(300)),
                        child: Text('Aceptar',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            )),
                        onPressed: () async {
                          Navigator.pop(context, _getRangeDate());
                        },
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  Widget getDayOfWeek(int index) {
    return Expanded(
        child: Text(
      daysOfWeek[index],
      style: GoogleFonts.barlow(
        fontSize: 14.0,
        wordSpacing: 1,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ));
  }
}

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/activityDay.dart';

import 'package:flutter/material.dart';

class ContainerTextEditTime extends StatefulWidget {
  const ContainerTextEditTime({
    Key? key,
    required this.onChanged,
    required this.day,
    required this.acti,
  }) : super(key: key);
  final String day;
  final ActivityDay acti;
  final ValueChanged<ActivityDay> onChanged;

  @override
  // ignore: library_private_types_in_public_api
  _ContainerTextEditTime createState() => _ContainerTextEditTime();
}

class _ContainerTextEditTime extends State<ContainerTextEditTime> {
  late String timeLblAM = "00:00 AM";
  List<ActivityDay> listTemp = [];
  ActivityDay activityAndInactivity = ActivityDay();

  String activityTemp = "";
  void _selectOption(String value) {
    print(value);
    activityAndInactivity.activity = value;
  }

  void _sendRestDay(ActivityDay rest) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    activityAndInactivity.day = widget.day;
    activityAndInactivity.timeStart = "00:00 AM";
    activityAndInactivity.timeFinish = "00:00 PM";
    // activityAndInactivity.activity = widget.acti.activity;
    activityTemp = widget.acti.activity;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  final _dateC = TextEditingController();
  final _timeC = TextEditingController();
  final _day = TextEditingController();
  final _timeCAM = TextEditingController();

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2050);

  ///Time
  TimeOfDay timeOfDay = const TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withAlpha(20),
      ),
      width: double.infinity,
      height: 100,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      widget.day,
                      style: const TextStyle(
                          color: ColorPalette.principal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    key: Key(activityTemp),
                    style: const TextStyle(
                        fontSize: 18, color: ColorPalette.principal),
                    autofocus: false,
                    onChanged: (text) {
                      activityAndInactivity.activity = text;
                      activityAndInactivity.timeStart = _timeCAM.text;
                      activityAndInactivity.timeFinish = _timeC.text;
                      widget.onChanged(activityAndInactivity);
                    },
                    onTap: () => {_selectOption(_day.text)},
                    controller: _day,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorPalette.principal),
                        // borderRadius: BorderRadius.circular(100.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: ColorPalette.principal), //<-- SEE HERE
                      ),
                      hintStyle: TextStyle(color: ColorPalette.principal),
                      filled: false,
                      labelStyle: TextStyle(color: ColorPalette.principal),
                    ),
                  ),
                ),
              ),
              Container(
                width: 70,
                color: Colors.transparent,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      key: const Key("timeWakeup"),
                      child: Text(
                        widget.acti.timeFinish == ""
                            ? "00:00 AM"
                            : widget.acti.timeFinish,
                        style: const TextStyle(
                            color: ColorPalette.principal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      onTap: () {
                        displayTimePickerPM(context);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                width: 70,
                color: Colors.transparent,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      child: Text(
                        widget.acti.timeStart == ""
                            ? "00:00 PM"
                            : widget.acti.timeStart,
                        style: const TextStyle(
                            color: ColorPalette.principal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      onTap: () {
                        displayTimePicker(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null) {
      setState(() {
        _dateC.text = date.toLocal().toString().split(" ")[0];
      });
    }
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });
    if (time != null) {
      _timeC.text = time.format(context);
      timeLblAM = _timeC.text;
      activityAndInactivity.day = widget.day;
      activityAndInactivity.activity = _day.text;
      activityAndInactivity.timeFinish = _timeC.text;

      widget.onChanged(activityAndInactivity);
    }
  }

  Future displayTimePickerPM(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });
    if (time != null) {
      _timeCAM.text = time.format(context);

      activityAndInactivity.day = widget.day;
      activityAndInactivity.activity = _day.text;
      activityAndInactivity.timeFinish = _timeCAM.text;
      widget.onChanged(activityAndInactivity);
    }
  }
}

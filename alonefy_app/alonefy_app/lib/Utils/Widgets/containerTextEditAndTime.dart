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
  late FocusNode myFocusNode;

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
    activityAndInactivity.timeWakeup = "00:00 AM";
    activityAndInactivity.timeSleep = "00:00 PM";
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
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
      width: double.infinity,
      height: 100,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      widget.day,
                      style: const TextStyle(
                          color: Colors.black,
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
                    autofocus: false,
                    onChanged: (text) {
                      activityAndInactivity.activity = text;
                      activityAndInactivity.timeSleep = _timeCAM.text;
                      activityAndInactivity.timeWakeup = _timeC.text;
                      widget.onChanged(activityAndInactivity);
                    },
                    onTap: () => {_selectOption(_day.text)},
                    controller: _day,
                    decoration: InputDecoration(
                        labelText: widget.acti.activity == ""
                            ? "Actividad"
                            : widget.acti.activity,
                        border: const OutlineInputBorder()),
                  ),
                ),
              ),
              Container(
                width: 70,
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      key: const Key("timeWakeup"),
                      child: Text(
                        widget.acti.timeWakeup == ""
                            ? "00:00 AM"
                            : widget.acti.timeWakeup,
                        style: const TextStyle(
                            color: Colors.black,
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
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      child: Text(
                        widget.acti.timeSleep == ""
                            ? "00:00 PM"
                            : widget.acti.timeSleep,
                        style: const TextStyle(
                            color: Colors.black,
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

      activityAndInactivity.activity = _day.text;
      activityAndInactivity.timeSleep = _timeC.text;

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

      activityAndInactivity.activity = _day.text;

      activityAndInactivity.timeWakeup = _timeCAM.text;
      widget.onChanged(activityAndInactivity);
    }
  }
}

import 'package:ifeelefine/Model/restday.dart';
import 'package:flutter/material.dart';

class ContainerSelectTime extends StatefulWidget {
  const ContainerSelectTime({
    Key? key,
    required this.day,
  }) : super(key: key);
  final String day;

  @override
  // ignore: library_private_types_in_public_api
  _ContainerSelectTime createState() => _ContainerSelectTime();
}

class _ContainerSelectTime extends State<ContainerSelectTime> {
  void _selectOption(String value) {
    setState(() {});
  }

  late String timeLblAM = "00:00 AM";
  List<RestDay> listTemp = [];

  @override
  void initState() {
    super.initState();
  }

  final _dateC = TextEditingController();
  final _timeC = TextEditingController();
  final _timeCAM = TextEditingController();

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);

  ///Time
  TimeOfDay timeOfDay = const TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 95,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
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
              ),
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: InkWell(
                        child: Text(
                          timeLblAM,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onTap: () => displayTimePicker(context),
                      ),
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
                    onTap: () => displayTimePickerPM(context),
                    controller: _timeCAM,
                    decoration: const InputDecoration(
                        filled: false,
                        labelText: 'PM',
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    onTap: () => displayTimePicker(context),
                    controller: _timeC,
                    decoration: const InputDecoration(
                        filled: false,
                        labelText: 'AM',
                        border: OutlineInputBorder()),
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
      if (time.hour > 11) {
        TimeOfDay timeOfDay = const TimeOfDay(hour: 0, minute: 0);
        _timeC.text = timeOfDay.format(context);
        timeLblAM = _timeC.text;
      } else {
        _timeC.text = time.format(context);
        timeLblAM = _timeC.text;
      }
      setState(() {});
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
      if (time.hour <= 11) {
        TimeOfDay timeOfDay = const TimeOfDay(hour: 12, minute: 00);
        _timeCAM.text = timeOfDay.format(context);
      } else {
        _timeCAM.text = time.format(context);
      }
      // "${time.hour}:${time.minute}";
      setState(() {});
    }
  }
}

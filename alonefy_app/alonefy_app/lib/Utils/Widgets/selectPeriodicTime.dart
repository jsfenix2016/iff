import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/main.dart';

class ScheduleNotificationWidget extends StatefulWidget {
  const ScheduleNotificationWidget({super.key});

  @override
  _ScheduleNotificationWidgetState createState() =>
      _ScheduleNotificationWidgetState();
}

class _ScheduleNotificationWidgetState
    extends State<ScheduleNotificationWidget> {
  // Initialize the flutter local notifications plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Variable to store the selected date and time
  late DateTime _selectedDateTime = now;

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       // Show the selected date and time
  //       Text(_selectedDateTime == null
  //           ? 'No date and time selected'
  //           : 'Selected date and time: ${_selectedDateTime.toString()}'),
  //       // Button to open the date and time picker

  //       ElevatedButton.icon(
  //         style: ButtonStyle(
  //             backgroundColor:
  //                 MaterialStateProperty.all<Color>(ColorPalette.principal)),
  //         label: const Text('Select date and time'),
  //         icon: const Icon(
  //           Icons.security,
  //         ),
  //         onPressed: _showDateTimePicker,
  //       ),
  //       // ElevatedButton.icon(
  //       //   style: ButtonStyle(
  //       //       backgroundColor:
  //       //           MaterialStateProperty.all<Color>(ColorPalette.principal)),
  //       //   label: const Text('Schedule notification'),
  //       //   icon: const Icon(
  //       //     Icons.security,
  //       //   ),
  //       //   onPressed: _scheduleNotification,
  //       // ),
  //       // Button to schedule the notification
  //     ],
  //   );
  // }

  // Function to show the date and time picker
  void _showDateTimePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _timeCAM.text = "${picked.day}/${picked.month}/${picked.year}";
        _selectedDateTime = picked;
      });
    }
  }

  // Function to schedule the notification
  void _scheduleNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Scheduled Notification',
        'This is a scheduled notification',
        _selectedDateTime,
        platformChannelSpecifics);
  }

  void _selectOption(String value) {
    setState(() {});
  }

  late String timeLblAM = "00:00 AM";

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
                        onTap: () => _showDateTimePicker,
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
                    onTap: () => _showDateTimePicker(),
                    controller: _timeCAM,
                    decoration: const InputDecoration(
                        labelText: 'Dia', border: OutlineInputBorder()),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    onTap: () => displayTimePicker(context),
                    controller: _timeC,
                    decoration: const InputDecoration(
                        labelText: 'Hora', border: OutlineInputBorder()),
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
      // if (time.hour > 11) {
      //   TimeOfDay timeOfDay = const TimeOfDay(hour: 0, minute: 0);
      //   _timeC.text = timeOfDay.format(context);
      //   timeLblAM = _timeC.text;
      // } else {

      // }
      _timeC.text = time.format(context);
      timeLblAM = _timeC.text;
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

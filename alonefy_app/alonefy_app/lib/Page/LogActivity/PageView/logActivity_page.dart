import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logActivity.dart';
import 'package:ifeelefine/Page/LogActivity/Controller/logActivity_controller.dart';

class LogActivityPage extends StatefulWidget {
  const LogActivityPage({super.key});

  @override
  State<LogActivityPage> createState() => _LogActivityPageState();
}

class _LogActivityPageState extends State<LogActivityPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final LogActivityController controller = Get.put(LogActivityController());

  List<LogActivity> _activities = [];
  List<String> datetimes = [];

  @override
  void initState() {
    super.initState();

    getActivities();
  }

  Future<void> getActivities() async {
    await Hive.close();
    _activities = await controller.getActivities();

    for (var activity in _activities) {
      convertDateTimeToString(activity);
    }
    setState(() {});
  }

  Future<void> convertDateTimeToString(LogActivity activity) async {
    var datetime = await dateTimeToString(activity.dateTime);
    datetimes.add(datetime);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    RedirectViewNotifier.setContext(context);
    return Scaffold(
        extendBodyBehindAppBar: false,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(
            "Actividad",
            style: textForTitleApp(),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 2,
              colors: [
                ColorPalette.secondView,
                ColorPalette.principalView,
              ],
            ),
          ),
          width: size.width,
          height: size.height,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _activities.length,
                  itemBuilder: (context, index) {
                    return getItem(index);
                  })),
        ));
  }

  Widget getItem(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _activities[index].movementType,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.barlow(
                      fontSize: 20.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    datetimes[index],
                    textAlign: TextAlign.right,
                    style: GoogleFonts.barlow(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: 2,
              decoration: const BoxDecoration(color: ColorPalette.principal),
            )
          ],
        ));
  }
}

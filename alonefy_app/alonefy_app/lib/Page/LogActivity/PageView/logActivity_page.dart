import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive/hive.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logActivity.dart';
import 'package:ifeelefine/Page/LogActivity/Controller/logActivity_controller.dart';
import 'package:intl/intl.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RedirectViewNotifier.setStoredContext(context);
    });
    super.initState();
    starTap();
    getActivities();
  }

  @override
  void didUpdateWidget(LogActivityPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> getActivities() async {
    await Hive.close();
    _activities = await controller.getActivities();
    _activities.sort((a, b) => b.dateTime.compareTo(a.dateTime));

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

    return GetBuilder<LogActivityController>(builder: (contextT) {
      return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: false,
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.brown,
          title: Text(
            "Actividad",
            style: textForTitleApp(),
          ),
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
            decoration: decorationCustom2(),
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 32, 8, 32),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  return getItem(index);
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget getItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 332,
        height: 70,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(11, 11, 10, 0.6),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ListTile(
          leading: IconButton(
            iconSize: 40,
            color: ColorPalette.principal,
            onPressed: () {},
            icon: Container(
              height: 32,
              width: 31.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Warning.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.transparent,
              ),
            ),
          ),
          title: Text(
            _activities[index].movementType,
            textAlign: TextAlign.left,
            style: textNormal16White(),
          ),
          subtitle: Text(
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(_activities[index].dateTime)
                .toString(),
            textAlign: TextAlign.left,
            style: textNormal16White(),
          ),
          trailing: IconButton(
            iconSize: 21,
            color: ColorPalette.principal,
            onPressed: () {},
            icon: Container(
              height: 21,
              width: 21,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Exclamation.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
    //   child: Column(
    //     children: [
    //       Row(
    //         children: [
    //           Expanded(
    //             child: Text(
    //               _activities[index].movementType,
    //               textAlign: TextAlign.left,
    //               style: GoogleFonts.barlow(
    //                 fontSize: 12.0,
    //                 wordSpacing: 1,
    //                 letterSpacing: 1,
    //                 fontWeight: FontWeight.normal,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //           Expanded(
    //             child: Text(
    //               datetimes[index],
    //               textAlign: TextAlign.right,
    //               style: GoogleFonts.barlow(
    //                 fontSize: 12.0,
    //                 wordSpacing: 1,
    //                 letterSpacing: 1,
    //                 fontWeight: FontWeight.normal,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Container(
    //         height: 2,
    //         decoration: const BoxDecoration(color: ColorPalette.principal),
    //       )
    //     ],
    //   ),
    // );
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logActivity.dart';
import 'package:ifeelefine/Page/LogActivity/Controller/logActivity_controller.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';

import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class LogActivityPage extends StatefulWidget {
  const LogActivityPage({super.key});

  @override
  State<LogActivityPage> createState() => _LogActivityPageState();
}

class _LogActivityPageState extends State<LogActivityPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final LogActivityController controller = Get.put(LogActivityController());

  late List<LogActivity> _activities;

  @override
  void initState() {
    super.initState();

    getActivities();
  }

  void getActivities() async {
    _activities = await controller.getActivities();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: false,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorPalette.backgroundAppBar,
          title: const Text("Actividad"),
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
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _activities.length,
                  itemBuilder: (context, index) {
                    return Container();
                  })),
        ));
  }

  Widget getItem(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        children: [
          Expanded(
            child: Text("movimiento"),
          ),
          Expanded(child: Text("Fecha"))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/main.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  PreferenceUser prefs = PreferenceUser();
  List<String> taskIdList = [];
  late Map<String, dynamic> arguments;
  @override
  void initState() {
    super.initState();
    initPrefs();
    starTap();

    taskIdList = prefs.getlistTaskIdsCancel;
    // print(rxlistTask);
  }

  void initPrefs() async {
    await prefs.initPrefs();
    prefs.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final preferences = arguments['type'] == 'INACTIVITY' ?
      prefs.getIdInactiveGroup : prefs.getIdDropGroup;

    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 80,
                  width: size.width,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'Hola ${user == null ? "NULL" : name.obs}\n¿Estas bien?',
                      textAlign: TextAlign.center,
                      style: textSemibold24White(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      mainController.saveUserLog(
                        arguments['type'] == 'INACTIVITY' ? 
                          "Inactividad - hubo actividad " : 
                          "Caida - hubo actividad ",
                          DateTime.now(),
                          preferences);

                      MainService().cancelAllNotifications(taskIdList);
                      mainController.refreshHome();
                      prefs.saveLastScreenRoute("home");

                      Get.offAll(const HomePage());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(219, 177, 42, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(219, 177, 42, 1),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                      height: 104,
                      width: 104,
                      child: Center(
                        child: Text(
                          "SÍ",
                          style: textBold48White(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 100,
                  width: size.width,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Constant.initNotifiContact,
                      textAlign: TextAlign.center,
                      style: textSemibold24White(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    mainController.saveUserLog(
                      arguments['type'] == 'INACTIVITY' ? 
                        "Inactividad - solicito ayuda " :
                        "Caida - solicito ayuda ",
                      DateTime.now(), preferences);
                    MainService().sendAlertToContactImmediately(taskIdList);
                    if (arguments['id'] != null ) {
                      await flutterLocalNotificationsPlugin.cancel(arguments['id']);
                    }
                    prefs.saveLastScreenRoute("home");
                    Get.offAll(const HomePage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(200)),
                    ),
                    height: 142.89,
                    width: 146,
                    child: Center(
                      child: SizedBox(
                        width: 118,
                        height: 80,
                        child: Center(
                          child: Text(
                            Constant.ineedHelp,
                            textAlign: TextAlign.center,
                            style: textBold26White(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:get/get.dart';

import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Page/HomePage/Controller/homeController.dart';
import 'package:ifeelefine/Page/HomePage/Widget/avatar_content.dart';
import 'package:ifeelefine/Page/HomePage/Widget/container_top_button.dart';
import 'package:ifeelefine/Page/HomePage/Widget/customNavbar.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/swipeableContainer.dart';
import 'package:ifeelefine/Page/Alerts/PageView/alerts_page.dart';

import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';

import 'package:ifeelefine/Views/menuconfig_page.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/main.dart';

import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:permission_handler/permission_handler.dart';

final _prefs = PreferenceUser();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());
  final HomeController homeVC = Get.put(HomeController());
  ListContactZoneController riskVC = ListContactZoneController();
  late String nameComplete;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? user;
  UserBD? userbd;

  List<LogAlertsBD> temp = [];
  late AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    starTap();
    getUserData();
    getAlerts();
    getpermission();

    _prefs.saveLastScreenRoute("home");

    NotificationCenter().subscribe('getAlerts', getAlerts);
    NotificationCenter().subscribe('getUserData', getUserData);
    Future.sync(() => RedirectViewNotifier.setStoredContext(context));
    RedirectViewNotifier.onTapRedirectCancelZone();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(
      () {
        _appLifecycleState = state;
        if (state.name.contains("paused")) {}
      },
    );

    switch (state) {
      case AppLifecycleState.resumed:
        // isOppenedApp = true;
        // FlutterBackgroundService().invoke("setAsForeground");
        Future.sync(() => RedirectViewNotifier.setStoredContext(context));

        break;
      case AppLifecycleState.inactive:
        // RedirectViewNotifier.setStoredContext(context);
        // isOppenedApp = true;
        break;
      case AppLifecycleState.paused:
        // RedirectViewNotifier.setStoredContext(context);
        // isOppenedApp = true;

        break;
      case AppLifecycleState.detached:

        // RedirectViewNotifier.setStoredContext(context);
        // isOppenedApp = false;
        break;
    }

    print(_appLifecycleState);
  }

  void redirectCancel() async {
    print(prefs.getIsSelectContactRisk);
    // if (prefs.getIsSelectContactRisk != -1) {
    //   var resp = await riskVC.getContactsZoneRisk();
    //   int indexSelect =
    //       resp.indexWhere((item) => item.id == prefs.getIsSelectContactRisk);
    //   var contactSelect = resp[indexSelect];

    //   Future.delayed(const Duration(seconds: 3), () async {
    //     await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => CancelAlertPage(
    //             contactRisk: contactSelect,
    //             taskdIds: prefs.getlistTaskIdsCancel),
    //       ),
    //     );
    //   });
    // }
  }

  Future getAlerts() async {
    temp = await homeVC.getAllMov();

    setState(() {});
  }

  Future getUserData() async {
    await _prefs.initPrefs();
    permissionStatusI = await validateConfig();
    user = await userVC.getUserDate();
    if (user != null) {
      user = user;
    }
    requestAlarmPermission();

    setState(() {});
  }

  Future<void> requestAlarmPermission() async {
    await Permission.scheduleExactAlarm.isDenied.then((value) {
      if (value) {
        Permission.scheduleExactAlarm.request();
      }
    });
  }

  Future<void> getpermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
    if (androidInfo.version.sdkInt >= 33) {}
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (user != null) {
      nameComplete = "${user!.name} ${user!.lastname}";
    } else {
      nameComplete = "Usuario";
    }
    return Scaffold(
      drawer: const MenuConfigurationPage(),
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: [
                    const SizedBox(
                      height: 36,
                    ),
                    const SizedBox(
                      height: 60.31,
                      width: 250,
                      child: WidgetLogoApp(),
                    ),
                    ContainerTopButton(
                      goToAlert: (bool value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlertsPage(),
                          ),
                        );
                      },
                      onOpenMenu: (bool value) {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      pref: _prefs,
                    ),
                  ],
                ),
                Positioned(
                  top: 143,
                  child: Container(
                    width: size.width,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "Bienvenido\n $nameComplete",
                        style: textBold20White(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 185,
                  left: (size.width / 3) - 30,
                  child: AvatarUserContent(
                    user: user,
                    selectPhoto: (value) async {
                      if (value != null) {
                        await homeVC.changeImage(value, user!);
                        Future.sync(() => showSaveAlert(context, Constant.info,
                            Constant.saveImageAvatar.tr));
                      }
                    },
                  ),
                ),
                SwipeableContainer(
                  temp: temp,
                ),
                const CustomNavbar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

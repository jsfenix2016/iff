import 'dart:async';

import 'package:get/get.dart';

import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Contact/Notice/Controller/contactNoticeController.dart';

import 'package:ifeelefine/Page/HomePage/Controller/homeController.dart';
import 'package:ifeelefine/Page/HomePage/Widget/avatar_content.dart';
import 'package:ifeelefine/Page/HomePage/Widget/container_top_button.dart';
import 'package:ifeelefine/Page/HomePage/Widget/customNavbar.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';

import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Page/Alerts/PageView/alerts_page.dart';

import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Views/help_page.dart';
import 'package:ifeelefine/Views/menu_controller.dart';

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
  ListContactZoneController riskVC = Get.put(ListContactZoneController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String nameComplete;
  User? user;
  UserBD? userbd;

  late AppLifecycleState _appLifecycleState;

  bool notCofingAll = false;

  @override
  void initState() {
    super.initState();
    validateConfig();
    WidgetsBinding.instance.addObserver(this);
    starTap();
    getUserData();

    homeVC.getpermission();

    _prefs.saveLastScreenRoute("home");

    NotificationCenter().subscribe('getUserData', getUserData);
    RedirectViewNotifier.setStoredContext(context);
    NotificationCenter().subscribe('refreshView', refreshView);

    NotificationCenter().notify('refreshMenu');
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
        _prefs.refreshData();
        _appLifecycleState = state;
        if (state.name.contains("paused")) {
          print(state.name);
          if (_prefs.getLastScreenRoute.toString() == "cancelDate") {
            Get.offAll(CancelDatePage(
              taskIds: prefs.getlistTaskIdsCancel,
            ));
          }
          if (_prefs.getLastScreenRoute.toString() == "help") {
            Get.offAll(const HelpPage());
          }
          if (_prefs.getUseMobilConfig && !_prefs.getOpenGalery) {
            Get.offAll(const HomePage());
          }
        }
      },
    );

    switch (state) {
      case AppLifecycleState.resumed:
        RedirectViewNotifier.setStoredContext(context);

        mainController.refreshContactNotify();
        mainController.refreshHome();
        Get.appUpdate();
        break;
      case AppLifecycleState.inactive:
        mainController.refreshHome();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }

    print(_appLifecycleState);
  }

  Future getUserData() async {
    await _prefs.initPrefs();
    permissionStatusI = await validateConfig();
    user = await userVC.getUserDate();
    if (user != null) {
      user = user;
    }
    requestAlarmPermission();
    if (mounted) {
      setState(() {});
    }
  }

  Future getAlerts() async {
    await homeVC.getAllMov();
  }

  void refreshView() {
    userVC.update();
    riskVC.update();
    validateConfig();

    homeVC.update();
    NotificationCenter().notify('refreshMenu');
  }

  Future<void> requestAlarmPermission() async {
    await Permission.scheduleExactAlarm.isDenied.then((value) {
      if (value) {
        Permission.scheduleExactAlarm.request();
      }
    });
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
      backgroundColor: Colors.black,
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
                Positioned(
                  top: 10,
                  child: Container(
                    color: Colors.transparent,
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        const SizedBox(
                          height: 40.31,
                          width: 150,
                          child: WidgetLogoApp(),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 150,
                          height: 80,
                          color: Colors.transparent,
                          child: GetBuilder<HomeController>(
                              builder: (contextTemp) {
                            notCofingAll = permissionStatusI
                                .any((element) => element.config);

                            return ContainerTopButton(
                              goToAlert: (bool value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AlertsPage(),
                                  ),
                                );
                                // Get.put(const AlertsPage());
                              },
                              onOpenMenu: (bool value) {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              pref: _prefs,
                              isconfig: notCofingAll,
                              getNotificationType: _prefs.getNotificationType,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 103,
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
                  top: 65,
                  child: AvatarUserContent(
                    user: user,
                    selectPhoto: (value) async {
                      if (value != null) {
                        await homeVC.changeImage(value, user!);

                        Future.sync(() => showSaveAlert(context, Constant.info,
                            Constant.saveImageAvatar.tr));
                        setState(() {});
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 145,
                  child: Container(
                    height: 60,
                    width: 345,
                    color: Colors.transparent,
                    child: Text(
                      Constant.textUninstall,
                      style: textNormal14White(),
                      textAlign: TextAlign.center,
                    ),
                  ),
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

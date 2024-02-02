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

import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Page/Alerts/PageView/alerts_page.dart';

import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
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
  ListContactZoneController riskVC = ListContactZoneController();
  late String nameComplete;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? user;
  UserBD? userbd;

  List<LogAlertsBD> temp = [];
  late AppLifecycleState _appLifecycleState;

  bool notCofingAll = false;

  @override
  void initState() {
    super.initState();
    validateConfig();
    WidgetsBinding.instance.addObserver(this);
    starTap();
    getUserData();
    getAlerts();
    homeVC.getpermission();

    _prefs.saveLastScreenRoute("home");

    NotificationCenter().subscribe('getAlerts', getAlerts);
    NotificationCenter().subscribe('getUserData', getUserData);
    Future.sync(() => RedirectViewNotifier.setStoredContext(context));
    // RedirectViewNotifier.onTapRedirectCancelZone();
    try {
      NotificationCenter().notify('refreshMenu');
    } catch (e) {
      print(e);
    }
    NotificationCenter().subscribe('refreshView', _refreshView);
  }

  void _refreshView() {
    userVC.update();
    riskVC.update();
    setState(() {});
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
        if (state.name.contains("paused")) {
          print(state.name);
          if (_prefs.getUseMobilConfig) {
            Get.offAll(HomePage());
          }
        }
      },
    );

    switch (state) {
      case AppLifecycleState.resumed:
        // isOppenedApp = true;
        // FlutterBackgroundService().invoke("setAsForeground");
        Future.sync(() => RedirectViewNotifier.setStoredContext(context));
//         RiskController? riskVC;
//         try {
//           riskVC = Get.find<RiskController>();
//         } catch (e) {
//           // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
//           // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
//           riskVC = Get.put(RiskController());
//         }

// // Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
//         if (riskVC != null) {
//           riskVC.update();
//           // NotificationCenter().notify('getContactRisk');
//         }

        ContactNoticeController? contactNotiVC;
        try {
          contactNotiVC = Get.find<ContactNoticeController>();
        } catch (e) {
          // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
          // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
          contactNotiVC = Get.put(ContactNoticeController());
        }

// Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
        if (contactNotiVC != null) {
          contactNotiVC.update();
          // NotificationCenter().notify('getContactRisk');
        }
        Get.appUpdate();
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

  Future getAlerts() async {
    temp = await homeVC.getAllMov();
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (user != null) {
      nameComplete = "${user!.name} ${user!.lastname}";
    } else {
      nameComplete = "Usuario";
    }
    permissionStatusI.forEach(
      (element) {
        if (element.config) {
          notCofingAll = true;
        }
      },
    );
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
                          child: ContainerTopButton(
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
                            isconfig: notCofingAll,
                          ),
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
                        NotificationCenter().notify('refreshView');
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
                      'Recuerde que si desea desinstalar la aplicación, antes deberá darse de baja del servicio en: Confguración/Datos personales/Darse de baja',
                      style: textNormal14White(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // SwipeableContainer(
                //   temp: temp,
                // ),
                const CustomNavbar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

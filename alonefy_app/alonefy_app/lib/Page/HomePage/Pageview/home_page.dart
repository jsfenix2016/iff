import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:get/get.dart';

import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Page/HomePage/Controller/homeController.dart';
import 'package:ifeelefine/Page/HomePage/Widget/customNavbar.dart';

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
import 'dart:io' show File;

import 'package:avatar_glow/avatar_glow.dart';

import 'package:image_picker/image_picker.dart';
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
  // late bool selectImage = false;
  late String nameComplete;
  // final _group = ValueNotifier<Map<String, List<UserPositionBD>>>({});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  var position = -20.0;

  var isOpen = false;
  User? user;
  UserBD? userbd;

  late Image imgNew;
  var foto;
  final _picker = ImagePicker();
  List<LogAlertsBD> temp = [];
  late AppLifecycleState _appLifecycleState;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    getUserData();
    getAlerts();
    getpermission();

    _prefs.saveLastScreenRoute("home");

    NotificationCenter().subscribe('getAlerts', getAlerts);
    NotificationCenter().subscribe('getUserData', getUserData);
    Future.sync(() => RedirectViewNotifier.setStoredContext(context));
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _appLifecycleState = state;
      if (state.name.contains("paused")) {}
    });

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
    // Future.sync(() => RedirectViewNotifier.setStoredContext(context));
    print(_appLifecycleState);
  }

  Future getAlerts() async {
    temp = await homeVC.getAllMov();

    setState(() {});
  }

  Future getUserData() async {
    await _prefs.initPrefs();
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

//capturar imagen de la galeria de fotos
  Future getImageGallery(ImageSource origen) async {
    final XFile? image = await _picker.pickImage(source: origen);
    File file;

    if (image != null) {
      file = File(image.path);
      setState(() {
        foto = file;
      });
    }

    if (foto != null) {
      await homeVC.changeImage(foto, user!);
      Future.sync(() =>
          showSaveAlert(context, Constant.info, Constant.saveImageAvatar.tr));
    }
  }

  Widget _mostrarFoto() {
    return GestureDetector(
      onTap: (() async {
        getImageGallery(ImageSource.gallery);
      }),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(
              Radius.circular(50.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: DecorationImage(
            image: (foto != null || user != null && user!.pathImage != "")
                ? (foto != null
                    ? FileImage(foto, scale: 0.5)
                    : getImage(user!.pathImage).image)
                : const AssetImage("assets/images/icons8.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
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
      body: Container(
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
                      height: 60.31, width: 250, child: WidgetLogoApp()),
                  Container(
                    height: 45,
                    color: Colors.transparent,
                    child: Stack(alignment: Alignment.center, children: [
                      Positioned(
                        top: 0,
                        left: 16,
                        child: IconButton(
                          iconSize: 40,
                          color: ColorPalette.principal,
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                          icon: Container(
                            height: 32,
                            width: 28,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/ajustes.png'),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 57,
                        top: 13,
                        child: Visibility(
                          visible: _prefs.getUserFree && !_prefs.getUserPremium,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                        20.0) //                 <--- border radius here
                                    ),
                                color: Colors.red),
                            height: 8,
                            width: 8,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 16,
                        child: IconButton(
                          iconSize: 40,
                          color: ColorPalette.principal,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AlertsPage(),
                              ),
                            );
                          },
                          icon: Container(
                            height: 32,
                            width: 28,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Vector.png'),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
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
                child: AvatarGlow(
                  glowColor: Colors.white,
                  endRadius: 90.0,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: Material(
                    elevation: 8.0,
                    shape: const CircleBorder(),
                    child: _mostrarFoto(),
                  ),
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
    );
  }
}

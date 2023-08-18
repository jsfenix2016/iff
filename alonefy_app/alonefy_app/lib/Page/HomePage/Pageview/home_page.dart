import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';

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
import 'package:ifeelefine/main.dart';
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
    getUserData();
    getAlerts();
    getpermission();
    _prefs.saveLastScreenRoute("home");
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    NotificationCenter().subscribe('getAlerts', getAlerts);
    NotificationCenter().subscribe('getUserData', getUserData);
  }

  Future serviceBackgroundPlay() async {
    if (_prefs.getAcceptedNotification == PreferencePermission.allow ||
        _prefs.getDetectedFall ||
        _prefs.getAcceptedSendLocation == PreferencePermission.allow) {
      _prefs.setProtected = "AlertFriends está activado";
      activateService();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _appLifecycleState = state;
      if (state.name.contains("paused")) {
        serviceBackgroundPlay();
      }
    });
    print(_appLifecycleState);
  }

  Future getAlerts() async {
    temp = await homeVC.getAllMov();

    setState(() {});
  }

  Future getUserData() async {
    user = await userVC.getUserDate();
    if (user != null) {
      user = user;
    }
    requestAlarmPermission();

    setState(() {});
  }

  Future<void> requestAlarmPermission() async {
    // if (await Permission.scheduleExactAlarm.request().isGranted) {
    //   // Permiso concedido, aquí puedes configurar la alarma
    //   // Llama al método showNotification() que configuraste previamente
    // } else {
    //   // Permiso denegado, puedes manejarlo según tus necesidades
    //   print('El permiso de alarma exacta fue denegado.');
    // }

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
    RedirectViewNotifier.setContext(context);
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
              const Positioned(
                  top: 36,
                  child: SizedBox(
                      height: 60.31, width: 250, child: WidgetLogoApp())),
              Positioned(
                top: 94,
                left: 16,
                child: IconButton(
                  iconSize: 40,
                  color: ColorPalette.principal,
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const MenuConfigurationPage()),
                    // );
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
                top: 105,
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
                top: 94,
                right: 16,
                child: IconButton(
                  iconSize: 40,
                  color: ColorPalette.principal,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlertsPage()),
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
              Positioned(
                top: 130,
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
                top: 180,
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

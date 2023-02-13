import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/HomePage/Controller/homeController.dart';
import 'package:ifeelefine/Page/RiskDate/Pageview/editRiskDatePage.dart';
import 'package:ifeelefine/Page/RiskDate/Pageview/riskDatePage.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/swipeableContainer.dart';
import 'package:ifeelefine/Views/alerts_page.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Views/menuconfig_page.dart';
import 'package:ifeelefine/Views/protectuser_page.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Directory, File, Platform;
import 'package:device_info_plus/device_info_plus.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// final _prefs = PreferenceUser();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());
  final HomeController homeVC = Get.put(HomeController());
  late bool selectImage = false;
  late String nameComplete;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  var position = -20.0;

  var isOpen = false;
  User? user;
  UserBD? userbd;

  late Image imgNew;
  var foto;
  final _picker = ImagePicker();

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future getUserData() async {
    // await _prefs.initPrefs();
    userbd = await userVC.getUserDate();
    if (userbd != null) {
      user = User(
          idUser: int.parse(userbd!.idUser),
          name: userbd!.name,
          lastname: userbd!.lastname,
          email: userbd!.email,
          telephone: userbd!.telephone,
          gender: userbd!.gender,
          maritalStatus: userbd!.maritalStatus,
          styleLife: userbd!.styleLife,
          pathImage: userbd!.pathImage,
          age: userbd!.age,
          country: userbd!.country,
          city: userbd!.city);

      print(user);
    }

    setState(() {});
  }

  void diveceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      // Android-specific code
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

    } else if (Platform.isIOS) {
      // iOS-specific code
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"

    }
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
      var req = await homeVC.changeImage(context, foto, user!);
      mostrarAlerta(context, "Se guardo la imagen correctamente".tr);
    } else {
      mostrarAlerta(context, "Hubo un error, intente mas tarde".tr);
    }
  }

  Widget _mostrarFoto() {
    if (foto != null || userbd != null && userbd!.pathImage != "") {
      return GestureDetector(
        onTap: () {
          getImageGallery(ImageSource.gallery);
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
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
              image: foto != null
                  ? FileImage(foto, scale: 0.5)
                  : getImage(userbd!.pathImage).image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          getImageGallery(ImageSource.gallery);
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.all(
                Radius.circular(50.0) //                 <--- border radius here
                ),
            border: Border.all(color: Colors.blueAccent),
            image: const DecorationImage(
              image: AssetImage("assets/images/icons8.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }
  }

  Future<DateTimeRange?> widgeDate(BuildContext context) async {
    DateTimeRange? newDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );

    return newDate;
  }

  Image getImage(String urlImage) {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return imgNew = Image.memory(bytesImages,
        fit: BoxFit.cover, width: double.infinity, height: 250.0);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (userbd != null) {
      nameComplete = userbd!.name + userbd!.lastname;
    } else {
      nameComplete = "Usuario";
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            // Call when you want the date time range picker to be shown

            Positioned(
              top: 44,
              right: 16,
              child: IconButton(
                iconSize: 40,
                color: ColorPalette.principal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlertsPage()),
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
              top: 75,
              child: Container(
                width: size.width,
                color: Colors.transparent,
                child: Text(
                  "Bienvenido $nameComplete",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Positioned(
            //   left: (size.width / 4),
            //   top: 55,
            //   child: const Text(
            //     "Proteccion personal",
            //     style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 20),
            //   ),
            // ),
            Positioned(
              top: 100,
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
            // _loginForm(context),

            const SwipeableContainer(),
            Positioned(
              bottom: -1,
              left: 0,
              child: SizedBox(
                width: size.width,
                height: 80,
                child: Stack(
                  children: [
                    // CustomPaint(
                    //   size: Size(size.width, 80),
                    //   painter: BNBCustomPainter(),
                    // ),
                    Container(
                      height: 85,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/VectorNavBar.png'),
                          fit: BoxFit.fill,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                    Center(
                      heightFactor: 1,
                      child: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        elevation: 0.1,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditRiskPage()),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/Group 880.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      20.0) //                 <--- border radius here
                                  ),
                              color: Colors.orange),
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                right: 7,
                                top: 5,
                                child: Visibility(
                                  visible: true,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                20.0) //                 <--- border radius here
                                            ),
                                        color: Colors.red),
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: currentIndex == 0
                                      ? Colors.orange
                                      : Colors.grey.shade400,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MenuConfigurationPage()),
                                  );
                                  setBottomBarIndex(0);
                                },
                                splashColor: Colors.white,
                              ),
                            ],
                          ),
                          IconButton(
                            iconSize: 40,
                            color: ColorPalette.principal,
                            onPressed: () {
                              setBottomBarIndex(2);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AlertsPage()),
                              );
                            },
                            icon: Container(
                              height: 39,
                              width: 35.7,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/actividad 1.png'),
                                  fit: BoxFit.fill,
                                ),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.add_alert,
                          //     color: currentIndex == 3
                          //         ? Colors.orange
                          //         : Colors.grey.shade400,
                          //   ),
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               const UserInactivityPage()),
                          //     );
                          //     setBottomBarIndex(3);
                          //   },
                          // ),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                            iconSize: 40,
                            color: ColorPalette.principal,
                            onPressed: () {
                              setBottomBarIndex(3);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RiskPage()),
                              );
                            },
                            icon: Container(
                              height: 39,
                              width: 35.7,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/cita-de-riesgo 1.png'),
                                  fit: BoxFit.fill,
                                ),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.add_alert,
                          //     color: currentIndex == 3
                          //         ? Colors.orange
                          //         : Colors.grey.shade400,
                          //   ),
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               const UserInactivityPage()),
                          //     );
                          //     setBottomBarIndex(4);
                          //   },
                          // ),

                          IconButton(
                            iconSize: 40,
                            color: ColorPalette.principal,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserInactivityPage()),
                              );
                              setBottomBarIndex(4);
                            },
                            icon: Container(
                              height: 39,
                              width: 35.7,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/zona-riesgo 1.png'),
                                  fit: BoxFit.fill,
                                ),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 0),
        radius: const Radius.circular(0.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 15, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

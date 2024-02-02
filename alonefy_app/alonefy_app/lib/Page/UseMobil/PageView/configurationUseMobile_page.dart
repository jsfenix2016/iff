import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/UseMobil/Controller/useMobileController.dart';
import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';

import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class UseMobilePage extends StatefulWidget {
  const UseMobilePage({super.key, required this.userbd});
  final UserBD userbd;
  @override
  State<UseMobilePage> createState() => _UseMobilePageState();
}

class _UseMobilePageState extends State<UseMobilePage> {
  final UseMobilController useMobilVC = Get.put(UseMobilController());
  final UserRestController userRestVC = Get.put(UserRestController());

  var indexSelect = 0;
  UserBD? userbd;

  final _prefs = PreferenceUser();

  @override
  void initState() {
    _prefs.initPrefs();
    if (widget.userbd.idUser == "-1") {
      _getUserData();
    } else {
      userbd = widget.userbd;
    }
    // _prefs.saveLastScreenRoute("useMobil");
    getpermission();
    super.initState();
  }

  Future<UserBD> _getUserData() async {
    userbd = await useMobilVC.getUserData();
    return userbd!;
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
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 36,
                  ),
                  const WidgetLogoApp(),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Column(children: [
                      Text(
                        'Durante el día,',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 24.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 55.0, right: 55, top: 8),
                        child: Text(
                          '¿Cada cuánto tiempo usas o coges el móvil?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 24.0,
                            wordSpacing: 1,
                            letterSpacing: 0.001,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette.principal,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Selección manual",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 20.0,
                      wordSpacing: 1,
                      letterSpacing: 0.001,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 140,
                    width: size.width,
                    child: GestureDetector(
                      child: AbsorbPointer(
                        absorbing: _prefs.getUserFree && !_prefs.getUserPremium,
                        child: CupertinoPicker(
                          selectionOverlay:
                              SelectionContainer.disabled(child: Container()),
                          scrollController:
                              FixedExtentScrollController(initialItem: 4),
                          backgroundColor: Colors.transparent,
                          onSelectedItemChanged: (int value) {
                            indexSelect = value;
                          },
                          itemExtent: 60.0,
                          children: [
                            for (var i = 0; i < Constant.timeDic.length; i++)
                              Container(
                                height: 24,
                                width: 150,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Text(
                                      Constant.timeDic[i.toString()].toString(),
                                      textAlign: TextAlign.center,
                                      style: textBold36White(),
                                    ),
                                    Container(
                                      height: 2,
                                      width: 152,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      onVerticalDragEnd: (drag) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PremiumPage(
                                  isFreeTrial: false,
                                  img: 'Pantalla5.jpg',
                                  title: Constant.premiumUseTimeTitle,
                                  subtitle: '')),
                        ).then(
                          (value) {
                            if (value != null && value) {
                              _prefs.setUserPremium = true;
                              _prefs.setUserFree = false;
                              var premiumController =
                                  Get.put(PremiumController());
                              premiumController.updatePremiumAPI(true);
                              List<String> addList = [
                                "config2",
                                "useMobil",
                              ];
                              _prefs.setlistConfigPage = addList;
                              setState(() {});
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(
                                0xFFCA9D0B), // El color #CA9D0B en formato ARGB (Alpha, Rojo, Verde, Azul)
                            Color(
                                0xFFDBB12A), // El color #DBB12A en formato ARGB (Alpha, Rojo, Verde, Azul)
                          ],
                          stops: [
                            0.1425,
                            0.9594
                          ], // Puedes ajustar estos valores para cambiar la ubicación de los colores en el gradiente
                          transform: GradientRotation(92.66 *
                              (3.14159265359 /
                                  180)), // Convierte el ángulo a radianes para Flutter
                        ),
                      ),
                      child: HorizontalSlidableButton(
                        isRestart: true,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                        height: 55,
                        width: 296,
                        buttonWidth: 60.0,
                        // color: ColorPalette.principal,
                        buttonColor: const Color.fromRGBO(157, 123, 13, 1),
                        dismissible: false,
                        label: Image.asset(
                          scale: 1,
                          fit: BoxFit.fill,
                          'assets/images/Group 969.png',
                          height: 13,
                          width: 21,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Center(
                                  child: Text(
                                    _prefs.getHabitsEnable
                                        ? Constant.habitsDisamble
                                        : Constant.habitsEnable,
                                    textAlign: TextAlign.center,
                                    style: textBold16Black(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onChanged: (position) async {
                          await Jiffy.locale('es');
                          var datetime = DateTime.now();
                          var strDatetime =
                              Jiffy(datetime).format(getDefaultPattern());

                          if (position == SlidableButtonPosition.end) {
                            if (_prefs.getUserFree && !_prefs.getUserPremium) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PremiumPage(
                                      isFreeTrial: false,
                                      img: 'Pantalla5.jpg',
                                      title: Constant.premiumUseTimeTitle,
                                      subtitle: ''),
                                ),
                              ).then(
                                (value) {
                                  if (value != null && value) {
                                    _prefs.setUserFree = false;
                                    _prefs.setUserPremium = true;
                                    _prefs.setHabitsEnable = true;
                                    _prefs.setHabitsRefresh = strDatetime;
                                    var premiumController =
                                        Get.put(PremiumController());
                                    premiumController.updatePremiumAPI(true);

                                    List<String>? temp = [];
                                    Future.sync(() async => {
                                          temp = await _prefs.getlistConfigPage,
                                          temp!.add("useMobil"),
                                          _prefs.setlistConfigPage = temp!
                                        });
                                    setState(() {});
                                  }
                                },
                              );
                            } else {
                              _prefs.getHabitsEnable
                                  ? _prefs.setHabitsEnable = false
                                  : _prefs.setHabitsEnable = true;
                              setState(() {});
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: ElevateButtonFilling(
                        showIcon: false,
                        onChanged: (value) async {
                          if (_prefs.getUserFree && !_prefs.getUserPremium) {
                            indexSelect = 1;
                          }
                          var result = await useMobilVC.saveTimeUseMobil(
                              context,
                              Constant.timeDic[indexSelect.toString()]
                                  .toString(),
                              userbd!);

                          if (result) {
                            // Get.off(() => const UserRestPage());

                            var listrest = await userRestVC.getUserRest();
                            if (listrest.isNotEmpty) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreviewRestTimePage(
                                    isMenu: false,
                                  ),
                                ),
                              );
                            } else {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserRestPage(),
                                ),
                              );
                            }
                          }
                        },
                        mensaje: 'Continuar',
                        img: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

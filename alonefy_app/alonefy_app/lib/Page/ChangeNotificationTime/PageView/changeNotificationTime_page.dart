import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/main.dart';

import '../../../Common/Constant.dart';

import '../../../Data/hive_data.dart';
import '../../../Provider/prefencesUser.dart';
import '../../Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class ChangeNotificationTimePage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const ChangeNotificationTimePage({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<ChangeNotificationTimePage> createState() =>
      _ChangeNotificationTimePageState();
}

class _ChangeNotificationTimePageState
    extends State<ChangeNotificationTimePage> {
  final _prefs = PreferenceUser();

  int emailPosition = 0;
  int whatsappPosition = 0;
  int phonePosition = 0;

  String emailTime = "";
  String smsTime = "";
  String phoneTime = "";

  @override
  void initState() {
    super.initState();
    starTap();
    setState(() {
      Constant.timeDic.forEach((key, value) {
        if (_prefs.getEmailTime == value) {
          emailPosition = int.parse(key);
          emailTime = value;
        }
        if (_prefs.getSMSTime == value) {
          smsTime = value;
          whatsappPosition = int.parse(key);
        }
        if (_prefs.getPhoneTime == value) {
          phoneTime = value;
          phonePosition = int.parse(key);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          Constant.titleNavBar,
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              //const SizedBox(height: 32),
              Positioned(
                top: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: Text('Cambiar tiempo notificación',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 22.0,
                        wordSpacing: 1,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 68, 0, 70),
                child: SingleChildScrollView(
                  child: Column(children: [
                    getRow(
                        'Al detectar alerta', "assets/images/Warning.png", 24),
                    const SizedBox(height: 5),
                    getLine("assets/images/line_small.png"),
                    const SizedBox(height: 5),
                    getRow("Enviarme notificación pasados",
                        "assets/images/Email.png", 28),
                    getRowWithPicker(
                        "assets/images/line_xlarge.png", emailPosition, 0),
                    getRow("Enviar SMS a mis contactos pasados",
                        "assets/images/Whatsapp.png", 24),
                    getRowWithPicker(
                        "assets/images/line_xlarge.png", whatsappPosition, 1),
                    getRow("Enviar llamada a mis contactos pasados",
                        "assets/images/Phone.png", 24),
                    getRowWithPicker(
                        "assets/images/line_xlarge.png", phonePosition, 2)
                  ]),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 32,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(219, 177, 42, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 138,
                  height: 42,
                  child: Center(
                    child: TextButton(
                      child: Text('Guardar',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      onPressed: () async {
                        saveNotificationTime();
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        color: const Color.fromRGBO(219, 177, 42, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 138,
                  height: 42,
                  child: Center(
                    child: TextButton(
                      child: Text('Cancelar',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRow(String title, String iconPath, double paddingLeft) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(paddingLeft, 0, 0, 0),
          child: Transform.scale(
            scale: 1,
            child: Image(
              image: AssetImage(iconPath),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Text(title,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.barlow(
                    fontSize: 16.0,
                    wordSpacing: 1,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget getLine(String imagePath) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(39, 0, 0, 0),
        child: Transform.scale(
          scale: 1,
          child: Image(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget getPicker(int initialPosition, int pickerId) {
    return Expanded(
      child: SizedBox(
        height: 120,
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: const CupertinoThemeData(
            brightness: Brightness.light,
          ),
          home: Stack(
            children: [
              if (_prefs.getUserPremium) ...[
                _getCupertinoPicker(initialPosition, pickerId)
              ] else ...[
                GestureDetector(
                  child: AbsorbPointer(
                      absorbing: !_prefs.getUserPremium,
                      child: _getCupertinoPicker(initialPosition, pickerId)),
                  onVerticalDragEnd: (drag) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PremiumPage(
                              isFreeTrial: false,
                              img: 'Pantalla5.jpg',
                              title:
                                  'Protege tu Seguridad Personal las 24h:\n\n',
                              subtitle: Constant.premiumChangeTimeTitle)),
                    ).then(
                      (value) {
                        if (value != null && value) {
                          _prefs.setUserPremium = true;
                          _prefs.setUserFree = false;
                          var premiumController = Get.put(PremiumController());
                          premiumController.updatePremiumAPI(true);
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCupertinoPicker(int initialPosition, int pickerId) {
    return CupertinoPicker(
      backgroundColor: Colors.transparent,
      onSelectedItemChanged: (int value) {
        switch (pickerId) {
          case 0:
            emailTime = Constant.timeDic[value.toString()]!;
            break;
          case 1:
            smsTime = Constant.timeDic[value.toString()]!;
            break;
          case 2:
            phoneTime = Constant.timeDic[value.toString()]!;
            break;
        }
      },
      scrollController:
          FixedExtentScrollController(initialItem: initialPosition),
      itemExtent: 60.0,
      children: [
        for (var i = 0; i < Constant.timeDic.length; i++)
          Container(
            height: 24,
            width: 120,
            color: Colors.transparent,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  Constant.timeDic[i.toString()].toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 24.0,
                    wordSpacing: 1,
                    letterSpacing: 0.001,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: 2,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget getRowWithPicker(String linePath, int initialPosition, int pickerId) {
    return Row(
      children: [getLine(linePath), getPicker(initialPosition, pickerId)],
    );
  }

  void saveNotificationTime() {
    _prefs.setEmailTime = emailTime;
    _prefs.setSMSTime = smsTime;
    _prefs.setPhoneTime = phoneTime;

    updateContacts();

    showSaveAlert(context, "Tiempo de notificaciones guardado",
        "El tiempo de las notificaciones se ha guardado correctamente.");
  }

  void updateContacts() async {
    var listContact = await const HiveData().listUserContactbd;

    var contactController = Get.put(ContactUserController());
    contactController.updateContacts(
        listContact, emailTime, phoneTime, smsTime);
  }
}

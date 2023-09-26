import 'package:get/get.dart';

import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:ifeelefine/Controllers/mainController.dart';

import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';

import 'package:ifeelefine/Page/Risk/ZoneRisk/EditZoneRisk/PageView/EditZoneRisk.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/PushAlert/PageView/pushAlert.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';

import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Views/space_heidht_custom.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class ZoneRiskPage extends StatefulWidget {
  const ZoneRiskPage({super.key});
  @override
  State<ZoneRiskPage> createState() => _ZoneRiskPageState();
}

class _ZoneRiskPageState extends State<ZoneRiskPage> {
  ListContactZoneController riskVC = ListContactZoneController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<ContactZoneRiskBD> listContact = [];
  late ContactZoneRiskBD contactTemp;
  var indexSelect = -1;
  @override
  void initState() {
    NotificationCenter().subscribe('getContactZoneRisk', refreshListZoneRisk);

    super.initState();
    starTap();
    redirectCancel();
  }

  Future refreshListZoneRisk() async {
    setState(() {});
  }

  void redirectCancel() async {
    print(prefs.getIsSelectContactRisk);
    if (prefs.getIsSelectContactRisk != -1) {
      var resp = await riskVC.getContactsZoneRisk();
      int indexSelect =
          resp.indexWhere((item) => item.id == prefs.getIsSelectContactRisk);
      var contactSelect = resp[indexSelect];

      // Future.delayed(const Duration(seconds: 3), () async {
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => CancelAlertPage(
      //           contactRisk: contactSelect,
      //           taskdIds: prefs.getlistTaskIdsCancel),
      //     ),
      //   );
      // });
    }
  }

  Future<List<ContactZoneRiskBD>> getListZoneRisk() async {
    var resp = await riskVC.getContactsZoneRisk();

    return resp;
  }

  void initContact() {
    contactTemp = ContactZoneRiskBD(
        id: -1,
        photo: null,
        name: '',
        phones: '',
        sendLocation: false,
        sendWhatsapp: false,
        code: '',
        isActived: false,
        sendWhatsappContact: false,
        callme: false,
        save: false,
        createDate: DateTime.now());
  }

  Widget _mostrarFoto(ContactZoneRiskBD contact) {
    var img = contact.photo;
    if (indexSelect != -1 &&
        listContact.isNotEmpty &&
        listContact[indexSelect].photo != null) {
      img = listContact[indexSelect].photo;
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 79,
        height: 79,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
              Radius.circular(79.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: DecorationImage(
            image: (indexSelect != -1 &&
                        listContact.isNotEmpty &&
                        listContact[indexSelect].photo != null ||
                    img != null)
                ? Image.memory(img!,
                        fit: BoxFit.cover, width: 100, height: 100.0)
                    .image
                : const AssetImage("assets/images/icons8.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget listviewContactRisk() {
    return FutureBuilder<List<ContactZoneRiskBD>>(
      future: getListZoneRisk(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listContact = snapshot.data!;

          return Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 0.0, bottom: 50),
              shrinkWrap: true,
              itemCount: listContact.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < listContact.length) {
                  return GestureDetector(
                    onTap: () {
                      print(index);
                      contactTemp = listContact[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditZoneRiskPage(
                            contactRisk: listContact[index],
                            index: listContact.length,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(169, 146, 125, 0.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                100.0), //                 <--- border radius here
                          ),
                        ),
                        height: 79,
                        width: 180,
                        child: Stack(
                          children: [
                            _mostrarFoto(listContact[index]),
                            Positioned(
                              left: 75,
                              child: Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100),
                                      topRight: Radius.circular(100),
                                    ),
                                  ),
                                  height: 79,
                                  width: 230,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        height: 79,
                                        width: 180,
                                        child: Center(
                                          child: (listContact.isNotEmpty &&
                                                  listContact[index]
                                                      .name
                                                      .isNotEmpty)
                                              ? Text(
                                                  listContact[index].name,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.barlow(
                                                    fontSize: 18.0,
                                                    wordSpacing: 1,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(
                                                  "Selecciona un contacto",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.barlow(
                                                    fontSize: 18.0,
                                                    wordSpacing: 1,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Container(
                                        height: 70,
                                        width: 50,
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              height: 30,
                                              width: 30,
                                              child: IconButton(
                                                iconSize: 20,
                                                onPressed: (() {
                                                  riskVC.deleteContactRisk(
                                                      context,
                                                      listContact[index]);
                                                }),
                                                icon: Container(
                                                  width: 16,
                                                  height: 16,
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/trash.png'),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              height: 30,
                                              width: 30,
                                              child: IconButton(
                                                iconSize: 20,
                                                onPressed: (() {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditZoneRiskPage(
                                                        contactRisk:
                                                            listContact[index],
                                                        index:
                                                            listContact.length,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                                icon: Container(
                                                  width: 16,
                                                  height: 16,
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/pencil.png'),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Column(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     Container(
                                      //       decoration: const BoxDecoration(
                                      //         color: Colors.transparent,
                                      //         borderRadius: BorderRadius.only(
                                      //           bottomRight: Radius.circular(100),
                                      //           topRight: Radius.circular(100),
                                      //         ),
                                      //       ),
                                      //       height: 30,
                                      //       width: 30,
                                      //       child: IconButton(
                                      //         iconSize: 20,
                                      //         onPressed: (() {
                                      //           riskVC.deleteContactRisk(
                                      //               context, listContact[index]);
                                      //         }),
                                      //         icon: const Icon(
                                      //           Icons.delete,
                                      //           color: ColorPalette.principal,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       decoration: const BoxDecoration(
                                      //         color: Colors.transparent,
                                      //         borderRadius: BorderRadius.only(
                                      //           bottomRight: Radius.circular(100),
                                      //           topRight: Radius.circular(100),
                                      //         ),
                                      //       ),
                                      //       height: 30,
                                      //       width: 30,
                                      //       child: IconButton(
                                      //         iconSize: 20,
                                      //         onPressed: (() {
                                      //           Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   EditZoneRiskPage(
                                      //                 contactRisk:
                                      //                     listContact[index],
                                      //                 index: listContact.length,
                                      //               ),
                                      //             ),
                                      //           );
                                      //         }),
                                      //         icon: const Icon(
                                      //           Icons.edit,
                                      //           color: ColorPalette.principal,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
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
                return const CircularProgressIndicator();
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void redirectCancelDate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PushAlertPage(
          contactZone: contactTemp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Zona de riesgo",
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          child: Stack(
            children: [
              SafeArea(
                child: Container(
                  height: 20.0,
                ),
              ),
              SizedBox(
                height: size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SpaceHeightCustom(heightTemp: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32),
                      child: Text(
                        "Utilizar una configuración guardada o crear una nueva",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 20.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(222, 222, 222, 1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    listviewContactRisk()
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: (size.width / 2) - 100,
                child: ElevateButtonFilling(
                  showIcon: true,
                  onChanged: (value) async {
                    initContact();
                    MainController mainController = Get.put(MainController());
                    var user = await mainController.getUserData();

                    if (user.idUser == "-1") {
                      Route route = MaterialPageRoute(
                        builder: (context) =>
                            const UserConfigPage(isMenu: false),
                      );
                      Future.sync(
                          () => Navigator.pushReplacement(context, route));
                      return;
                    }
                    Future.sync(
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditZoneRiskPage(
                            contactRisk: contactTemp,
                            index: listContact.length,
                          ),
                        ),
                      ),
                    );
                  },
                  mensaje: "Crear nueva",
                  img: 'assets/images/User.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

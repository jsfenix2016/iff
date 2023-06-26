import 'dart:ffi';

import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/editRiskDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/rowContact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Views/space_heidht_custom.dart';
import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class RiskPage extends StatefulWidget {
  const RiskPage({super.key});
  @override
  State<RiskPage> createState() => _RiskPageState();
}

class _RiskPageState extends State<RiskPage> {
  RiskController riskVC = RiskController();

  List<ContactRiskBD> listContact = [];
  late ContactRiskBD contactTemp;

  @override
  void initState() {
    NotificationCenter().subscribe('getContactRisk', refreshView);
    initContact();
    super.initState();
  }

  void refreshView() {
    setState(() {});
  }

  Future<List<ContactRiskBD>> refreshListDateContact() async {
    final tempList = await riskVC.getContactsRisk();

    listContact = await riskVC.getContactsRisk();
    return tempList;
  }

  void initContact() {
    contactTemp = ContactRiskBD(
        id: -1,
        photo: null,
        name: '',
        timeinit: '00:00',
        timefinish: '00:00',
        phones: '',
        titleMessage: '',
        messages: '',
        sendLocation: false,
        sendWhatsapp: false,
        isInitTime: false,
        isFinishTime: false,
        code: '',
        isActived: false,
        isprogrammed: false,
        photoDate: [],
        saveContact: false,
        createDate: DateTime.now(),
        taskIds: []);
  }

  void deleteContactRisk(BuildContext context, ContactRiskBD contact) async {
    final index = listContact.indexOf(contact);
    if (index >= 0 && index < listContact.length) {
      // Resto del código para eliminar el contacto de la lista
      await riskVC.deleteContactRisk(context, contact);
      setState(() {});
    }
  }

  Widget listviewContactRisk() {
    return FutureBuilder<List<ContactRiskBD>>(
      future: refreshListDateContact(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listContact = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemExtent: 250.0,
              padding: const EdgeInsets.only(top: 0.0, bottom: 50),
              shrinkWrap: true,
              itemCount: listContact.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < listContact.length) {
                  return RowContact(
                    contactRisk: listContact[index],
                    index: index,
                    onChanged: ((value) {
                      contactTemp = listContact[index];
                      if (contactTemp.isActived || contactTemp.isprogrammed) {
                        redirectCancelDate();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRiskPage(
                              contactRisk: contactTemp,
                              index: index,
                            ),
                          ),
                        );
                      }
                    }),
                    onChangedDelete: (bool value) {
                      contactTemp = listContact[index];
                      if (contactTemp.isActived || contactTemp.isprogrammed) {
                        redirectCancelDate();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Información"),
                              content: const Text(
                                  "Si continua eliminara la configuracion de la notificación"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Cerrar"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: const Text(Constant.continueTxt),
                                  onPressed: () => {
                                    deleteContactRisk(context, contactTemp),
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    onCancel: (bool value) {
                      contactTemp = listContact[index];
                      redirectCancelDate();
                    },
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
        builder: (context) => CancelDatePage(
          contactRisk: contactTemp, taskIds: []
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Cita de riesgo"),
      ),
      body: Container(
        decoration: decorationCustom(),
        child: Stack(
          children: [
            const SafeArea(
              child: SpaceHeightCustom(heightTemp: 20),
            ),
            SizedBox(
              height: size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SpaceHeightCustom(heightTemp: 20),
                  Text(
                    "Utilizar una configuración guardada o crear una nueva.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 24.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  const SpaceHeightCustom(heightTemp: 20),
                  const SpaceHeightCustom(heightTemp: 20),
                  listviewContactRisk()
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                height: 50,
                width: size.width,
                color: Colors.transparent,
                child: ElevateButtonFilling(
                  onChanged: (value) {
                    initContact();
                    final _prefs = PreferenceUser();
                    if (!_prefs.isConfig) {
                      Route route = MaterialPageRoute(
                        builder: (context) => const UserConfigPage(),
                      );
                      Navigator.pushReplacement(context, route);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditRiskPage(
                                contactRisk: contactTemp,
                                index: listContact.length,
                              )),
                    );
                  },
                  mensaje: "Crear nuevo",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

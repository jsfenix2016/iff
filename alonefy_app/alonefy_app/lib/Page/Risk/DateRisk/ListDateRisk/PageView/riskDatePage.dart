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
import 'package:notification_center/notification_center.dart';

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
    NotificationCenter().subscribe('getContactRisk', refreshListDateContact);
    initContact();
    super.initState();
  }

  Future<List<ContactRiskBD>> refreshListDateContact() async {
    final list = await riskVC.getContactsRisk();

    return list;
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
        isprogrammed: false);
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
                return RowContact(
                  index: index,
                  onChanged: ((value) {
                    contactTemp = listContact[index];
                    if (listContact[index].isActived ||
                        listContact[index].isprogrammed) {
                      redirectCancelDate();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRiskPage(
                            contactRisk: listContact[index],
                            index: index,
                          ),
                        ),
                      );
                    }
                  }),
                  contactRisk: listContact[index],
                  onChangedDelete: (bool value) {
                    contactTemp = listContact[index];
                    if (listContact[index].isActived ||
                        listContact[index].isprogrammed) {
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
                                  riskVC.deleteContactRisk(
                                      context, listContact[index]),
                                  setState(() {})
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
          contactRisk: contactTemp,
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
        title: const Center(child: Text("Cita de riesgo")),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 1,
            colors: [
              ColorPalette.secondView,
              ColorPalette.principalView,
            ],
          ),
        ),
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
                  const SizedBox(
                    height: 20,
                  ),
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
                onChanged: (value) {
                  initContact();
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
          ],
        ),
      ),
    );
  }
}

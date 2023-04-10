import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import 'package:ifeelefine/Page/Risk/ZoneRisk/EditZoneRisk/PageView/EditZoneRisk.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/PushAlert/PageView/pushAlert.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:notification_center/notification_center.dart';

class ZoneRiskPage extends StatefulWidget {
  const ZoneRiskPage({super.key});
  @override
  State<ZoneRiskPage> createState() => _ZoneRiskPageState();
}

class _ZoneRiskPageState extends State<ZoneRiskPage> {
  ListContactZoneController riskVC = ListContactZoneController();

  List<ContactZoneRiskBD> listContact = [];
  late ContactZoneRiskBD contactTemp;
  var indexSelect = -1;
  @override
  void initState() {
    NotificationCenter().subscribe('getContactZoneRisk', getListZoneRisk);

    super.initState();
  }

  Future<List<ContactZoneRiskBD>> getListZoneRisk() async {
    return riskVC.getContactsZoneRisk();
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
        save: false);
  }

  Widget _mostrarFoto() {
    var img = listContact[indexSelect].photo;
    if (indexSelect != -1 &&
        listContact.isNotEmpty &&
        listContact[indexSelect].photo != null) {
      print("object");
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
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemExtent: 200.0,
              padding: const EdgeInsets.only(top: 0.0, bottom: 50),
              shrinkWrap: true,
              itemCount: listContact.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(169, 146, 125, 0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                          100.0), //                 <--- border radius here
                    ),
                  ),
                  height: 79,
                  width: 280,
                  child: Stack(
                    children: [
                      _mostrarFoto(),
                      Positioned(
                        right: 0,
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
                            width: 200,
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  height: 79,
                                  width: 150,
                                  child: Center(
                                    child: (indexSelect != -1 &&
                                            listContact.isNotEmpty &&
                                            listContact[indexSelect]
                                                .name
                                                .isNotEmpty)
                                        ? Text(
                                            listContact[indexSelect].name,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.barlow(
                                              fontSize: 18.0,
                                              wordSpacing: 1,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.normal,
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
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100),
                                      topRight: Radius.circular(100),
                                    ),
                                  ),
                                  height: 79,
                                  width: 50,
                                  child: IconButton(
                                    iconSize: 40,
                                    color: ColorPalette.principal,
                                    onPressed: () {},
                                    icon: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/plussWhite.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
        builder: (context) => PushAlertPage(
          contactZone: contactTemp,
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
        title: const Center(child: Text("Zona de riesgo")),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
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
                      builder: (context) => EditZoneRiskPage(
                        contactRisk: contactTemp,
                        index: listContact.length,
                      ),
                    ),
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

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Widget/list_contact_risk.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/editRiskDatePage.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
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
  RiskController riskVC = Get.put(RiskController());

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

  void initContact() {
    contactTemp = initContactRisk();
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
                    style: textNormal24White(),
                  ),
                  const SpaceHeightCustom(heightTemp: 20),
                  const ListContactRisk()
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
                    final prefs = PreferenceUser();
                    if (!prefs.isConfig) {
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
                                index: riskVC.contactList.obs.value.length,
                              )),
                    );
                  },
                  mensaje: Constant.newDate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

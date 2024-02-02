import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Widget/list_contact_risk.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/editRiskDatePage.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Views/space_heidht_custom.dart';
import 'package:ifeelefine/main.dart';
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
  bool _shouldReloadData = false;
  @override
  void initState() {
    initContact();
    Future.sync(() => RedirectViewNotifier.setStoredContext(context));
    super.initState();
    NotificationCenter().subscribe('getContactRisk', refreshView);
    starTap();
  }

  void refreshView(int id) {
    riskVC.update();
  }

  void initContact() {
    contactTemp = initContactRisk();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Si _shouldReloadData es verdadero, realiza la lógica de recarga aquí.
    if (prefs.getCancelIdDate != -1) {
      // Lógica para recargar datos
      print('Recargando datos...');

      // Puedes llamar a funciones o realizar cualquier acción necesaria.
      // Por ejemplo, si estás utilizando un FutureBuilder, puedes reiniciar el Future.
    }
    var list = await const HiveDataRisk().getcontactRiskbd;

    int indexSelect = list.indexWhere((item) =>
        item.isActived == true &&
        parseContactRiskDate(item.timefinish).isBefore(DateTime.now()));
    print(list);
    if (indexSelect != -1) {
      var temp = list[indexSelect];
      print(temp.isFinishTime);
      var c = await const HiveDataRisk().getContactRiskBD(temp.id);
      c!.isFinishTime = true;
      c.isprogrammed = false;
      c!.isActived = false;
      var ct = await const HiveDataRisk().updateContactRisk(c);
      var listte = await const HiveDataRisk().getcontactRiskbd;
      riskVC.getContactsRisk();
    }
    int indexActive = list.indexWhere((item) =>
        item.isprogrammed == true &&
        parseContactRiskDate(item.timeinit).isBefore(DateTime.now()));

    if (indexActive != -1) {
      var temp = list[indexActive];
      print(temp.isFinishTime);
      var c = await const HiveDataRisk().getContactRiskBD(temp.id);
      c!.isFinishTime = false;
      c!.isActived = true;
      c.isprogrammed = false;
      var ct = await const HiveDataRisk().updateContactRisk(c);
      var listte = await const HiveDataRisk().getcontactRiskbd;
      riskVC.getContactsRisk();
    }
    // Importante: Reinicia la variable _shouldReloadData después de la recarga.
    _shouldReloadData = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Future.sync(() => RedirectViewNotifier.setStoredContext(context));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Cita de riesgo",
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          child: Stack(
            children: [
              const SafeArea(
                child: SpaceHeightCustom(heightTemp: 20),
              ),
              SizedBox(
                height: size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          color: const Color.fromRGBO(222, 222, 222, 1),
                        ),
                      ),
                    ),
                    const SpaceHeightCustom(heightTemp: 20),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: size.width,
                        color: Colors.transparent,
                        child: const ListContactRisk(),
                      ),
                    )
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
                    showIcon: true,
                    onChanged: (value) async {
                      initContact();

                      MainController mainController = Get.put(MainController());
                      var user = await mainController.getUserData();

                      if (user.idUser == "-1") {
                        Route route = MaterialPageRoute(
                          builder: (context) =>
                              const UserConfigPage(isMenu: true),
                        );
                        Future.sync(
                            () => Navigator.pushReplacement(context, route));
                        return;
                      }
                      Get.off(
                        EditRiskPage(
                          contactRisk: contactTemp,
                          index: riskVC.contactList.obs.value.length,
                        ),
                      );
                      // Future.sync(() => Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => EditRiskPage(
                      //           contactRisk: contactTemp,
                      //           index: riskVC.contactList.obs.value.length,
                      //         ),
                      //       ),
                      //     ));
                    },
                    mensaje: Constant.newDate,
                    img: 'assets/images/plussWhite.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

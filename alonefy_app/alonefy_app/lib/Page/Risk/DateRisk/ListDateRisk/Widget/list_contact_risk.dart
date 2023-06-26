import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/editRiskDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/rowContact.dart';

class ListContactRisk extends StatefulWidget {
  const ListContactRisk({super.key});

  @override
  State<ListContactRisk> createState() => _ListContactRiskState();
}

class _ListContactRiskState extends State<ListContactRisk> {
  RiskController riskVC = Get.find<RiskController>();

  late ContactRiskBD contactTemp;

  Future<RxList<ContactRiskBD>> refreshListDateContact() async {
    return await riskVC.getContactsRisk();
  }

  void initContact() {
    contactTemp = initContactRisk();
  }

  void deleteContactRisk(BuildContext context, ContactRiskBD contact) async {
    var delete = await riskVC.deleteContactRisk(context, contact);
    if (delete) {
      Navigator.of(context).pop();
      setState(() {});
    }
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
    return GetBuilder<RiskController>(builder: (context) {
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
                    var temp = listContact[index];
                    return RowContact(
                      contactRisk: temp,
                      index: index,
                      onChanged: ((value) {
                        contactTemp = temp;
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
                        contactTemp = temp;
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                        contactTemp = temp;
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
    });
  }
}

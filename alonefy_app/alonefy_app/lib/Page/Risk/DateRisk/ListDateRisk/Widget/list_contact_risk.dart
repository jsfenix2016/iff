import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/editRiskDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/rowContact.dart';
import 'package:notification_center/notification_center.dart';

// ValueNotifier<List<ContactRiskBD>> contactNotifiers =
//     ValueNotifier<List<ContactRiskBD>>([]);

class ListContactRisk extends StatefulWidget {
  const ListContactRisk({super.key});

  @override
  State<ListContactRisk> createState() => _ListContactRiskState();
}

class _ListContactRiskState extends State<ListContactRisk> {
  RiskController riskVC = Get.put(RiskController());

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
      setState(() {
        Navigator.of(context).pop();
      });
    }
  }

  void redirectCancelDate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CancelDatePage(
          taskIds: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiskController>(builder: (context) {
      return FutureBuilder<RxList<ContactRiskBD>>(
        future: refreshListDateContact(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final listContact = snapshot.data!;
            if (listContact.isEmpty) {
              return const SizedBox.shrink();
            }
            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemExtent: 250.0,
              padding: const EdgeInsets.only(top: 0.0, bottom: 70),
              shrinkWrap: true,
              itemCount: listContact.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < listContact.length) {
                  var temp = listContact[index];
                  return InkWell(
                    onTap: () {
                      print(index);
                      contactTemp = temp;
                      prefs.setSelectContactRisk = contactTemp.id;
                      if (temp.isActived ||
                          temp.isprogrammed ||
                          temp.isFinishTime) {
                        redirectCancelDate();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRiskPage(
                              contactRisk: temp,
                              index: index,
                            ),
                          ),
                        );
                      }
                    },
                    child: RowContact(
                      contactRisk: temp,
                      index: index,
                      onChanged: ((value) {
                        contactTemp = temp;
                        if (contactTemp.isActived ||
                            contactTemp.isprogrammed ||
                            temp.isFinishTime) {
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
                        if (contactTemp.isActived ||
                            contactTemp.isprogrammed ||
                            temp.isFinishTime) {
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
                        if (contactTemp.isFinishTime == false) {
                          prefs.setListDate = true;
                        }

                        redirectCancelDate();
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    });
  }
}

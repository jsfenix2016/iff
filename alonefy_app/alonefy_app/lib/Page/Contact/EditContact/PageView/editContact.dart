import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/EditContact/Controller/edit_controller.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/selectTimerCallSendSMS.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';
import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class EditContact extends StatefulWidget {
  const EditContact({super.key, required this.contact});

  final ContactBD contact;
  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final EditContactController contactVC = Get.put(EditContactController());

  var indexSelect = -1;

  bool isPremium = true;
  late String timeSMS = "10 min";
  late String timeCall = "20 min";
  bool isAutorice = false;
  @override
  void initState() {
    // userVC.g

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Editar Contacto"),
      ),
      body: Container(
        decoration: decorationCustom(),
        child: Column(
          children: [
            const SafeArea(
              child: SizedBox(
                height: 20,
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 400,
              width: double.infinity,
              margin: const EdgeInsets.all(2),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 3.0,
                          offset: Offset(0.0, 5.0),
                          spreadRadius: 3.0),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(169, 146, 125, 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                        ),
                        height: 89,
                        width: 280,
                        child: Stack(
                          children: [
                            WidgetContact(
                                displayName: widget.contact.displayName,
                                img: widget.contact.photo,
                                delete: false,
                                onDelete: (bool) {}),
                          ],
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        height: 290,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            SelectTimerCallSendSMS(
                              onChanged: (TimerCallSendSmsModel value) {
                                timeSMS = value.sendSMS;
                                timeCall = value.call;
                              },
                              sendSm: widget.contact.timeSendSMS,
                              timeCall: widget.contact.timeCall,
                            ),
                            Container(
                              height: 20,
                            ),
                            ElevateButtonCustomBorder(
                              onChanged: (value) async {
                                ContactBD contactBD = ContactBD(
                                    "", null, "", "", "", "", "", "Pendiente");

                                contactBD.displayName =
                                    widget.contact.displayName;
                                contactBD.name = widget.contact.displayName;
                                contactBD.phones = widget.contact.phones;
                                contactBD.photo = widget.contact.photo;
                                contactBD.timeSendSMS = timeSMS;
                                contactBD.timeCall = timeCall;
                                contactBD.timeWhatsapp =
                                    widget.contact.timeWhatsapp;
                                bool save = await contactVC.saveContact(
                                    context, contactBD);
                                if (save) {
                                  isAutorice = true;
                                  Future.sync(() =>
                                      contactVC.authoritationContact(context));
                                  NotificationCenter().notify('getContact');
                                }
                              },
                              mensaje: "Solicitar autorización",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevateButtonCustomBorder(
              onChanged: (value) async {
                if (value) {
                  if (!isAutorice) {
                    showSaveAlert(context, Constant.info,
                        "Antes de continuar debe solicitar la autorización del contacto");
                    return;
                  }
                  showSaveAlert(
                      context, Constant.info, Constant.contactSaveCorrectly);

                  NotificationCenter().notify('getContact');
                }
              },
              mensaje: Constant.saveBtn,
            ),
          ],
        ),
      ),
    );
  }
}

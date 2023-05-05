import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Common/Constant.dart';
import '../../../Common/colorsPalette.dart';
import '../../../Controllers/contactUserController.dart';
import '../../../Data/hive_data.dart';
import '../../../Provider/prefencesUser.dart';
import '../../../Utils/Widgets/elevatedButtonFilling.dart';
import '../../Premium/PageView/premium_page.dart';

final _prefs = PreferenceUser();

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final ContactUserController controller = Get.put(ContactUserController());

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                Center(
                  child: Column(
                    children: [
                      SafeArea(
                        child: Container(
                          height: 100.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Selecciona los contactos a quien deseas que ",
                                style: GoogleFonts.barlow(
                                    fontSize: 24.0,
                                    wordSpacing: 1,
                                    letterSpacing: 0.001,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.5
                                ),
                              ),
                              TextSpan(
                                text: "I'm fine ",
                                style: GoogleFonts.barlow(
                                    fontSize: 24.0,
                                    wordSpacing: 1,
                                    letterSpacing: 0.001,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    height: 1.5
                                ),
                              ),
                              TextSpan(
                                text: "avise en una situación de emergencia.",
                                style: GoogleFonts.barlow(
                                    fontSize: 24.0,
                                    wordSpacing: 1,
                                    letterSpacing: 0.001,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.5
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 72,
                      ),
                      Center(
                        child: ElevateButtonFilling(
                            onChanged: ((value) async {
                              var listContact = await const HiveData().listUserContactbd;
                              if (!_prefs.getUserPremium && listContact.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PremiumPage(
                                      img: 'Mask group-4',
                                      title: Constant.premiumContactsTitle,
                                      subtitle: '')
                                  ),
                                );
                              } else {

                              }
                            }),
                            mensaje: 'Añadir contacto'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
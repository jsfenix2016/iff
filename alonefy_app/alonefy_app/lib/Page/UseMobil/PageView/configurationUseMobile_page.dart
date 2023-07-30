import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/UseMobil/Controller/useMobileController.dart';

import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:jiffy/jiffy.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class UseMobilePage extends StatefulWidget {
  const UseMobilePage({super.key, required this.userbd});
  final UserBD userbd;
  @override
  State<UseMobilePage> createState() => _UseMobilePageState();
}

class _UseMobilePageState extends State<UseMobilePage> {
  final UseMobilController useMobilVC = Get.put(UseMobilController());
  var indexSelect = 0;
  UserBD? userbd;

  final _prefs = PreferenceUser();

  @override
  void initState() {
    if (widget.userbd.idUser == "-1") {
      _getUserData();
    } else {
      userbd = widget.userbd;
    }
    _prefs.saveLastScreenRoute("useMobil");

    super.initState();
  }

  Future<UserBD> _getUserData() async {
    userbd = await useMobilVC.getUserData();
    return userbd!;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Center(
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Text(
                'Durante el día,',
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 24.0,
                  wordSpacing: 1,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '¿cada cuánto tiempo usas o coges el móvil?',
                textAlign: TextAlign.center,
                style: textBold24PrincipalColor(),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Selección manual",
                textAlign: TextAlign.center,
                style: textBold20White(),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                width: size.width,
                child: GestureDetector(
                  child: AbsorbPointer(
                    absorbing: _prefs.getUserFree && !_prefs.getUserPremium,
                    child: CupertinoPicker(
                      scrollController:
                          FixedExtentScrollController(initialItem: 1),
                      backgroundColor: Colors.transparent,
                      onSelectedItemChanged: (int value) {
                        indexSelect = value;
                      },
                      itemExtent: 60.0,
                      children: [
                        for (var i = 0; i <= Constant.timeDic.length; i++)
                          Container(
                            height: 24,
                            width: 150,
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Text(
                                  Constant.timeDic[i.toString()].toString(),
                                  textAlign: TextAlign.center,
                                  style: textBold36White(),
                                ),
                                Container(
                                  height: 2,
                                  width: 100,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  onVerticalDragEnd: (drag) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PremiumPage(
                              isFreeTrial: false,
                              img: 'Pantalla5.jpg',
                              title: Constant.premiumChangeTimeTitle,
                              subtitle: '')),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: HorizontalSlidableButton(
                  isRestart: true,
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  height: 55,
                  width: 296,
                  buttonWidth: 60.0,
                  color: ColorPalette.principal,
                  buttonColor: const Color.fromRGBO(157, 123, 13, 1),
                  dismissible: false,
                  label: Image.asset(
                    scale: 1,
                    fit: BoxFit.fill,
                    'assets/images/Group 969.png',
                    height: 13,
                    width: 21,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Center(
                            child: Text(
                              'Aprender de mis hábitos',
                              textAlign: TextAlign.center,
                              style: textBold16Black(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (position) async {
                    await Jiffy.locale('es');
                    var datetime = DateTime.now();
                    var strDatetime =
                        Jiffy(datetime).format(getDefaultPattern());

                    setState(() async {
                      if (position == SlidableButtonPosition.end) {
                        if (_prefs.getUserFree && !_prefs.getUserPremium) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PremiumPage(
                                  isFreeTrial: false,
                                  img: 'pantalla3.png',
                                  title: Constant.premiumFallTitle,
                                  subtitle: ''),
                            ),
                          ).then((value) {
                            if (value != null && value) {
                              _prefs.setUserFree = false;
                              _prefs.setUserPremium = true;
                              _prefs.setHabitsEnable = true;
                              _prefs.setHabitsRefresh = strDatetime;
                            }
                          });
                        }

                        // result = 'Button is on the right';
                        // makePayment();
                        //GooglePayButton(
                        //  paymentConfigurationAsset:
                        //      'json/default_payment_profile_google_pay.json',
                        //  paymentItems: items,
                        //  type: GooglePayButtonType.pay,
                        //  margin: const EdgeInsets.only(top: 15.0),
                        //  onPaymentResult: onGooglePayResult,
                        //  loadingIndicator: const Center(
                        //    child: CircularProgressIndicator(),
                        //  ),
                        //);
                      } else {
                        // result = 'Button is on the left';
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: ElevateButtonFilling(
                    onChanged: (value) async {
                      var result = await useMobilVC.saveTimeUseMobil(
                          context,
                          Constant.timeDic[indexSelect.toString()].toString(),
                          userbd!);

                      if (result) {
                        Get.off(() => const UserRestPage());
                      }
                    },
                    mensaje: 'Continuar',
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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/UseMobil/Controller/useMobileController.dart';

import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:pay/pay.dart';

// import 'package:flutter_pay/flutter_pay.dart';

class UserMobilePage extends StatefulWidget {
  const UserMobilePage({super.key});

  @override
  State<UserMobilePage> createState() => _UserMobilePageState();
}

class _UserMobilePageState extends State<UserMobilePage> {
  final UseMobilController useMobilVC = Get.put(UseMobilController());
  var indexSelect = -1;
  // FlutterPay flutterPay = FlutterPay();

  String result = "Result will be shown here";
  List<PaymentItem> items = [
    const PaymentItem(
      label: 'Total',
      amount: '1.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
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
                style: GoogleFonts.barlow(
                  fontSize: 24.0,
                  wordSpacing: 1,
                  letterSpacing: 1.2,
                  height: 1.39,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.principal,
                ),
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
                style: GoogleFonts.barlow(
                  fontSize: 20.0,
                  wordSpacing: 1,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                width: size.width,
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  onSelectedItemChanged: (int value) {
                    useMobilVC.saveTimeUseMobil(
                        context, Constant.timeDic[value.toString()].toString());
                  },
                  itemExtent: 60.0,
                  children: [
                    for (var i = 0; i <= Constant.timeDic.length; i++)
                      Container(
                        height: 24,
                        width: 120,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Text(
                              Constant.timeDic[i.toString()].toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 36.0,
                                wordSpacing: 1,
                                letterSpacing: 0.001,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
                              style: GoogleFonts.barlow(
                                fontSize: 16.0,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (position) {
                    setState(() {
                      if (position == SlidableButtonPosition.end) {
                        // result = 'Button is on the right';
                        // makePayment();
                        GooglePayButton(
                          paymentConfigurationAsset:
                              'json/default_payment_profile_google_pay.json',
                          paymentItems: items,
                          type: GooglePayButtonType.pay,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: onGooglePayResult,
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
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
                    onChanged: (value) {
                      var a = useMobilVC.getTimeUseMobil();
                      print(a);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserRestPage()),
                      );
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

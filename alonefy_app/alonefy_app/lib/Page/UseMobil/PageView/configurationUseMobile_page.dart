import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/UseMobil/Controller/useMobileController.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Utils/Widgets/customDropDown.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
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
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 90,
              ),
              Text(
                'Durante el día, ¿cada cuánto tiempo usas o coges el móvil?',
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 24.0,
                  wordSpacing: 1,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              HorizontalSlidableButton(
                isRestart: true,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                height: 42,
                width: 296,
                buttonWidth: 60.0,
                color: ColorPalette.principal,
                buttonColor: ColorPalette.secondView,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(''),
                      Center(
                        child: Expanded(
                          child: Text(
                            'Aprender de mis hábitos',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                height: 20,
              ),
              Container(
                color: Colors.transparent,
                height: 200,
                width: 290,
                child: Stack(
                  children: [
                    SizedBox(
                      child: Expanded(
                        child: ListView(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8.0, top: 0),
                              itemCount: Constant.timeDic.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        indexSelect = index;

                                        setState(() {
                                          useMobilVC.saveTimeUseMobil(
                                              context,
                                              Constant.timeDic[index.toString()]
                                                  .toString());
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Container(
                                          key: const Key(""),
                                          width: 250,
                                          height: 80,
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 260,
                                                height: 45,
                                                color: indexSelect == index
                                                    ? Colors.amber.withAlpha(20)
                                                    : Colors.transparent,
                                                child: Center(
                                                  child: Text(
                                                    Constant.timeDic[
                                                            index.toString()]
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.barlow(
                                                      fontSize: 40.0,
                                                      wordSpacing: 1,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                color: Colors.white,
                                                height: 1,
                                                width: 250,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: ElevateButtonCustomBorder(
                    onChanged: (value) {
                      useMobilVC.getTimeUseMobil();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserInactivityPage()),
                      );
                    },
                    mensaje: 'Listo',
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

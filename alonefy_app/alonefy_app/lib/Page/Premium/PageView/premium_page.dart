import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/ImageGradient.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../../Common/Constant.dart';
import '../../../Common/colorsPalette.dart';
import '../../../Common/utils.dart';
import '../../../Model/UserComment.dart';
import '../../Onboarding/Widget/widgetColumnOnboarding.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage(
      {super.key,
      required this.isFreeTrial,
      required this.img,
      required this.title,
      required this.subtitle});

  final bool isFreeTrial;
  final String img;
  final String title;
  final String subtitle;

  @override
  State<StatefulWidget> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  var premiumController = Get.put(PremiumController());
  final _prefs = PreferenceUser();

  List<UserComment> comments = [
    UserComment("Gonzalo, 34 años", 4.5, "Me gusta mucho la aplicación"),
    UserComment("Rodrigo, 54 años", 4, "Es sencilla de usar"),
    UserComment("Marta, 57 años", 5, "Me encanta. Me siento muy protegida"),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: const Alignment(0, 1),
                  colors: <Color>[
                    Colors.black,
                    Colors.black.withAlpha(450),
                    Colors.transparent,
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                //child: SizedBox(
                //  child: Image.asset(
                //    fit: BoxFit.fitWidth,
                //    'assets/images/${widget.img}',
                //    height: 360,
                //  ),
                //),
                child: getPremiumImageGradient(widget.img)),
            Positioned(
              top: 24,
              left: 32,
              right: 32,
              child: Center(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 22.0,
                    wordSpacing: 1,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.principal,
                  ),
                ),
              ),
            ),
            Positioned(
                top: 330,
                left: 0,
                right: 0,
                child: Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          width: 180,
                          height: 127,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: ColorPalette.backgroundDarkGrey2),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                                child: Text(
                                  'Seguridad ilimitada',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.barlow(
                                    fontSize: 22.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                child: Text(
                                  _prefs.getPremiumPrice,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.barlow(
                                    fontSize: 24.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
            //getListOfComments(),
            Positioned(
                bottom: 100, left: 32, right: 32, child: getListOfComments()),
            Positioned(
                bottom: 32, left: 32, right: 32, child: getHorizontalSlide())
          ],
        ),
      ),
    );
  }

  Widget getListOfComments() {
    return Container(
        height: 90,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return getItemOfComment(index);
            }));
  }

  Widget getItemOfComment(int index) {
    return Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Container(
          width: 300,
          height: 90,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              color: ColorPalette.secondView),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            comments[index].name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 15.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: RatingBar.builder(
                                initialRating: comments[index].rating,
                                minRating: 1,
                                itemSize: 20,
                                ignoreGestures: true,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              )))
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      comments[index].description,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 15.0,
                        wordSpacing: 1,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget getHorizontalSlide() {
    return HorizontalSlidableButton(
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
      onChanged: (SlidableButtonPosition value) async {
        if (value == SlidableButtonPosition.end) {
          if (widget.isFreeTrial) {
            premiumController.requestPurchaseByProductId(
                PremiumController.subscriptionFreeTrialId,
                responseSubscription());
          } else {
            premiumController.requestPurchaseByProductId(
                PremiumController.subscriptionId, responseSubscription());
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Center(
                child: Text(
                  "Obtener Premium",
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
    );
  }

  Function responseSubscription() {
    return (bool response) => {
          if (response) {Navigator.pop(context, response)}
        };
  }
}

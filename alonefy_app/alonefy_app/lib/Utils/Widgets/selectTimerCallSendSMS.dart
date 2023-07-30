import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

class TimerCallSendSmsModel {
  late String call;
  late String sendSMS;

  TimerCallSendSmsModel(this.sendSMS, this.call);
}

class SelectTimerCallSendSMS extends StatefulWidget {
  final String sendSm;
  final String timeCall;
  const SelectTimerCallSendSMS(
      {super.key,
      required this.onChanged,
      required this.sendSm,
      required this.timeCall});

  final ValueChanged<TimerCallSendSmsModel> onChanged;
  @override
  State<SelectTimerCallSendSMS> createState() => _SelectTimerCallSendSMSState();
}

class _SelectTimerCallSendSMSState extends State<SelectTimerCallSendSMS> {
  late TimerCallSendSmsModel timer = TimerCallSendSmsModel("", "");
  final PreferenceUser prefs = PreferenceUser();
  var initialSMSValue = 1;
  var initialCallValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    timer = TimerCallSendSmsModel(widget.sendSm, widget.timeCall);

    for (var i = 0; i <= Constant.timeDic.length; i++) {
      if (Constant.timeDic[i.toString()] == widget.sendSm) {
        initialSMSValue = i;
      }
      if (Constant.timeDic[i.toString()] == widget.timeCall) {
        initialCallValue = i;
      }
    }

    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                'Enviar whatsapp transcurridos:',
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 14.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 90,
              child: GestureDetector(
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
                child: AbsorbPointer(
                  absorbing: prefs.getUserFree && !prefs.getUserPremium,
                  child: CupertinoPicker(
                    backgroundColor: Colors.transparent,
                    onSelectedItemChanged: (int value) {
                      var sendSMS =
                          Constant.timeDic[value.toString()].toString();
                      timer.sendSMS = sendSMS;
                      widget.onChanged(timer);
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: initialSMSValue),
                    itemExtent: 70.0,
                    children: [
                      for (var i = 0; i <= Constant.timeDic.length; i++)
                        SizedBox(
                          height: 64,
                          width: 175,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ),
          ],
        ),
        Container(
          height: 30,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                'Llamar por teléfono transcuridos:',
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 14.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: AbsorbPointer(
                absorbing: prefs.getUserFree && !prefs.getUserPremium,
                child: SizedBox(
                  width: 200,
                  height: 90,
                  child: CupertinoPicker(
                    backgroundColor: Colors.transparent,
                    onSelectedItemChanged: (int value) async {
                      var call = Constant.timeDic[value.toString()].toString();
                      timer.call = call;
                      widget.onChanged(timer);
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: initialCallValue),
                    itemExtent: 70.0,
                    children: [
                      for (var i = 0; i <= Constant.timeDic.length; i++)
                        SizedBox(
                          height: 64,
                          width: 175,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
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
            )
          ],
        ),
      ],
    );
  }
}

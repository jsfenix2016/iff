import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    timer = TimerCallSendSmsModel(widget.sendSm, widget.timeCall);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
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
              child: CupertinoPicker(
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (int value) {
                  var sendSMS = Constant.timeDic[value.toString()].toString();
                  timer.sendSMS = sendSMS;
                  widget.onChanged(timer);
                },
                itemExtent: 56.0,
                children: [
                  for (var i = 0; i <= Constant.timeDic.length; i++)
                    Container(
                      height: 64,
                      width: 125,
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
          ],
        ),
        Container(
          height: 30,
        ),
        Row(
          children: [
            Container(
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
            SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 90,
              child: CupertinoPicker(
                backgroundColor: Colors.transparent,
                onSelectedItemChanged: (int value) {
                  var call = Constant.timeDic[value.toString()].toString();
                  timer.call = call;
                  widget.onChanged(timer);
                },
                scrollController: FixedExtentScrollController(initialItem: 1),
                itemExtent: 56.0,
                children: [
                  for (var i = 0; i <= Constant.timeDic.length; i++)
                    Container(
                      height: 64,
                      width: 125,
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
          ],
        ),
      ],
    );
  }
}

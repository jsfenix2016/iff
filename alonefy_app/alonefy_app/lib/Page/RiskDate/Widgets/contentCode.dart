import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/activityDay.dart';

import 'package:flutter/material.dart';

class CodeModel {
  String? textCode1;
  String? textCode2;
  String? textCode3;
  String? textCode4;
}

class ContentCode extends StatefulWidget {
  const ContentCode({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<CodeModel> onChanged;
  @override
  // ignore: library_private_types_in_public_api
  State createState() => _ContentCodeState();
}

class _ContentCodeState extends State<ContentCode> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              color: Colors.transparent,
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                  LengthLimitingTextInputFormatter(1),
                ],
                keyboardType: TextInputType.number,
                // maxLength: 1,
                onChanged: (valor) {},
                autofocus: false,
                key: const Key("lastName"),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.white), //<-- SEE HERE
                  ),
                  hintStyle: TextStyle(color: Colors.yellow),
                  filled: true,
                  labelStyle: TextStyle(color: Colors.yellow),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.yellow),
                onSaved: (value) => {},
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 50,
              width: 50,
              color: Colors.transparent,
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                  LengthLimitingTextInputFormatter(1),
                ],
                keyboardType: TextInputType.number,
                // maxLength: 1,
                onChanged: (valor) {},
                autofocus: false,
                key: const Key("lastName"),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.white), //<-- SEE HERE
                  ),
                  hintStyle: TextStyle(color: Colors.yellow),
                  filled: true,
                  labelStyle: TextStyle(color: Colors.yellow),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.yellow),
                onSaved: (value) => {},
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 50,
              width: 50,
              color: Colors.transparent,
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                  LengthLimitingTextInputFormatter(1),
                ],
                keyboardType: TextInputType.number,
                // maxLength: 1,
                onChanged: (valor) {},
                autofocus: false,
                key: const Key("lastName"),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.white), //<-- SEE HERE
                  ),
                  hintStyle: TextStyle(color: Colors.yellow),
                  filled: true,
                  labelStyle: TextStyle(color: Colors.yellow),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.yellow),
                onSaved: (value) => {},
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 50,
              width: 50,
              color: Colors.transparent,
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                  LengthLimitingTextInputFormatter(1),
                ],
                keyboardType: TextInputType.number,
                // maxLength: 1,
                onChanged: (valor) {},
                autofocus: false,
                key: const Key("lastName"),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.white), //<-- SEE HERE
                  ),
                  hintStyle: TextStyle(color: Colors.yellow),
                  filled: true,
                  labelStyle: TextStyle(color: Colors.yellow),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.yellow),
                onSaved: (value) => {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    required this.code,
  }) : super(key: key);
  final CodeModel code;
  final ValueChanged<CodeModel> onChanged;
  @override
  // ignore: library_private_types_in_public_api
  State createState() => _ContentCodeState();
}

class _ContentCodeState extends State<ContentCode> {
  var code = CodeModel();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Widget textFildContainer(
      String key, String code, ValueChanged<String> onChanged) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.transparent,
      child: TextFormField(
        initialValue: code,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'\d+')),
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
        // maxLength: 1,
        onChanged: (valor) {
          onChanged((valor));
        },
        autofocus: false,
        key: Key(key),
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Colors.white), //<-- SEE HERE
          ),
          hintStyle: TextStyle(color: ColorPalette.principal),
          filled: true,
          labelStyle: TextStyle(color: ColorPalette.principal),
        ),
        style: const TextStyle(fontSize: 18, color: ColorPalette.principal),
        onSaved: (value) => {},
      ),
    );
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
            textFildContainer("1",
                widget.code.textCode1 == null ? "" : widget.code.textCode1!,
                ((value) {
              code.textCode1 = value.toString();
              widget.onChanged(code);
            })),
            const SizedBox(
              width: 10,
            ),
            textFildContainer("2",
                widget.code.textCode2 == null ? "" : widget.code.textCode2!,
                ((value) {
              code.textCode2 = value.toString();
              widget.onChanged(code);
            })),
            const SizedBox(
              width: 10,
            ),
            textFildContainer("3",
                widget.code.textCode3 == null ? "" : widget.code.textCode3!,
                ((value) {
              code.textCode3 = value.toString();
              widget.onChanged(code);
            })),
            const SizedBox(
              width: 10,
            ),
            textFildContainer("4",
                widget.code.textCode4 == null ? "" : widget.code.textCode4!,
                ((value) {
              code.textCode4 = value.toString();
              widget.onChanged(code);
            })),
          ],
        ),
      ),
    );
  }
}

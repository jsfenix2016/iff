import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

class TextValidateToken extends StatefulWidget {
  const TextValidateToken(
      {super.key,
      required this.type,
      required this.code,
      required this.message,
      required this.onChanged,
      required this.isValid});
  final String type;
  final String code;
  final String message;
  final bool isValid;
  final ValueChanged<String> onChanged;
  @override
  State<TextValidateToken> createState() => _TextValidateTokenState();
}

class _TextValidateTokenState extends State<TextValidateToken> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              width: 163,
              height: 60,
              child: Center(
                child: Text(
                  widget.message,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.barlow(
                    fontSize: 14.0,
                    wordSpacing: 1,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              color: Colors.transparent,
              height: 40,
              width: 156,
              child: TextFormField(
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                initialValue: widget.code,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  filled: false,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorPalette.principal),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: ColorPalette.principal), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  hintStyle: textNomral18White(),
                  hintText: widget.code,
                  labelText: "",
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onSaved: (value) => value,
                validator: (value) {
                  return Constant.codeEmailPlaceholder;
                },
                style: textNormal14White(),
                onChanged: (value) async {
                  widget.onChanged(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

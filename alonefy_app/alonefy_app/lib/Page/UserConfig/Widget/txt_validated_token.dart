import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

class TextValidateToken extends StatefulWidget {
  const TextValidateToken(
      {super.key,
      required this.type,
      required this.code,
      required this.message,
      required this.onChanged});
  final String type;
  final String code;
  final String message;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              height: 50,
              child: Text(
                widget.message,
                textAlign: TextAlign.right,
                style: textNormal14White(),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: widget.code,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  suffixIcon: const Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 40),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorPalette.principal),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: ColorPalette.principal), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
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
                  if (value.length < 6) {
                    return;
                  }
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
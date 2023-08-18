import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

class RowButtonsWhenMenu extends StatelessWidget {
  const RowButtonsWhenMenu(
      {super.key, required this.onSave, required this.onCancel});

  final void Function(bool) onSave;
  final void Function(bool) onCancel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 44,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color.fromRGBO(219, 177, 42, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            width: 138,
            height: 42,
            child: Center(
              child: TextButton(
                child: Text(Constant.cancelBtn,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
                onPressed: () => onCancel(true),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(219, 177, 42, 1),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            width: 138,
            height: 42,
            child: Center(
              child: TextButton(
                child: Text(
                  Constant.saveBtn,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 16.0,
                    wordSpacing: 1,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  onSave(true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

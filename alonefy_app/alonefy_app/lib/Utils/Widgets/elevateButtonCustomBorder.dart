import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class ElevateButtonCustomBorder extends StatefulWidget {
  const ElevateButtonCustomBorder(
      {super.key, required this.onChanged, required this.mensaje});
  final ValueChanged<bool> onChanged;

  final String mensaje;
  @override
  State<ElevateButtonCustomBorder> createState() =>
      _ElevateButtonCustomBorderState();
}

class _ElevateButtonCustomBorderState extends State<ElevateButtonCustomBorder> {
  @override
  void initState() {
    super.initState();
  }

  void _selectOption(bool tap) {
    setState(() {
      widget.onChanged(tap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
      ),
      onPressed: (() {
        _selectOption(true);
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: ColorPalette.principal),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Text(widget.mensaje),
        ),
      ),
    );
  }
}

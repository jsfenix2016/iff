import 'package:flutter/material.dart';

import 'package:ifeelefine/Common/button_style_custom.dart';

import 'package:ifeelefine/Common/text_style_font.dart';

class ElevateButtonFilling extends StatefulWidget {
  const ElevateButtonFilling(
      {super.key,
      required this.onChanged,
      required this.mensaje,
      required this.showIcon,
      required this.img});
  final ValueChanged<bool> onChanged;
  final bool showIcon;
  final String mensaje;
  final String img;
  @override
  State<ElevateButtonFilling> createState() => _ElevateButtonFillingState();
}

class _ElevateButtonFillingState extends State<ElevateButtonFilling> {
  void _selectOption(bool tap) {
    widget.onChanged(tap);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: styleColorClear(),
      onPressed: () {
        _selectOption(true);
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(
                  0xFFCA9D0B), // El color #CA9D0B en formato ARGB (Alpha, Rojo, Verde, Azul)
              Color(
                  0xFFDBB12A), // El color #DBB12A en formato ARGB (Alpha, Rojo, Verde, Azul)
            ],
            stops: [
              0.1425,
              0.9594
            ], // Puedes ajustar estos valores para cambiar la ubicación de los colores en el gradiente
            transform: GradientRotation(92.66 *
                (3.14159265359 /
                    180)), // Convierte el ángulo a radianes para Flutter
          ),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: widget.showIcon,
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: Image.asset(
                    fit: BoxFit.fill,
                    widget.img,
                  ),
                ),
              ),
              Visibility(
                visible: widget.showIcon,
                child: const SizedBox(
                  width: 10,
                ),
              ),
              Text(
                widget.mensaje,
                style: textNormal16Black(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

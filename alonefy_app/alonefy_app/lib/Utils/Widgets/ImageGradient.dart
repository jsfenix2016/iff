import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getPremiumImageGradient(String img) {
  return Stack(
    children: [
      SizedBox(
        child: Image.asset(
          fit: BoxFit.fitWidth,
          'assets/images/$img',
          height: 400,
          width: double.infinity,
        ),
      ),
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Utiliza constraints para obtener el tamaño disponible
          // y configura adecuadamente tu widget
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0, 1),
                colors: <Color>[
                  Colors.black,
                  Colors.transparent,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            height: 250,
            width: constraints.maxWidth,
          );
        },
      ),
      Positioned(
        left: 0.0,
        right: 0,
        top: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0, 1),
              colors: <Color>[
                Colors.transparent,
                Colors.transparent,
                Colors.black,
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          height: 400,
          width: double.infinity,
        ),
      )
    ],
  );
}

Widget getMapImageGradient() {
  return Stack(
    children: [
      SizedBox(
        child: Image.asset(
          fit: BoxFit.fill,
          scale: 0.65,
          'assets/images/Map.png',
          height: 400,
          width: double.infinity,
        ),
      ),
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Utiliza constraints para obtener el tamaño disponible
          // y configura adecuadamente tu widget
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0, 1),
                colors: <Color>[
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            height: 150,
            width: constraints.maxWidth,
          );
        },
      ),
      Positioned(
        left: 0.0,
        right: 0,
        top: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0, 1),
              colors: <Color>[
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black.withAlpha(600),
                Colors.black.withAlpha(400),
                Colors.black.withAlpha(200),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          height: 400,
          width: double.infinity,
        ),
      )
    ],
  );
}
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';

class SwipeableContainer extends StatefulWidget {
  const SwipeableContainer({super.key});

  @override
  _SwipeableContainerState createState() => _SwipeableContainerState();
}

class _SwipeableContainerState extends State<SwipeableContainer> {
  late Offset _dragPosition = Offset.zero;

  late final List<String> allMov = [];
  List<String> temp = [];
  late final List<DateTime> allMovTime = [];

  Future<void> getAllMov() async {
    Box<UserPositionBD> box =
        await Hive.openBox<UserPositionBD>('UserPositionBD');

    for (var element in box.values) {
      allMovTime.add(element.movRureUser);
    }

    allMovTime.sort((a, b) {
      //sorting in descending order
      return b.compareTo(a);
    });

    for (var element in allMovTime) {
      allMov.add("Movimiento brusco $element");
    }

    temp = removeDuplicates(allMov);
    setState(() {});
  }

  List<String> removeDuplicates(List<String> originalList) {
    return originalList.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var box = getAllMov();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          _dragPosition = details.globalPosition;
        });
      },
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: _dragPosition.dy == 0
                ? size.height - 200
                : _dragPosition.dy, //_dragPosition.dy,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(169, 146, 125, 0.2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                width: size.width - 20,
                height: 400,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      width: size.width,
                      height: 30,
                      child: Center(
                        child: Text(
                          'Movimientos',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 20.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 32.0, left: 8, right: 8),
                      child: ListView.builder(
                        shrinkWrap: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: temp.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(temp[index].toString()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

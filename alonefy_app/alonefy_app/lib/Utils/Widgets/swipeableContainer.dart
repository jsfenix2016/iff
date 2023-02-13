import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';

class SwipeableContainer extends StatefulWidget {
  const SwipeableContainer({super.key});

  @override
  State<SwipeableContainer> createState() => _SwipeableContainerState();
}

class _SwipeableContainerState extends State<SwipeableContainer> {
  late Offset _dragPosition = Offset.zero;

  late final List<UserPositionBD> allMov = [];
  List<UserPositionBD> temp = [];
  late final List<UserPositionBD> allMovTime = [];

  Future<void> getAllMov() async {
    Box<UserPositionBD> box =
        await Hive.openBox<UserPositionBD>('UserPositionBD');

    for (var element in box.values) {
      allMovTime.add(element);
    }

    allMovTime.sort((a, b) {
      //sorting in descending order
      return b.movRureUser.compareTo(a.movRureUser);
    });

    for (var element in allMovTime) {
      allMov.add(element);
    }

    temp = removeDuplicates(allMov);
    setState(() {});
  }

  List<UserPositionBD> removeDuplicates(List<UserPositionBD> originalList) {
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
                  color:
                      Colors.transparent, //Color.fromRGBO(169, 146, 125, 0.2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                width: size.width - 20,
                height: 400,
                child: Stack(
                  children: [
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     color: Colors.transparent,
                    //     borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(10),
                    //         topRight: Radius.circular(10)),
                    //   ),
                    //   width: size.width,
                    //   height: 30,
                    //   child: Center(
                    //     child: Text(
                    //       'Movimientos',
                    //       textAlign: TextAlign.center,
                    //       style: GoogleFonts.barlow(
                    //         fontSize: 20.0,
                    //         wordSpacing: 1,
                    //         letterSpacing: 1.2,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 28.0, left: 8, right: 8),
                      child: ListView.builder(
                        shrinkWrap: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: temp.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 312,
                              height: 88,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(11, 11, 10, 0.6),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: ListTile(
                                leading: IconButton(
                                  iconSize: 40,
                                  color: ColorPalette.principal,
                                  onPressed: () {},
                                  icon: Container(
                                    height: 32,
                                    width: 31.2,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/Warning.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  temp[index].typeAction.toString(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.barlow(
                                    fontSize: 16.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  temp[index].movRureUser.toString(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.barlow(
                                    fontSize: 16.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: IconButton(
                                  iconSize: 21,
                                  color: ColorPalette.principal,
                                  onPressed: () {},
                                  icon: Container(
                                    height: 21,
                                    width: 21,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/Exclamation.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

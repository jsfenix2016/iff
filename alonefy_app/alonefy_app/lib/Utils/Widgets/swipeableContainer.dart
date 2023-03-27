import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';

class SwipeableContainer extends StatefulWidget {
  const SwipeableContainer({super.key, required this.temp});
  final List<UserPositionBD> temp;
  @override
  State<SwipeableContainer> createState() => _SwipeableContainerState();
}

class _SwipeableContainerState extends State<SwipeableContainer> {
  late Offset _dragPosition = Offset.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getAllMov();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 28.0, left: 8, right: 8),
                      child: ListView.builder(
                        shrinkWrap: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.temp.length,
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
                                  widget.temp[index].typeAction.toString(),
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
                                  widget.temp[index].movRureUser.toString(),
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

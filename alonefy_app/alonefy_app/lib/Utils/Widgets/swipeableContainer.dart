import 'package:flutter/material.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:intl/intl.dart';

class SwipeableContainer extends StatefulWidget {
  const SwipeableContainer({super.key, required this.temp});
  final List<LogAlertsBD> temp;
  @override
  State<SwipeableContainer> createState() => _SwipeableContainerState();
}

class _SwipeableContainerState extends State<SwipeableContainer> {
  late Offset _dragPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          if (details.globalPosition.dy >=
              MediaQuery.of(context).size.height / 2.1) {
            _dragPosition = details.globalPosition;
          }
          // if (size.width / 2 >= 320) {
          //   _dragPosition = Offset(0, size.width / 2);
          // } else {
          //   _dragPosition = details.globalPosition;
          // }
        });
      },
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: size.height / 2, //_dragPosition.dy,
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
                          const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                      child: ListView.builder(
                        itemCount:
                            widget.temp.length < 10 ? widget.temp.length : 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 312,
                              height: 70,
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
                                  widget.temp[index].type.toString(),
                                  textAlign: TextAlign.left,
                                  style: textNormal16White(),
                                ),
                                subtitle: Text(
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(widget.temp[index].time)
                                      .toString(),
                                  textAlign: TextAlign.left,
                                  style: textNormal16White(),
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

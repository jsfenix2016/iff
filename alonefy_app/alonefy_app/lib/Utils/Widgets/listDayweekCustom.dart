import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restdaybd.dart';

class ListDayWeek extends StatefulWidget {
  const ListDayWeek(
      {super.key,
      required this.listRest,
      required this.newIndex,
      required this.onChanged});

  final List<RestDayBD> listRest;
  final ValueChanged<int> onChanged;
  final int newIndex;
  @override
  State<ListDayWeek> createState() => _ListDayWeekState();
}

class _ListDayWeekState extends State<ListDayWeek> {
  final List<String> tempNoSelectListDay = <String>[
    "L",
    "M",
    "X",
    "J",
    "V",
    "S",
    "D",
  ];
  int indextemp = 0;
  int count = -1;

  bool withColor(int indexDay) {
    bool isSelect = false;

    if ((widget.listRest.isNotEmpty)) {
      for (var i = 0; i < widget.listRest.length; i++) {
        if ((widget.listRest[i].selection == widget.newIndex) &&
            (widget.listRest[i].isSelect == true)) {
          isSelect = widget.listRest[i].isSelect;
        } else {
          isSelect = false;
        }
      }
    }

    return isSelect;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (var i = 0; i < tempNoSelectListDay.length; i++)
          GestureDetector(
            key: Key(i.toString()),
            onTap: () {
              if (widget.listRest[i].isSelect == false) {
                widget.onChanged(i);
              } else {
                widget.onChanged(i);
              }

              setState(
                () {},
              );
            },
            child: Container(
              key: Key(i.toString()),
              width: size.width / 7,
              height: 50,
              color: Colors.transparent,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      key: Key(i.toString()),
                      decoration: BoxDecoration(
                        border: (widget.listRest[i].isSelect &&
                                widget.listRest[i].selection == widget.newIndex)
                            ? null
                            : Border.all(
                                color: (widget.listRest[i].isSelect &&
                                        widget.listRest[i].selection ==
                                            widget.newIndex)
                                    ? ColorPalette.principal
                                    : Colors.white,
                                width: 1,
                              ),
                        color: (widget.listRest[i].isSelect &&
                                widget.listRest[i].selection == widget.newIndex)
                            ? ColorPalette.principal
                            : null,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      height: 38,
                      width: 38.59,
                      child: Center(
                        child: Text(
                          tempNoSelectListDay[i],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 20.0,
                            wordSpacing: 1,
                            letterSpacing: 1,
                            fontWeight: (widget.listRest[i].isSelect &&
                                    widget.listRest[i].selection ==
                                        widget.newIndex)
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: (widget.listRest[i].isSelect &&
                                    widget.listRest[i].selection ==
                                        widget.newIndex)
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

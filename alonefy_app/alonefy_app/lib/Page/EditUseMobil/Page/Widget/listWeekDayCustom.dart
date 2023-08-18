import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';

class ListWeekDayCustom<T> extends StatefulWidget {
  const ListWeekDayCustom({
    Key? key,
    required this.listRest,
    required this.newIndex,
    required this.onChanged,
    required this.model,
  }) : super(key: key);

  final List<UseMobilBD> listRest;
  final ValueChanged<int> onChanged;
  final int newIndex;
  final T model;

  @override
  State<ListWeekDayCustom<T>> createState() => _ListWeekDayCustomState<T>();
}

class _ListWeekDayCustomState<T> extends State<ListWeekDayCustom<T>> {
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
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < Constant.tempListShortDay.length; i++)
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
              width: size.width / 7.5,
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
                                    : i == 5 || i == 6
                                        ? Colors.red
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
                          Constant.tempListShortDay[i],
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
                                : i == 5 || i == 6
                                    ? Colors.red
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

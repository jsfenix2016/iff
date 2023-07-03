import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class GetSwitches extends StatefulWidget {
  const GetSwitches(
      {super.key,
      required this.selectedDays,
      required this.sizeT,
      required this.onChanged,
      required this.onPress});
  final List<bool> selectedDays;
  final Size sizeT;
  final ValueChanged<List<bool>> onChanged;
  final ValueChanged<int> onPress;
  @override
  State<GetSwitches> createState() => _GetSwitchesState();
}

class _GetSwitchesState extends State<GetSwitches> {
  List<bool> itemsDropDown = [false, false, false, false, false];
  List<String> itemsDropDownText = [
    Constant.onceTime,
    Constant.diary,
    Constant.weekly,
    Constant.monthly,
    Constant.yearly
  ];
  bool isDropDownVisible = false;

  Widget getFutureDayContainer(int index, Size size) {
    return FutureBuilder<Widget>(
        future: calculateDayContainer(index, size),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Future<Widget> calculateDayContainer(int index, Size size) {
    return Future<Widget>.delayed(
        const Duration(milliseconds: 50), () => getDayContainer(index, size));
  }

  Widget getDayContainer(int index, Size size) {
    return SizedBox(
        width: size.width / 7 - 32 / 7, child: Center(child: getDay(index)));
  }

  Widget getDay(int index) {
    return Container(
      decoration: BoxDecoration(
        border: widget.selectedDays[index]
            ? null
            : Border.all(
                color: widget.selectedDays[index]
                    ? ColorPalette.principal
                    : Colors.white,
                width: 1,
              ),
        color: widget.selectedDays[index] ? ColorPalette.principal : null,
        borderRadius: BorderRadius.circular(100),
      ),
      height: 38,
      width: 38,
      child: Center(
          child: TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: () {
          widget.selectedDays[index] = !widget.selectedDays[index];
          widget.onPress(index);
          setState(() {});
        },
        child: Text(
          Constant.tempListShortDay[index],
          textAlign: TextAlign.center,
          style: GoogleFonts.barlow(
            fontSize: 20.0,
            wordSpacing: 1,
            letterSpacing: 1,
            fontWeight: widget.selectedDays[index]
                ? FontWeight.bold
                : FontWeight.normal,
            color: widget.selectedDays[index] ? Colors.black : Colors.white,
          ),
        ),
      )),
    );
  }

  Widget getFutureSwitch(String text, StateSetter setState) {
    return FutureBuilder<Widget>(
        future: calculateSwitch(text, setState),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Container();
          }
        });
  }

  Future<Widget> calculateSwitch(String text, StateSetter setState) {
    return Future<Widget>.delayed(
        const Duration(milliseconds: 50), () => getSwitch(text, setState));
  }

  Future<Widget> getSwitch(String text, StateSetter setState) async {
    return Row(
      children: [
        if (!isDropDownVisible) ...[
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: GoogleFonts.barlow(
                  fontSize: 18.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 222, 222, 222)),
            ),
          ),
          Positioned(
              right: 24,
              child: SizedBox(
                width: 120,
                child: CupertinoSwitch(
                  value: itemsDropDown[getIndexOfItemsDropDown(text)],
                  activeColor: ColorPalette.activeSwitch,
                  trackColor: CupertinoColors.inactiveGray,
                  onChanged: (bool? value) {
                    var count = 0;
                    for (var itemText in itemsDropDownText) {
                      itemsDropDown[count] = false;
                      if (itemText == text) {
                        itemsDropDown[count] = value!;
                        widget.onChanged(itemsDropDown);
                      }
                      count++;
                    }
                    setState(() {});
                  },
                ),
              ))
        ]
      ],
    );
  }

  int getIndexOfItemsDropDown(String text) {
    var count = 0;
    var index = 0;
    for (var itemText in itemsDropDownText) {
      if (itemText == text) {
        index = count;
        break;
      }
      count++;
    }

    return index;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            for (var text in itemsDropDownText) getFutureSwitch(text, setState),
            const SizedBox(height: 12),
            if (itemsDropDown[2]) ...[
              Row(
                children: [
                  const SizedBox(width: 16),
                  getFutureDayContainer(0, widget.sizeT),
                  getFutureDayContainer(1, widget.sizeT),
                  getFutureDayContainer(2, widget.sizeT),
                  getFutureDayContainer(3, widget.sizeT),
                  getFutureDayContainer(4, widget.sizeT),
                  getFutureDayContainer(5, widget.sizeT),
                  getFutureDayContainer(6, widget.sizeT),
                  const SizedBox(width: 16)
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/activityDay.dart';

import 'package:ifeelefine/Page/AddActivityPage/Controller/addActivityController.dart';
import 'package:ifeelefine/Page/Calendar/calendarPopup.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:jiffy/jiffy.dart';

import '../../../Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class AddActivityPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const AddActivityPage(
      {Key? key, required this.isMenu, required this.from, required this.to})
      : super(key: key);

  final bool isMenu;
  final DateTime from;
  final DateTime to;

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage>
    with TickerProviderStateMixin {
  final _prefs = PreferenceUser();

  final AddActivityController controller = Get.put(AddActivityController());

  int hoursPositionPicker1 = 0;
  int minutesPositionPicker1 = 0;
  int hoursPositionPicker2 = 0;
  int minutesPositionPicker2 = 0;

  String hoursPicker1 = "00";
  String hoursPicker2 = "00";
  String minutesPicker1 = "00";
  String minutesPicker2 = "00";

  String from = "";
  String to = "";

  bool isDropDownVisible = false;

  List<bool> itemsDropDown = [false, false, false, false, false];
  List<String> itemsDropDownText = [
    Constant.onceTime,
    Constant.diary,
    Constant.weekly,
    Constant.monthly,
    Constant.yearly
  ];

  final List<String> tempNoSelectListDay = <String>[
    "L",
    "M",
    "X",
    "J",
    "V",
    "S",
    "D",
  ];

  final List<bool> _selectedDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  final TextEditingController textController = TextEditingController();

  bool allDay = false;

  static const int _maxActivitiesNoPremium = 2;

  Future<Widget> calculate(BuildContext context, Size size) {
    return Future<Widget>.delayed(
        const Duration(milliseconds: 100), () => getStack(context, size));
  }

  @override
  void initState() {
    super.initState();
    initDates();
    if (getItemSelected() == "") isDropDownVisible = false;

    hoursPicker1 = Constant.hours[hoursPositionPicker1.toString()]!;
    minutesPicker1 = Constant.minutes[minutesPositionPicker1.toString()]!;
    hoursPicker2 = Constant.hours[hoursPositionPicker2.toString()]!;
    minutesPicker2 = Constant.minutes[minutesPositionPicker2.toString()]!;
    setState(() {});
  }

  void initDates() async {
    await Jiffy.locale("es");
    var date = Jiffy().format('EEEE, d [de] MMMM [del] yyyy');

    setState(() {
      if (widget.from != null && widget.to != null) {
        from = Jiffy(widget.from).format('EEEE, d [de] MMMM [del] yyyy');
        to = Jiffy(widget.to).format('EEEE, d [de] MMMM [del] yyyy');
      } else {
        from = date.capitalizeFirst!;
        to = date.capitalizeFirst!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setContext(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Configuración",
          style: textForTitleApp(),
        ),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: FutureBuilder<Widget>(
          future: calculate(context, size),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<Widget> getStack(BuildContext context, Size size) async {
    return Stack(
      children: [
        Positioned(
          top: 32,
          left: 0,
          right: 0,
          child: Center(
            child: Text('Actividad',
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 22.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 70, 0, 100),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                child: getTextField(),
              ),
              const SizedBox(height: 37),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Todo el día",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.barlow(
                          fontSize: 20.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                      width: 120,
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return CupertinoSwitch(
                            value: allDay,
                            activeColor: ColorPalette.activeSwitch,
                            trackColor: CupertinoColors.inactiveGray,
                            onChanged: (bool? value) {
                              allDay = value!;
                              setState(() {});
                            },
                          );
                        },
                      ))
                ],
              ),
              const SizedBox(height: 40),
              getDateSelected("De"),
              const SizedBox(height: 8),
              getDateSelected("A"),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: getHourTitle("Hora Inicio"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 56, 0),
                      child: getHourTitle("Hora Fin"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: getFutureColumnPicker(
                          hoursPositionPicker1, minutesPositionPicker1, 0),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                      child: getFutureColumnPicker(
                          hoursPositionPicker2, minutesPositionPicker2, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                          child: Text(
                            "Repetir",
                            style: GoogleFonts.barlow(
                                fontSize: 20.0,
                                wordSpacing: 1,
                                letterSpacing: 0.001,
                                fontWeight: FontWeight.w500,
                                color:
                                    const Color.fromARGB(255, 222, 222, 222)),
                          ))),
                  if (isDropDownVisible) ...[
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isDropDownVisible = false;
                              });
                            },
                            child: Text(
                              getItemSelected(),
                              style: GoogleFonts.barlow(
                                  fontSize: 14.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                    SizedBox(
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 26),
                          child: IconButton(
                            icon: const ImageIcon(
                              AssetImage('assets/images/drop_down.png'),
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isDropDownVisible = false;
                              });
                            },
                          ),
                        ))
                  ]
                ],
              ),
              const SizedBox(height: 12),
              getSwitches(size),
              const SizedBox(height: 32)
            ]),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 32,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(219, 177, 42, 1),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            width: 138,
            height: 42,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                    minimumSize: const Size.fromWidth(138)),
                child: Text('Guardar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      letterSpacing: 0.001,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    )),
                onPressed: () async {
                  if (isRepeatTypeSelected()) {
                    var activities = await controller.getActivities();
                    if (activities.length > _maxActivitiesNoPremium &&
                        !_prefs.getUserPremium) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PremiumPage(
                                isFreeTrial: false,
                                img: 'pantalla3.png',
                                title: Constant.premiumFallTitle,
                                subtitle: '')),
                      ).then((value) {
                        if (value != null && value) {
                          _prefs.setUserFree = false;
                          _prefs.setUserPremium = true;
                          var premiumController = Get.put(PremiumController());
                          premiumController.updatePremiumAPI(true);
                        }
                      });
                    } else {
                      if (controller.startTimeIsBeforeEndTime(hoursPicker1,
                          hoursPicker2, minutesPicker1, minutesPicker2)) {
                        var activity = createActivity();
                        var activityApiResponse =
                            await controller.saveActivityApi(activity);
                        if (activityApiResponse != null) {
                          activity.id = activityApiResponse.id;
                          await controller.saveActivity(context, activity);
                        }

                        Navigator.of(context).pop();
                      } else {
                        showAlert(context, Constant.activitiesTimeError);
                      }
                    }
                  } else {
                    showRepeatTypeError();
                  }
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 32,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color.fromRGBO(219, 177, 42, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            width: 138,
            height: 42,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                    minimumSize: const Size.fromWidth(138)),
                child: Text('Cancelar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      letterSpacing: 0.001,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget getTextField() {
    return TextField(
      autofocus: false,
      controller: textController,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Nombre Actividad",
        hintStyle: GoogleFonts.barlow(
            fontSize: 20.0,
            wordSpacing: 1,
            letterSpacing: 0.001,
            fontWeight: FontWeight.w500,
            color: Colors.white),
        fillColor: const Color.fromRGBO(169, 146, 125, 0.2),
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      style: GoogleFonts.barlow(
          fontSize: 20.0,
          wordSpacing: 1,
          letterSpacing: 0.001,
          fontWeight: FontWeight.w500,
          color: Colors.white),
    );
  }

  Widget getDateSelected(String dateType) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 70,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
            child: Text(
              dateType,
              style: GoogleFonts.barlow(
                  fontSize: 22.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: TextButton(
            style: const ButtonStyle(alignment: Alignment.centerRight),
            onPressed: () async {
              var rangeDateTime = await showCalendar(context);

              if (rangeDateTime != null) {
                if (rangeDateTime.from != null && rangeDateTime.to != null) {
                  updateDate('De', rangeDateTime.from!);
                  updateDate('A', rangeDateTime.to!);
                } else if (rangeDateTime.from != null) {
                  updateDate(dateType, rangeDateTime.from!);
                }
              }
            },
            child: Text(
              dateType == "De" ? from : to,
              textAlign: TextAlign.right,
              style: GoogleFonts.barlow(
                  fontSize: 16.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  String getStringFromDate(String date) {
    return date.substring(0, date.length - 5);
  }

  void updateDate(String dateType, DateTime date) async {
    await Jiffy.locale("es");
    var strDate = Jiffy(date).format('EEEE, d [de] MMMM [del] yyyy');

    var tempFrom = from.toLowerCase().replaceAll("de ", "");
    tempFrom = tempFrom.replaceAll("del ", "");
    var fromDate = Jiffy(tempFrom, 'EEEE, d MMMM yyyy');

    var tempTo = to.toLowerCase().replaceAll("de ", "");
    tempTo = tempTo.toLowerCase().replaceAll("del ", "");
    var toDate = Jiffy(tempTo, 'EEEE, d MMMM yyyy');

    if (dateType == "De") {
      from = strDate.capitalizeFirst!;
      if (toDate.isBefore(date)) {
        to = strDate.capitalizeFirst!;
      }
    } else {
      if (fromDate.isSameOrBefore(date)) {
        to = strDate.capitalizeFirst!;
      } else {
        to = strDate.capitalizeFirst!;
        from = strDate.capitalizeFirst!;
      }
    }

    setState(() {});
  }

  Widget getHourTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.barlow(
          fontSize: 20.0,
          wordSpacing: 1,
          letterSpacing: 0.001,
          fontWeight: FontWeight.w500,
          color: Colors.white),
    );
  }

  Widget getFutureColumnPicker(
      int initialPosition1, int initialPosition2, int pickerId) {
    return FutureBuilder<Widget>(
        future:
            calculateColumnPicker(initialPosition1, initialPosition2, pickerId),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Container();
          }
        });
  }

  Future<Widget> calculateColumnPicker(
      int initialPosition1, int initialPosition2, int pickerId) {
    return Future<Widget>.delayed(const Duration(milliseconds: 50),
        () => getColumnPicker(initialPosition1, initialPosition2, pickerId));
  }

  Widget getColumnPicker(
      int initialPosition1, int initialPosition2, int pickerId) {
    return Column(
      children: [
        Row(
          children: [
            getPicker(initialPosition1, Constant.hours, pickerId),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                ":",
                style: GoogleFonts.barlow(
                  fontSize: 24.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            getPicker(initialPosition2, Constant.minutes, pickerId)
          ],
        )
      ],
    );
  }

  Widget getPicker(
      int initialPosition, Map<String, String> time, int pickerId) {
    return SizedBox(
      width: 60,
      height: 120,
      child: CupertinoPicker(
        diameterRatio: 2,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent),
        backgroundColor: Colors.transparent,
        onSelectedItemChanged: (int value) {
          if (value != null) {
            if (pickerId == 0 && time == Constant.hours) {
              hoursPicker1 = time[value.toString()]!;
            } else if (pickerId == 0 && time == Constant.minutes) {
              minutesPicker1 = time[value.toString()]!;
            } else if (pickerId == 1 && time == Constant.hours) {
              hoursPicker2 = time[value.toString()]!;
            } else if (pickerId == 1 && time == Constant.minutes) {
              minutesPicker2 = time[value.toString()]!;
            }
          }
        },
        scrollController:
            FixedExtentScrollController(initialItem: initialPosition),
        itemExtent: 60.0,
        children: [
          for (var i = 0; i < time.length; i++)
            Container(
              height: 24,
              width: 120,
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    time[i.toString()].toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 30.0,
                      wordSpacing: 1,
                      letterSpacing: 0.001,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget getFutureDayContainer(int index, Size size) {
    return FutureBuilder<Widget>(
        future: calculateDayContainer(index, size),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return Container();
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
        border: _selectedDays[index]
            ? null
            : Border.all(
                color: _selectedDays[index]
                    ? ColorPalette.principal
                    : Colors.white,
                width: 1,
              ),
        color: _selectedDays[index] ? ColorPalette.principal : null,
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
          setState(() {
            _selectedDays[index] = !_selectedDays[index];
          });
        },
        child: Text(
          tempNoSelectListDay[index],
          textAlign: TextAlign.center,
          style: GoogleFonts.barlow(
            fontSize: 20.0,
            wordSpacing: 1,
            letterSpacing: 1,
            fontWeight:
                _selectedDays[index] ? FontWeight.bold : FontWeight.normal,
            color: _selectedDays[index] ? Colors.black : Colors.white,
          ),
        ),
      )),
    );
  }

  Widget getSwitches(Size size) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            for (var text in itemsDropDownText) getFutureSwitch(text, setState),
            const SizedBox(height: 12),
            if (itemsDropDown[2]) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getFutureDayContainer(0, size),
                  getFutureDayContainer(1, size),
                  getFutureDayContainer(2, size),
                  getFutureDayContainer(3, size),
                  getFutureDayContainer(4, size),
                  getFutureDayContainer(5, size),
                  getFutureDayContainer(6, size),
                ],
              ),
            ],
          ],
        );
      },
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
            flex: 1,
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
          SizedBox(
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
                  }
                  count++;
                }
                setState(() {});
              },
            ),
          )
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

  String getItemSelected() {
    var count = 0;
    var index = -1;

    for (var itemSelected in itemsDropDown) {
      if (itemSelected) {
        index = count;
        break;
      }

      count++;
    }

    return index == -1 ? "" : itemsDropDownText[index];
  }

  bool isRepeatTypeSelected() {
    return getItemSelected() != "";
  }

  void showRepeatTypeError() {
    showSaveAlert(context, "Faltan datos",
        "Se ha de seleccionar que tipo de repetición quieres para esta actividad");
  }

  ActivityDay createActivity() {
    var activity = ActivityDay();
    activity.id = 0;
    activity.activity = textController.text;
    activity.allDay = allDay;
    activity.day = parseDateTime(from);
    activity.dayFinish = parseDateTime(to);
    activity.timeStart = "$hoursPicker1:$minutesPicker1";
    activity.timeFinish = "$hoursPicker2:$minutesPicker2";
    activity.days = convertDayListToDaysString();
    activity.repeatType = getItemSelected();
    activity.isDeactivate = false;

    return activity;
  }

  String parseDateTime(String dateTime) {
    var tempDateTime = dateTime.toLowerCase().replaceAll("de ", "");
    tempDateTime = tempDateTime.replaceAll("del ", "");

    return tempDateTime;
  }

  String convertDayListToDaysString() {
    String strDays = "";

    for (var index = 0; index < _selectedDays.length; index++) {
      if (_selectedDays[index]) strDays += "${tempNoSelectListDay[index]};";
    }

    if (strDays.isNotEmpty) strDays = strDays.substring(0, strDays.length - 1);

    return strDays;
  }
}

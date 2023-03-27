import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Page/Calendar/calendarPopup.dart';
import 'package:jiffy/jiffy.dart';

import '../../../Model/activityDay.dart';
import '../../AddActivityPage/Controller/addActivityController.dart';
import '../../AddActivityPage/PageView/addActivity_page.dart';

class PreviewActivitiesByDate extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const PreviewActivitiesByDate({Key? key}) : super(key: key);

  @override
  State<PreviewActivitiesByDate> createState() =>
      _PreviewActivitiesByDateState();
}

class _PreviewActivitiesByDateState extends State<PreviewActivitiesByDate>
    with WidgetsBindingObserver {
  final AddActivityController controller = Get.put(AddActivityController());

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

  DateTime? _from = DateTime.now();
  DateTime? _to = DateTime.now();

  var _rangeDateText = "";

  var _activitiesNameText = "";

  final List<DateTime> _days = [];
  List<ActivityDay> _activities = [];
  final Map<int, List<ActivityDay>> _activitiesByDay =
      <int, List<ActivityDay>>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _from = DateTime(_from!.year, _from!.month, _from!.day);
    _to = DateTime(_to!.year, _to!.month, _to!.day);
    init();
    updateRangeDateTextSelected();
    setState(() {});
  }

  void init() async {
    _activities = await getActivitiesDB();
    filterActivitiesByRangeDate();
    updateActivitiesName();
    setState(() {});
  }

  Future<List<ActivityDay>> getActivitiesDB() async {
    return await controller.getActivities();
  }

  void filterActivitiesByRangeDate() async {
    await Jiffy.locale('es');

    var daysBetweenToAndFrom = 0;

    _days.clear();
    _activitiesByDay.clear();

    if (_from != null && _to != null) {
      daysBetweenToAndFrom = daysBetween(_from!, _to!);
    }

    for (var index = 0; index <= daysBetweenToAndFrom; index++) {
      var currentDate = DateTime(_from!.year, _from!.month, _from!.day + index);

      List<ActivityDay> activitiesByDay = [];

      for (var activity in _activities) {
        //var tempActivity = controller.clone(activity);
        var startDate = Jiffy(activity.day.toLowerCase(), 'EEEE, d MMMM yyyy');
        var endDate =
            Jiffy(activity.dayFinish.toLowerCase(), 'EEEE, d MMMM yyyy');

        // Comprobar si la fecha actual (currentDate) está dentro del rango de fechas de la activity
        if (endDate.isBefore(_from!) || startDate.isAfter(_to!)) {
        } else {
          var isDayRemoved = false;

          // Recopilar días borrados. Comprobar si currentDate es un día borrado
          if (activity.specificDaysRemoved != null &&
              activity.specificDaysRemoved!.isNotEmpty) {
            var daysRemoved = activity.specificDaysRemoved!.split(';');
            for (var dayRemoved in daysRemoved) {
              var dayRemovedDate =
                  Jiffy(dayRemoved.toLowerCase(), 'EEEE, d MMMM yyyy').dateTime;
              if (dayRemovedDate.year == currentDate.year &&
                  dayRemovedDate.month == currentDate.month &&
                  dayRemovedDate.day == currentDate.day) {
                isDayRemoved = true;
                break;
              }
            }
          }

          if (!isDayRemoved) {
            // Hacer validaciones según el tipo de periodicidad de la tempActivity
            switch (activity.repeatType) {
              case onceTime:
                var onceDate =
                    Jiffy(activity.day.toLowerCase(), getDefaultPattern())
                        .dateTime;
                if (onceDate.year == currentDate.year &&
                    onceDate.month == currentDate.month &&
                    onceDate.day == currentDate.day &&
                    isFilteredDayValid(onceDate)) {
                  activitiesByDay.add(activity);
                }
                break;
              case diary:
                var diaryStartDate =
                    Jiffy(activity.day.toLowerCase(), getDefaultPattern())
                        .dateTime;
                var diaryEndDate =
                    Jiffy(activity.dayFinish.toLowerCase(), getDefaultPattern())
                        .dateTime;

                if (!diaryStartDate.isAfter(currentDate) &&
                    !diaryEndDate.isBefore(currentDate) &&
                    isFilteredDayValid(currentDate)) {
                  activitiesByDay.add(activity);
                }
                break;
              case weekly:
                if (activity.days != null && activity.days!.isNotEmpty) {
                  var daysRepeated = activity.days!.split(';');
                  for (var day in daysRepeated) {
                    var weeklyStartDate =
                        Jiffy(activity.day.toLowerCase(), getDefaultPattern())
                            .dateTime;
                    var weeklyEndDate = Jiffy(activity.dayFinish.toLowerCase(),
                            getDefaultPattern())
                        .dateTime;

                    if (!weeklyStartDate.isAfter(currentDate) &&
                        !weeklyEndDate.isBefore(currentDate) &&
                        isFilteredDayValid(currentDate)) {
                      for (var index = 0;
                          index < tempNoSelectListDay.length;
                          index++) {
                        if (currentDate.weekday == (index + 1) &&
                            day == tempNoSelectListDay[index]) {
                          activitiesByDay.add(activity);
                          break;
                        }
                      }
                    }
                  }
                }
                break;
              case monthly:
                var monthlyStartDate =
                    Jiffy(activity.day.toLowerCase(), getDefaultPattern())
                        .dateTime;
                var monthlyEndDate =
                    Jiffy(activity.dayFinish.toLowerCase(), getDefaultPattern())
                        .dateTime;

                if (!monthlyStartDate.isAfter(currentDate) &&
                    !monthlyEndDate.isBefore(currentDate) &&
                    isFilteredDayValid(currentDate)) {
                  if (monthlyStartDate.day == currentDate.day) {
                    activitiesByDay.add(activity);
                  }
                }
                break;
              case yearly:
                var yearlyStartDate =
                    Jiffy(activity.day.toLowerCase(), getDefaultPattern())
                        .dateTime;
                var yearlyEndDate =
                    Jiffy(activity.dayFinish.toLowerCase(), getDefaultPattern())
                        .dateTime;

                if (!yearlyStartDate.isAfter(currentDate) &&
                    !yearlyEndDate.isBefore(currentDate) &&
                    isFilteredDayValid(currentDate)) {
                  if (yearlyStartDate.month == currentDate.month &&
                      yearlyStartDate.day == currentDate.day) {
                    activitiesByDay.add(activity);
                  }
                }
                break;
            }
          }
        }
      }

      if (activitiesByDay.isNotEmpty) {
        _days.add(currentDate);
        Map<int, List<ActivityDay>> values = {
          _days.length - 1: activitiesByDay
        };
        _activitiesByDay.addAll(values);
      }
    }
  }

  bool isFilteredDayValid(DateTime dateTime) {
    var isDayValid = true;

    for (var index = 0; index < _selectedDays.length; index++) {
      if (_selectedDays.contains(true) &&
          !_selectedDays[index] &&
          dateTime.weekday == (index + 1)) {
        isDayValid = false;
        break;
      }
    }

    return isDayValid;
  }

  Future<bool> isDeactivated(ActivityDay activityDay, DateTime dateTime) async {
    await Jiffy.locale('es');

    var response = false;

    if (activityDay.specificDaysDeactivated != null &&
        activityDay.specificDaysDeactivated!.isNotEmpty) {
      var specifyDaysDeactivated =
          activityDay.specificDaysDeactivated!.split(';');

      for (var specifyDayDeactivated in specifyDaysDeactivated) {
        var specifyDayDateTime =
            Jiffy(specifyDayDeactivated.toLowerCase(), getDefaultPattern())
                .dateTime;

        if (specifyDayDateTime.year == dateTime.year &&
            specifyDayDateTime.month == dateTime.month &&
            specifyDayDateTime.day == dateTime.day) {
          response = true;
          break;
        }
      }
    }

    return response;
  }

  void addIsDeactivated(ActivityDay activityDay, DateTime dateTime) {
    var deactivatedDateTime = Jiffy(dateTime).format(getDefaultPattern());

    if (activityDay.specificDaysDeactivated != null &&
        activityDay.specificDaysDeactivated!.isNotEmpty) {
      activityDay.specificDaysDeactivated =
          "${activityDay.specificDaysDeactivated};$deactivatedDateTime";
    } else {
      activityDay.specificDaysDeactivated = deactivatedDateTime;
    }
  }

  void removeIsDeactivated(ActivityDay activityDay, DateTime dateTime) {
    var deactivatedDateTime = Jiffy(dateTime).format(getDefaultPattern());

    var array = activityDay.specificDaysDeactivated!.split(';');

    activityDay.specificDaysDeactivated = "";

    for (var specifiedDayDeactivated in array) {
      if (deactivatedDateTime != specifiedDayDeactivated) {
        if (activityDay.specificDaysDeactivated != null &&
            activityDay.specificDaysDeactivated!.isNotEmpty) {
          activityDay.specificDaysDeactivated =
              "${activityDay.specificDaysDeactivated};$specifiedDayDeactivated";
        } else {
          activityDay.specificDaysDeactivated = specifiedDayDeactivated;
        }
      }
    }
  }

  void addIsRemoved(ActivityDay activityDay, DateTime dateTime) {
    var removedDateTime = Jiffy(dateTime).format(getDefaultPattern());

    if (activityDay.specificDaysRemoved != null &&
        activityDay.specificDaysRemoved!.isNotEmpty) {
      activityDay.specificDaysRemoved =
          "${activityDay.specificDaysRemoved};$removedDateTime";
    } else {
      activityDay.specificDaysRemoved = removedDateTime;
    }
  }

  void updateRangeDateTime(RangeDateTime rangeDateTime) {
    _from = rangeDateTime.from;
    _to = rangeDateTime.to ?? rangeDateTime.from;
  }

  void updateRangeDateTextSelected() async {
    var rangeDateText = await rangeDateTimeToString(_from, _to);

    setState(() {
      _rangeDateText = rangeDateText;
    });
  }

  void updateActivitiesName() async {
    await Jiffy.locale('es');

    _activitiesNameText = "";
    var activitiesName = "";

    for (var index = 0; index < _activitiesByDay.length; index++) {
      for (var activity in _activitiesByDay[index]!) {
        activitiesName += activity.activity + ";";
      }
    }

    if (activitiesName.isNotEmpty) {
      activitiesName = activitiesName.substring(0, activitiesName.length - 1);
    }

    var activitiesNameArray = activitiesName.split(';');
    var uniqueActivitiesNameArray = activitiesNameArray.toSet().toList();

    for (var uniqueActivityName in uniqueActivitiesNameArray) {
      _activitiesNameText += "$uniqueActivityName, ";
    }

    if (_activitiesNameText.isNotEmpty) {
      _activitiesNameText =
          _activitiesNameText.substring(0, _activitiesNameText.length - 2);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundAppBar,
        title: const Text("Configuración"),
      ),
      body: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                    child:
                        Text("¿En qué actividades no utilizas tu smartphone?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 24.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                              color: ColorPalette.principal,
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                    child: Text(_activitiesNameText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 14.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.offWhite,
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(32, 20, 32, 0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  var rangeDateTime =
                                      await showCalendar(context);

                                  if (rangeDateTime != null) {
                                    updateRangeDateTime(rangeDateTime);
                                    filterActivitiesByRangeDate();
                                    updateRangeDateTextSelected();
                                    updateActivitiesName();
                                  }
                                },
                              )),
                          Expanded(
                              flex: 6,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 22,
                                      height: 19,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/calendar.png'),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: Text(
                                        _rangeDateText,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.barlow(
                                          fontSize: 16.0,
                                          wordSpacing: 1,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ))
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  var rangeDateTime =
                                      await showCalendar(context);

                                  if (rangeDateTime != null) {
                                    updateRangeDateTime(rangeDateTime);
                                    filterActivitiesByRangeDate();
                                    updateRangeDateTextSelected();
                                    updateActivitiesName();
                                  }
                                },
                              )),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        getDayContainer(0, size),
                        getDayContainer(1, size),
                        getDayContainer(2, size),
                        getDayContainer(3, size),
                        getDayContainer(4, size),
                        getDayContainer(5, size),
                        getDayContainer(6, size),
                        SizedBox(width: 16)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _days.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 8, 0, 0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          Jiffy(_days[index])
                                              .format(getShortPattern())
                                              .capitalizeFirst!,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.barlow(
                                            fontSize: 16.0,
                                            wordSpacing: 1,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                      child: Container(
                                        height: 2,
                                        decoration: const BoxDecoration(
                                            color: ColorPalette.secondView),
                                      )),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              _activitiesByDay[index]!.length,
                                          itemBuilder: (BuildContext context,
                                              int indexActivity) {
                                            return Container(
                                              height: 80,
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 8, 0, 0),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorPalette.itemActivity,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                      top: 16,
                                                      left: 16,
                                                      child: Text(
                                                        rangeTimeToString(
                                                            _activitiesByDay[
                                                                        index]![
                                                                    indexActivity]
                                                                .timeStart,
                                                            _activitiesByDay[
                                                                        index]![
                                                                    indexActivity]
                                                                .timeFinish),
                                                        //_activitiesByDay[index]![indexActivity].activity,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            GoogleFonts.barlow(
                                                          fontSize: 16.0,
                                                          wordSpacing: 1,
                                                          letterSpacing: 1.2,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                  Positioned(
                                                      top: 36,
                                                      bottom: 16,
                                                      left: 16,
                                                      child: Text(
                                                        _activitiesByDay[
                                                                    index]![
                                                                indexActivity]
                                                            .activity,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            GoogleFonts.barlow(
                                                          fontSize: 16.0,
                                                          wordSpacing: 1,
                                                          letterSpacing: 1.2,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                  Positioned(
                                                    top: 0,
                                                    right: 4,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      icon: Container(
                                                        width: 15,
                                                        height: 20,
                                                        decoration:
                                                            const BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/trash.png'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        addIsRemoved(
                                                            _activitiesByDay[
                                                                    index]![
                                                                indexActivity],
                                                            _days[index]);
                                                        controller.updateActivity(
                                                            _activitiesByDay[
                                                                    index]![
                                                                indexActivity]);
                                                        _activitiesByDay[index]!
                                                            .removeAt(
                                                                indexActivity);
                                                        setState(() {});
                                                        filterActivitiesByRangeDate();
                                                        updateActivitiesName();
                                                      },
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 36,
                                                      right: 4,
                                                      child: Transform.scale(
                                                          scale: 0.7,
                                                          child: FutureBuilder<
                                                                  bool>(
                                                              future: isDeactivated(
                                                                  _activitiesByDay[
                                                                          index]![
                                                                      indexActivity],
                                                                  _days[index]),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          bool>
                                                                      snapshot) {
                                                                return CupertinoSwitch(
                                                                  value: snapshot
                                                                          .hasData
                                                                      ? snapshot
                                                                          .data!
                                                                      : false,
                                                                  activeColor:
                                                                      ColorPalette
                                                                          .activeSwitch,
                                                                  trackColor:
                                                                      CupertinoColors
                                                                          .inactiveGray,
                                                                  onChanged: (bool
                                                                      value) {
                                                                    if (value) {
                                                                      addIsDeactivated(
                                                                          _activitiesByDay[index]![
                                                                              indexActivity],
                                                                          _days[
                                                                              index]);
                                                                    } else {
                                                                      removeIsDeactivated(
                                                                          _activitiesByDay[index]![
                                                                              indexActivity],
                                                                          _days[
                                                                              index]);
                                                                    }
                                                                    controller.updateActivity(
                                                                        _activitiesByDay[index]![
                                                                            indexActivity]);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                );
                                                              })))
                                                ],
                                              ),
                                            );
                                          })),
                                ],
                              );
                            })),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 32,
                left: 32,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(219, 177, 42, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 42,
                  child: Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size.fromWidth(300)),
                      child: Text('Añadir actividad',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      onPressed: () {
                        navigateToAddActivity(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> navigateToAddActivity(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityPage(),
      ),
    );

    if (mounted) {
      init();
    }
  }

  Widget getDayContainer(int index, Size size) {
    return Container(
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
          filterActivitiesByRangeDate();
          updateActivitiesName();
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
}

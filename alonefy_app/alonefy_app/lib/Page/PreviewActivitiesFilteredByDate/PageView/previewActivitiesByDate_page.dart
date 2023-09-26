import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Page/Calendar/calendarPopup.dart';
import 'package:ifeelefine/Page/FallDetected/Pageview/fall_activation_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification_center/notification_center.dart';

import '../../../Model/activityDay.dart';
import '../../AddActivityPage/Controller/addActivityController.dart';
import '../../AddActivityPage/PageView/addActivity_page.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class PreviewActivitiesByDate extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const PreviewActivitiesByDate({Key? key, required this.isMenu})
      : super(key: key);

  final bool isMenu;

  @override
  State<PreviewActivitiesByDate> createState() =>
      _PreviewActivitiesByDateState();
}

class _PreviewActivitiesByDateState extends State<PreviewActivitiesByDate>
    with WidgetsBindingObserver {
  final AddActivityController controller = Get.put(AddActivityController());
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<bool> _selectedDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  DateTime _from = DateTime.now();
  DateTime _to = DateTime.now();

  var _rangeDateText = "";

  var _activitiesNameText = "";

  final List<DateTime> _days = [];
  List<ActivityDay> _activities = [];
  final Map<int, List<ActivityDay>> _activitiesByDay =
      <int, List<ActivityDay>>{};
  final PreferenceUser _prefs = PreferenceUser();
  @override
  void initState() {
    super.initState();
    if (widget.isMenu == false) {
      _prefs.saveLastScreenRoute("previewActivity");

      List<String>? temp = [];
      Future.sync(() async => {
            temp = await _prefs.getlistConfigPage,
            temp!.add("previewActivity"),
            _prefs.setlistConfigPage = temp!
          });
    }

    starTap();
    WidgetsBinding.instance.addObserver(this);
    _from = DateTime(_from.year, _from.month, _from.day);
    _to = DateTime(_to.year, _to.month, _to.day);
    init();
    updateRangeDateTextSelected();
    NotificationCenter()
        .subscribe('refreshPreviewActivities', refreshPreviewActivities);

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant PreviewActivitiesByDate oldWidget) {
    // TODO: implement didUpdateWidget
    _from = DateTime(_from.year, _from.month, _from.day);
    _to = DateTime(_to.year, _to.month, _to.day);
    NotificationCenter()
        .subscribe('refreshPreviewActivities', refreshPreviewActivities);

    super.didUpdateWidget(oldWidget);
  }

  Future refreshPreviewActivities() async {
    setState(() {
      init();
    });
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

    daysBetweenToAndFrom = daysBetween(_from, _to);

    for (var index = 0; index <= daysBetweenToAndFrom; index++) {
      var currentDate = DateTime(_from.year, _from.month, _from.day + index);

      List<ActivityDay> activitiesByDay = [];

      for (var activity in _activities) {
        //var tempActivity = controller.clone(activity);
        print(activity.day);
        var startDateTemp = "";
        if (activity.day.contains('-')) {
          startDateTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
        } else {
          startDateTemp = activity.day;
        }

        var toTemp = Jiffy(_to.toString()).format('EEEE, d MMMM yyyy');

        var fromTemp = Jiffy(_to.toString()).format('EEEE, d MMMM yyyy');
        var endDate = '';
        if (activity.dayFinish.contains('-')) {
          endDate = Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
        } else {
          endDate = activity.dayFinish;
        }

        // Comprobar si la fecha actual (currentDate) está dentro del rango de fechas de la activity
        if (Jiffy(endDate, 'EEEE, d MMMM yyyy')
                .isBefore(Jiffy(fromTemp, 'EEEE, d MMMM yyyy')) ||
            Jiffy(startDateTemp, 'EEEE, d MMMM yyyy')
                .isAfter(Jiffy(toTemp, 'EEEE, d MMMM yyyy'))) {
          switch (activity.repeatType) {
            case Constant.onceTime:
              var startDateTemp = "";
              if (activity.day.contains('-')) {
                startDateTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
              } else {
                startDateTemp = activity.day;
              }

              var onceDate = Jiffy(startDateTemp, getDefaultPattern()).dateTime;
              if (onceDate.year == currentDate.year &&
                  onceDate.month == currentDate.month &&
                  onceDate.day == currentDate.day &&
                  isFilteredDayValid(onceDate)) {
                activitiesByDay.add(activity);
              }
              break;
            case Constant.diary:
              var startDateTemp = "";
              if (activity.day.contains('-')) {
                startDateTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
              } else {
                startDateTemp = activity.day;
              }
              var endDate = '';
              if (activity.dayFinish.contains('-')) {
                endDate = Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
              } else {
                endDate = activity.dayFinish;
              }

              // var dayFinish = Jiffy(activity.day, 'EEEE, d MMMM yyyy');
              var diaryStartDate =
                  Jiffy(startDateTemp, getDefaultPattern()).dateTime;
              var diaryEndDate = Jiffy(endDate, getDefaultPattern()).dateTime;

              if (!diaryStartDate.isAfter(currentDate) &&
                  !diaryEndDate.isBefore(currentDate) &&
                  isFilteredDayValid(currentDate)) {
                activitiesByDay.add(activity);
              }
              break;
            case Constant.weekly:
              if (activity.days != null && activity.days!.isNotEmpty) {
                var daysRepeated = activity.days!.split(';');
                for (var day in daysRepeated) {
                  var startDateTemp = "";
                  if (activity.day.contains('-')) {
                    startDateTemp =
                        Jiffy(activity.day).format('EEEE, d MMMM yyyy');
                  } else {
                    startDateTemp = activity.day;
                  }
                  var endDate = '';
                  if (activity.dayFinish.contains('-')) {
                    endDate =
                        Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
                  } else {
                    endDate = activity.dayFinish;
                  }
                  // var endDate =
                  //     Jiffy(activity.day).format('EEEE, d MMMM yyyy');
                  // var dayFinish =
                  //     Jiffy(dayFinishTemp).format('EEEE, d MMMM yyyy');

                  var weeklyStartDate =
                      Jiffy(startDateTemp, getDefaultPattern()).dateTime;

                  var weeklyEndDate =
                      Jiffy(endDate, getDefaultPattern()).dateTime;

                  if (!weeklyStartDate.isAfter(currentDate) &&
                          !weeklyEndDate.isBefore(currentDate) &&
                          isFilteredDayValid(currentDate) ||
                      activity.repeatType == 'Semanal') {
                    for (var index = 0;
                        index <= Constant.tempListShortDay.length;
                        index++) {
                      if (currentDate.weekday == (index + 1) &&
                          day == Constant.tempListShortDay[index]) {
                        activitiesByDay.add(activity);
                        break;
                      }
                    }
                  }
                }
              }
              break;
            case Constant.monthly:
              var startDateTemp = "";
              if (activity.day.contains('-')) {
                startDateTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
              } else {
                startDateTemp = activity.day;
              }
              var endDate = '';
              if (activity.dayFinish.contains('-')) {
                endDate = Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
              } else {
                endDate = activity.dayFinish;
              }
              // var dayFinishTemp = Jiffy(activity.dayFinish, 'EEEE, d MMMM yyyy');
              var monthlyStartDate =
                  Jiffy(startDateTemp, getDefaultPattern()).dateTime;

              var monthlyEndDate = Jiffy(endDate, getDefaultPattern()).dateTime;

              if (!monthlyStartDate.isAfter(currentDate) &&
                  !monthlyEndDate.isBefore(currentDate) &&
                  isFilteredDayValid(currentDate)) {
                if (monthlyStartDate.day == currentDate.day) {
                  activitiesByDay.add(activity);
                }
              }
              break;
            case Constant.yearly:
              var startDateTemp = "";
              if (activity.day.contains('-')) {
                startDateTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
              } else {
                startDateTemp = activity.day;
              }
              var endDate = '';
              if (activity.dayFinish.contains('-')) {
                endDate = Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
              } else {
                endDate = activity.dayFinish;
              }
              var yearlyStartDate =
                  Jiffy(startDateTemp, getDefaultPattern()).dateTime;
              var yearlyEndDate = Jiffy(endDate, getDefaultPattern()).dateTime;

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
        } else {
          var isDayRemoved = false;

          // Recopilar días borrados. Comprobar si currentDate es un día borrado
          if (activity.specificDaysRemoved != null &&
              activity.specificDaysRemoved!.isNotEmpty) {
            var daysRemoved = activity.specificDaysRemoved!.split(';');

            for (var dayRemoved in daysRemoved) {
              if (dayRemoved == "[]") {
                continue;
              }
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
              case Constant.onceTime:
                var dayTemp = "";
                if (activity.day.contains('-')) {
                  dayTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
                } else {
                  dayTemp = activity.day;
                }

                var onceDate = Jiffy(dayTemp, getDefaultPattern()).dateTime;
                if (onceDate.year == currentDate.year &&
                    onceDate.month == currentDate.month &&
                    onceDate.day == currentDate.day &&
                    isFilteredDayValid(onceDate)) {
                  activitiesByDay.add(activity);
                }
                break;
              case Constant.diary:
                var dayTemp = "";
                if (activity.day.contains('-')) {
                  dayTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
                } else {
                  dayTemp = activity.day;
                }

                var dayFinishTemp = "";
                if (activity.day.contains('-')) {
                  dayFinishTemp =
                      Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
                } else {
                  dayFinishTemp = activity.dayFinish;
                }

                // var dayFinish = Jiffy(activity.day, 'EEEE, d MMMM yyyy');
                var diaryStartDate =
                    Jiffy(dayTemp, getDefaultPattern()).dateTime;
                var diaryEndDate =
                    Jiffy(dayFinishTemp, getDefaultPattern()).dateTime;

                if (!diaryStartDate.isAfter(currentDate) &&
                    !diaryEndDate.isBefore(currentDate) &&
                    isFilteredDayValid(currentDate)) {
                  activitiesByDay.add(activity);
                }
                break;
              case Constant.weekly:
                if (activity.days != null && activity.days!.isNotEmpty) {
                  var daysRepeated = activity.days!.split(';');
                  for (var day in daysRepeated) {
                    var dayTemp = "";
                    if (activity.day.contains('-')) {
                      dayTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
                    } else {
                      dayTemp = activity.day;
                    }

                    var dayFinishTemp = "";
                    if (activity.day.contains('-')) {
                      dayFinishTemp =
                          Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
                    } else {
                      dayFinishTemp = activity.dayFinish;
                    }

                    var weeklyStartDate =
                        Jiffy(dayTemp, getDefaultPattern()).dateTime;

                    var weeklyEndDate =
                        Jiffy(dayFinishTemp, getDefaultPattern()).dateTime;

                    if (!weeklyStartDate.isAfter(currentDate) &&
                            !weeklyEndDate.isBefore(currentDate) &&
                            isFilteredDayValid(currentDate) ||
                        activity.repeatType == 'Semanal') {
                      for (var index = 0;
                          index <= Constant.tempListShortDay.length;
                          index++) {
                        if (currentDate.weekday == (index + 1) &&
                            day == Constant.tempListShortDay[index]) {
                          activitiesByDay.add(activity);
                          break;
                        }
                      }
                    }
                  }
                }
                break;
              case Constant.monthly:
                var dayTemp = "";
                if (activity.day.contains('-')) {
                  dayTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
                } else {
                  dayTemp = activity.day;
                }

                var dayFinishTemp = "";
                if (activity.day.contains('-')) {
                  dayFinishTemp =
                      Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
                } else {
                  dayFinishTemp = activity.dayFinish;
                }
                // var dayFinishTemp = Jiffy(activity.dayFinish, 'EEEE, d MMMM yyyy');
                var monthlyStartDate =
                    Jiffy(dayTemp, getDefaultPattern()).dateTime;

                var monthlyEndDate =
                    Jiffy(dayFinishTemp, getDefaultPattern()).dateTime;

                if (!monthlyStartDate.isAfter(currentDate) &&
                    !monthlyEndDate.isBefore(currentDate) &&
                    isFilteredDayValid(currentDate)) {
                  if (monthlyStartDate.day == currentDate.day) {
                    activitiesByDay.add(activity);
                  }
                }
                break;
              case Constant.yearly:
                var dayTemp = "";
                if (activity.day.contains('-')) {
                  dayTemp = Jiffy(activity.day).format('EEEE, d MMMM yyyy');
                } else {
                  dayTemp = activity.day;
                }

                var dayFinishTemp = "";
                if (activity.day.contains('-')) {
                  dayFinishTemp =
                      Jiffy(activity.dayFinish).format('EEEE, d MMMM yyyy');
                } else {
                  dayFinishTemp = activity.dayFinish;
                }
                var yearlyStartDate =
                    Jiffy(dayTemp, getDefaultPattern()).dateTime;
                var yearlyEndDate =
                    Jiffy(dayFinishTemp, getDefaultPattern()).dateTime;

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

    var response = true;

    if (activityDay.specificDaysDeactivated != null &&
        activityDay.specificDaysDeactivated!.isNotEmpty) {
      var specifyDaysDeactivated =
          activityDay.specificDaysDeactivated!.split(';');

      for (var specifyDayDeactivated in specifyDaysDeactivated) {
        var dayTemp = "";
        if (specifyDayDeactivated.contains('-')) {
          dayTemp = Jiffy(specifyDayDeactivated).format('EEEE, d MMMM yyyy');
        } else {
          dayTemp = specifyDayDeactivated;
        }

        var specifyDayDateTime = Jiffy(dayTemp, getDefaultPattern()).dateTime;

        if (specifyDayDateTime.year == dateTime.year &&
            specifyDayDateTime.month == dateTime.month &&
            specifyDayDateTime.day == dateTime.day) {
          response = false;
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
    _from = rangeDateTime.from!;
    _to = (rangeDateTime.to ?? rangeDateTime.from)!;
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
        activitiesName += "${activity.activity};";
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
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: widget.isMenu
          ? AppBar(
              backgroundColor: Colors.brown,
              title: Text(
                "Configuración",
                style: textForTitleApp(),
              ),
            )
          : null,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
            decoration: decorationCustom(),
            width: size.width,
            height: size.height,
            child: SafeArea(
              child: SizedBox(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 34),
                        const WidgetLogoApp(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 10, 32, 0),
                          child: Text(
                              "¿En que actividades no utilizas tu smartphone?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                height: 2,
                                fontSize: 24.0,
                                wordSpacing: 1,
                                letterSpacing: 0.001,
                                fontWeight: FontWeight.w500,
                                color: ColorPalette.principal,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: Text(
                            _activitiesNameText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 14.0,
                              wordSpacing: 1,
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.w500,
                              color: ColorPalette.offWhite,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var rangeDateTime = await showCalendar(context);

                            if (rangeDateTime != null) {
                              updateRangeDateTime(rangeDateTime);
                              filterActivitiesByRangeDate();
                              updateRangeDateTextSelected();
                              updateActivitiesName();
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  iconSize: 24,
                                  color: ColorPalette.principal,
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
                                  icon: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/Arrow2-Left.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
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
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      height: 60,
                                      color: Colors.transparent,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Container(
                                          width: 200,
                                          color: Colors.transparent,
                                          child: Text(
                                            _rangeDateText,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.barlow(
                                              fontSize: 16.0,
                                              wordSpacing: 1,
                                              letterSpacing: 0.001,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                  iconSize: 24,
                                  color: ColorPalette.principal,
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
                                  icon: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/Arrow2-Right.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              getDayContainer(0, size),
                              getDayContainer(1, size),
                              getDayContainer(2, size),
                              getDayContainer(3, size),
                              getDayContainer(4, size),
                              getDayContainer(5, size),
                              getDayContainer(6, size),
                              const SizedBox(width: 16)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                16, 24, 16, widget.isMenu ? 100 : 150),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 4, 0, 0),
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
                                          var listactiv =
                                              _activitiesByDay[index];
                                          var activi =
                                              listactiv![indexActivity];
                                          return Container(
                                            height: 80,
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 0),
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorPalette.itemActivity,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    top: 16,
                                                    left: 16,
                                                    child: Text(
                                                      "${activi.timeStart.substring(0, activi.timeStart.length - 3)}-${activi.timeFinish.substring(0, activi.timeFinish.length - 3)}",
                                                      // rangeTimeToString(
                                                      // activi.timeStart,
                                                      // activi.timeFinish),
                                                      //_activitiesByDay[index]![indexActivity].activity,
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.barlow(
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
                                                      _activitiesByDay[index]![
                                                              indexActivity]
                                                          .activity,
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.barlow(
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
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/trash.png'),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      // addIsRemoved(
                                                      //     _activitiesByDay[
                                                      //             index]![
                                                      //         indexActivity],
                                                      //     _days[index]);

                                                      controller.deleteActivity(
                                                          _activitiesByDay[
                                                                  index]![
                                                              indexActivity]);

                                                      _activitiesByDay[index]!
                                                          .removeAt(
                                                              indexActivity);

                                                      // filterActivitiesByRangeDate();
                                                      // updateActivitiesName();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 36,
                                                  right: 4,
                                                  child: Transform.scale(
                                                    scale: 0.7,
                                                    child: FutureBuilder<bool>(
                                                      future: isDeactivated(
                                                          _activitiesByDay[
                                                                  index]![
                                                              indexActivity],
                                                          _days[index]),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshot) {
                                                        return CupertinoSwitch(
                                                          value: snapshot
                                                                  .hasData
                                                              ? snapshot.data!
                                                              : false,
                                                          activeColor:
                                                              ColorPalette
                                                                  .activeSwitch,
                                                          trackColor:
                                                              CupertinoColors
                                                                  .inactiveGray,
                                                          onChanged:
                                                              (bool value) {
                                                            _activitiesByDay[
                                                                        index]![
                                                                    indexActivity]
                                                                .isDeactivate = value;
                                                            if (value) {
                                                              addIsDeactivated(
                                                                  _activitiesByDay[
                                                                          index]![
                                                                      indexActivity],
                                                                  _days[index]);
                                                            } else {
                                                              removeIsDeactivated(
                                                                  _activitiesByDay[
                                                                          index]![
                                                                      indexActivity],
                                                                  _days[index]);
                                                            }
                                                            if (_activitiesByDay[
                                                                            index]![
                                                                        indexActivity]
                                                                    .timeStart
                                                                    .length <=
                                                                5) {
                                                              _activitiesByDay[
                                                                          index]![
                                                                      indexActivity]
                                                                  .timeStart = _activitiesByDay[
                                                                              index]![
                                                                          indexActivity]
                                                                      .timeStart +
                                                                  ":00";

                                                              _activitiesByDay[
                                                                          index]![
                                                                      indexActivity]
                                                                  .timeFinish = _activitiesByDay[
                                                                              index]![
                                                                          indexActivity]
                                                                      .timeFinish +
                                                                  ":00";
                                                            }

                                                            controller.updateActivity(
                                                                _activitiesByDay[
                                                                        index]![
                                                                    indexActivity]);
                                                            controller.updateActivityApi(
                                                                _activitiesByDay[
                                                                        index]![
                                                                    indexActivity]);

                                                            setState(() {});
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: widget.isMenu ? 20 : 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.isMenu
                              ? Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(219, 177, 42, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  width: 200,
                                  height: 42,
                                  child: Center(
                                    child: TextButton(
                                      child: Text(
                                        Constant.addActivity,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.barlow(
                                          fontSize: 16.0,
                                          wordSpacing: 1,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      onPressed: () {
                                        navigateToAddActivity(context);
                                      },
                                    ),
                                  ),
                                )
                              : ElevateButtonFilling(
                                  mensaje: Constant.addActivity,
                                  showIcon: false,
                                  onChanged: (bool value) async {
                                    print(value);
                                    navigateToAddActivity(context);
                                  },
                                  img: '',
                                ),
                        ],
                      ),
                    ),
                    if (!widget.isMenu) ...[
                      Positioned(
                        bottom: 10,
                        right: 32,
                        left: 32,
                        child: ElevateButtonFilling(
                          mensaje: Constant.continueTxt,
                          showIcon: false,
                          onChanged: (bool value) async {
                            print(value);

                            Get.offAll(const FallActivationPage());
                            // await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         const FallActivationPage(),
                            //   ),
                            // );
                          },
                          img: '',
                        ),
                      )
                    ],
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<void> navigateToAddActivity(BuildContext context) async {
    setState(() {});
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddActivityPage(isMenu: widget.isMenu, from: _from, to: _to),
      ),
    );

    if (mounted) {
      init();
    }
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
                    : index == 5 || index == 6
                        ? Colors.red
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
          Constant.tempListShortDay[index],
          textAlign: TextAlign.center,
          style: GoogleFonts.barlow(
            fontSize: _selectedDays[index] ? 18 : 16.0,
            wordSpacing: 1,
            letterSpacing: 1,
            fontWeight:
                _selectedDays[index] ? FontWeight.bold : FontWeight.normal,
            color: _selectedDays[index]
                ? Colors.black
                : index == 5 || index == 6
                    ? Colors.red
                    : Colors.white,
          ),
        ),
      )),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/Alerts/Widget/alert_list_group_widget.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/main.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final PreferenceUser _prefs = PreferenceUser();
  final AlertsController alertsVC = Get.put(AlertsController());

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late List<LogAlertsBD> listLog;
  bool _isLoading = true;

  RxMap<String, Map<String, List<LogAlertsBD>>> newGroup =
      RxMap<String, Map<String, List<LogAlertsBD>>>();

  Future<void> getLog() async {
    newGroup = await alertsVC.getAllMov2();
    newGroup.values;

    _isLoading = false;
    setState(() {});
  }

  Future<void> deleteForDayMov(
      BuildContext context, List<LogAlertsBD> listLog) async {
    var req = await alertsVC.deleteAlerts(context, listLog);
    if (req == 0) {
      setState(() {});
      getLog();
    }
  }

  Future<void> onRefresh(bool value) async {
    alertsVC.update();
    mainController.refreshHome();
    setState(() {});
  }

    Future<void> validateNotificationsBg() async {
    await _prefs.refreshData();
    List<String> notificationsBg = _prefs.getNotificationsToSave;
    if (notificationsBg.isNotEmpty) {
      for (String notification in notificationsBg) {
        Map<String, dynamic> notificationMap = jsonDecode(notification);
        var msg = notificationMap['message'];
        var time = DateTime.parse(notificationMap['time']);
        var group = notificationMap['group'];
        var log = await mainController.getAlertBy(msg, time);
        if (!log) {
          await mainController.saveUserLog(msg, time, group);
        }
      }
      _prefs.setNotificationsToSave = [];
      await _prefs.refreshData();
    } else {
      print("no hay notificaciones por guardar!!!!!!");
    }

    getLog();
    starTap();
  }


  Future<void> cancelNotify() async {
    List<String> listTaskIds = _prefs.getlistTaskIdsCancel;
    if (listTaskIds.isEmpty) {
      listTaskIds = getTaskIdList(prefs.getCancelIdDate.toString());
    } else {
      listTaskIds = getTaskIdList(listTaskIds.first);
    }

    if (_prefs.getNotificationType.toString().contains('Cita')) {
      var contactRisk = await const HiveDataRisk().getcontactRiskbd;
      if (listTaskIds.isEmpty) {
        EditRiskController erisk = Get.put(EditRiskController());
        RiskController risk = Get.put(RiskController());
        var resp = await risk.getContactsRisk();
        ContactRiskBD tempcontact = initContactRisk();
        for (var temp in resp) {
          DateTime starTime = parseContactRiskDate(temp.timeinit);
          bool isafter = DateTime.now().isAfter(starTime);
          if (!temp.isActived &&
              temp.isprogrammed &&
              isafter &&
              temp.isFinishTime == false) {
            tempcontact = temp;
          }
        }

        var contactRiskTemp = tempcontact;

        if (contactRiskTemp.id != -1) {
          await erisk.updateContactRisk(contactRiskTemp);
        }

        return;
      }
      _prefs.saveLastScreenRoute("cancelDate");
      for (var element in contactRisk) {
        if (element.isActived || element.isFinishTime) {
          RedirectViewNotifier.onTapNotification(listTaskIds, (element.id));
        }
      }
      onRefresh(true);
      getLog();
      return;
    }
    if (_prefs.getNotificationType.toString().contains('Inactividad')) {
      await mainController.saveUserLog("Inactividad - Actividad detectada ",
          DateTime.now(), _prefs.getIdInactiveGroup);
    }
    if (_prefs.getNotificationType.toString().contains('Caida')) {
      await mainController.saveUserLog("Caida - Actividad detectada ",
          DateTime.now(), _prefs.getIdDropGroup);
    }
    _prefs.setEnableTimer = false;
    _prefs.setEnableTimerDrop = false;
    MainService().cancelAllNotifications(listTaskIds);
    _prefs.setNotificationType = "";
    // typeNotify = "";
    await flutterLocalNotificationsPlugin.cancel(_prefs.getNotificationId!);
    _prefs.setNotificationId = -1;
    onRefresh(true);
    getLog();
  }

  @override
  void initState() {
    // getLog();
    // starTap();
    validateNotificationsBg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    RedirectViewNotifier.setStoredContext(context);
    return LoadingIndicator(
      isLoading: _isLoading,
      child: WillPopScope(
        onWillPop: () async {
          // Aquí puedes ejecutar acciones personalizadas antes de volver atrás
          // Por ejemplo, mostrar un diálogo de confirmación
          starTap();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          key: scaffoldKey,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Colors.brown,
            title: Text(
              "Alertas",
              style: textForTitleApp(),
            ),
          ),
          body: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              decoration: decorationCustom2(),
              width: size.width,
              height: size.height,
              child: GetBuilder(
                  init: AlertsController(),
                  builder: (value) {
                    return AlertListWidget(
                      groupedAlerts: newGroup,
                      onChangedDelete: (List<LogAlertsBD> value) {
                        deleteForDayMov(context, value);
                      },
                      onCancelNotification: (value) {
                        cancelNotify();
                      },
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

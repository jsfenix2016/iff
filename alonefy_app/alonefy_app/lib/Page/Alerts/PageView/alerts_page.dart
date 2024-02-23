import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/Alerts/Widget/alert_list_group_widget.dart';

import 'package:ifeelefine/Utils/Widgets/loading_page.dart';

import 'package:notification_center/notification_center.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
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
    // groupedProducts.value = {};

    var req = await alertsVC.deleteAlerts(context, listLog);
    if (req == 0) {
      // NotificationCenter().notify('getAlerts');
      setState(() {});
      getLog();
    }
  }

  @override
  void initState() {
    getLog();
    starTap();
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
                      onRefresh: (bool value) {
                        alertsVC.update();

                        try {
                          NotificationCenter().notify('refreshView');
                        } catch (e) {
                          print(e);
                        }
                        setState(() {});
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

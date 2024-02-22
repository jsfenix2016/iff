import 'dart:async';
import 'dart:isolate';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/contentCode.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:notification_center/notification_center.dart';

class CancelDatePage extends StatefulWidget {
  const CancelDatePage({super.key, required this.taskIds});

  // final ContactRiskBD contactRisk;
  final List<String> taskIds;
  // final String timefinish;
  // final Timer useMobil;
  @override
  State<CancelDatePage> createState() => _CancelDatePageState();
}

class _CancelDatePageState extends State<CancelDatePage> {
  EditRiskController editVC = Get.put(EditRiskController());
  RiskController riskVC = Get.put(RiskController());

  String codeTemp = ',,,';
  var code = CodeModel();
  late ContactRiskBD contactRiskTemp;

  int secondsRemaining = 30; //5 minutes = 300 seconds

  bool isLoading = false;
  final PreferenceUser _prefs = PreferenceUser();
  bool _shouldReloadData = false;

  @override
  void dispose() {
    super.dispose();
    secondsRemaining = _prefs.getTimerCancelZone;
  }

  @override
  void initState() {
    // contactRiskTemp = widget.contactRisk;
    contactRiskTemp = initContactRisk();
    getcontactRisk();
    _prefs.saveLastScreenRoute("cancelDate");
    super.initState();
    starTap();
    var secondsRemaining1 = (_prefs.getTimerCancelZone);
    secondsRemaining = secondsRemaining1;
    TimerIsolate.start(); // Comenzar el temporizador al inicializar el widget
    TimerIsolate.timerStream.listen((seconds) {
      setState(() {
        countTimer.value = seconds;
      });
    });
  }

  void getcontactRisk() async {
    await _prefs.initPrefs();
    _prefs.refreshData();

    // Verificar si se necesita iniciar el temporizador
    if (!_prefs.getListDate && !_prefs.getCountFinish) {
      start();
    }

    // Obtener los contactos de riesgo
    var resp = await riskVC.getContactsRisk();

    // Buscar el primer contacto activo, programado o con tiempo de finalización
    int indexSelect = resp.indexWhere(
        (item) => item.isFinishTime || item.isActived || item.isprogrammed);

    if (indexSelect == -1) {
      // Si no se encuentra ningún contacto activo, programado o con tiempo de finalización, navegar a la página de inicio
      _prefs.saveLastScreenRoute("home");
      await Get.off(const HomePage());
      return;
    }

    // Obtener el contacto de riesgo seleccionado
    contactRiskTemp = resp[indexSelect];

    // Actualizar los campos de código con la información del contacto
    if (contactRiskTemp.code != ",,," && contactRiskTemp.code.isNotEmpty) {
      List<String> parts = contactRiskTemp.code.split(',');
      code.textCode1 = parts.length > 0 ? parts[0] : '';
      code.textCode2 = parts.length > 1 ? parts[1] : '';
      code.textCode3 = parts.length > 2 ? parts[2] : '';
      code.textCode4 = parts.length > 3 ? parts[3] : '';
    }

    // Actualizar los IDs de tareas canceladas
    taskdIds =
        widget.taskIds.isEmpty ? _prefs.getlistTaskIdsCancel : widget.taskIds;
    if (widget.taskIds.isNotEmpty) {
      _prefs.setlistTaskIdsCancel = widget.taskIds;
    }
  }

  Future<void> saveDate() async {
    setState(() {
      isLoading = true;
    });
    await _prefs.initPrefs();

    if (contactRiskTemp.code == codeTemp) {
      contactRiskTemp.isActived = false;
      contactRiskTemp.isprogrammed = false;
      contactRiskTemp.code = ",,,";
      contactRiskTemp.isFinishTime = false;

      bool res = false;
      if (contactRiskTemp.taskIds != null &&
          contactRiskTemp.taskIds!.isNotEmpty) {
        print(contactRiskTemp.taskIds!);
        MainService().cancelAllNotifications(contactRiskTemp.taskIds!);
      } else if (widget.taskIds.isNotEmpty) {
        print(contactRiskTemp.taskIds!);
        MainService().cancelAllNotifications(widget.taskIds);
        print(widget.taskIds);
      }

      _prefs.saveLastScreenRoute("home");

      if (contactRiskTemp.saveContact == false) {
        res = await editVC.deleteContactRisk(context, contactRiskTemp);
      } else {
        contactRiskTemp.finish = true;
        res = await editVC.updateContactRisk(contactRiskTemp);
      }

      if (res) {
        isLoading = false;

        // riskVC.update();
        // stopTimer();
        stop();
        mainController.saveUserLog(
            "Cita - cancelada", DateTime.now(), prefs.getIdDateGroup);
        _prefs.setTimerCancelZone = 30;
        secondsRemaining = 30;

        prefs.setCancelDate = true;
        prefs.setCancelIdDate = contactRiskTemp.id;
        _prefs.setListDate = false;
        await flutterLocalNotificationsPlugin.cancelAll();
        _prefs.setNotificationId = -1;
        _prefs.setNotificationType = "";
        mainController.refreshRiskList();
        mainController.refreshHome();
        mainController.refreshAlerts();
        await Get.offAll(() => const HomePage());
      }
    }
    isLoading = false;
  }

  static late Isolate _isolate;
  static late SendPort _sendPort;

  static void start() async {
    ReceivePort receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_startTimer, receivePort.sendPort);
    receivePort.listen((message) {
      // Manejar mensajes recibidos del isolate si es necesario
      print(message);
    });
  }

  static void _startTimer(SendPort sendPort) {
    _sendPort = sendPort;

    const oneSec = Duration(seconds: 1);
    int secondsRemaining = 30; // Inicializar el contador de tiempo

    Timer.periodic(oneSec, (Timer timer) {
      if (secondsRemaining < 1) {
        // Enviar mensaje al hilo principal
        _sendPort.send({'event': 'timerFinished'});
        timer.cancel(); // Cancelar el timer
      } else {
        // Decrementar el tiempo restante y enviar al hilo principal
        secondsRemaining -= 1;
        _sendPort.send(
            {'event': 'updateTimer', 'secondsRemaining': secondsRemaining});
      }
    });
  }

  static void stop() {
    if (_isolate != null) {
      _isolate.kill(priority: Isolate.immediate);
    }
    TimerIsolate.stop();
  }

  String get timerText {
    int minutes = (countTimer ~/ 60);
    int seconds = (countTimer.toInt() % 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LoadingIndicator(
      isLoading: isLoading,
      child: WillPopScope(
        onWillPop: () async {
          // Aquí puedes ejecutar acciones personalizadas antes de volver atrás
          // Por ejemplo, mostrar un diálogo de confirmación
          _prefs.setTimerCancelZone = secondsRemaining;
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Colors.brown,
            title: Text(
              "Finalizar cita",
              style: textForTitleApp(),
            ),
          ),
          body: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              height: size.height,
              decoration: decorationCustom(),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Stack(
                  children: [
                    SafeArea(
                      child: Container(
                        height: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, left: 8, right: 8),
                            child: Center(
                              child: Text(
                                "La hora programada para la finalización de tu cita de riesgo ha terminado",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.barlow(
                                  fontSize: 24.0,
                                  wordSpacing: 1,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 20, right: 8),
                                    child: Text(
                                      "Introduce tú clave de cancelación",
                                      textAlign: TextAlign.center,
                                      style: textNomral18White(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                          ContentCode(
                            code: code,
                            onChanged: (value) {
                              code = value;
                              codeTemp =
                                  '${value.textCode1},${value.textCode2},${value.textCode3},${value.textCode4}';
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevateButtonFilling(
                              showIcon: false,
                              onChanged: (value) {
                                saveDate();
                              },
                              mensaje: 'Cancelar alerta',
                              img: '',
                            ),
                          ),
                          if (contactRiskTemp.isFinishTime) ...[
                            Visibility(
                              visible: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    timerText,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.barlow(
                                      fontSize: 74.0,
                                      wordSpacing: 1,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: ColorPalette.principal,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ] else ...[
                            const SizedBox.shrink()
                          ],
                          contactRiskTemp.isFinishTime
                              ? Visibility(
                                  visible: true,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                        "Aunque se apague el smartphone, el servidor de AlertFriends ha registrado tu última ubicación y emitirá una alerta a tu contacto",
                                        textAlign: TextAlign.center,
                                        style: textNormal14White(),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimerIsolate {
  static late Isolate _isolate;
  static late SendPort _sendPort;
  static late StreamController<int> _timerStreamController;
  static late Stream<int> timerStream;

  static void start() async {
    _timerStreamController = StreamController<int>();
    timerStream = _timerStreamController.stream;

    ReceivePort receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_startTimer, receivePort.sendPort);
    receivePort.listen((message) {
      if (message is int) {
        _timerStreamController.add(message);
      }
    });
  }

  static void _startTimer(SendPort sendPort) {
    _sendPort = sendPort;

    const oneSec = Duration(seconds: 1);
    int secondsRemaining = 30; // Inicializar el contador de tiempo

    Timer.periodic(oneSec, (Timer timer) {
      if (secondsRemaining < 1) {
        _sendPort.send(
            0); // Enviar 0 al hilo principal cuando el temporizador llega a cero
        timer.cancel(); // Cancelar el temporizador
      } else {
        _sendPort.send(
            secondsRemaining); // Enviar el tiempo restante al hilo principal
        secondsRemaining -= 1; // Decrementar el tiempo restante
      }
    });
  }

  static void stop() {
    if (_isolate != null) {
      _isolate.kill(priority: Isolate.immediate);
    }
    _timerStreamController.close();
  }
}

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_system_ringtones/flutter_system_ringtones_platform_interface.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Provider/prefencesUser.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

final _prefs = PreferenceUser();

class RingTonePage extends StatefulWidget {
  const RingTonePage({super.key});

  @override
  State<RingTonePage> createState() => _RingTonePageState();
}

class _RingTonePageState extends State<RingTonePage>
    with WidgetsBindingObserver {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());

  bool isCheck = false;

  late User user;
  late bool istrayed;

  late Image imgNew;

  final formKey = GlobalKey<FormState>();
  final formKeyName = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  MethodChannel platform =
      const MethodChannel('dexterx.dev/flutter_local_notifications_example');
  List<Ringtone> ringtones = [];
  List<String> ringtonesTemp = [];
  // Map<String, String> ringTonesMap = {
  //   "el padrino peliculas": "elpadrinopeliculas",
  //   'rocky': "rocky",
  //   'freddy krueger viene porti': "freddykruegervieneporti1",
  //   'alarm with reverberation 30031': 'alarm1withreverberation30031',
  //   'alarm carorhome 62554': 'alarmcarorhome62554',
  //   'rocky': 'alarmclockshort6402',
  //   'pinkpanther':'ringtonespinkpanther',
  //   'biohazardalarm':'biohazardalarm143105',
  //   'civildefensesiren':'civildefensesiren128262',
  //   'clockalarm',
  //   'fanfaretrumpets6185',
  //   'friendrequest14878',
  //   'glockenspieltreasurevideogame6346',
  //   'indianajonesseriestv',
  //   'killbillsirena',
  //   'misionimposiblepeliculas',
  //   'notificationssound127856',
  //   'prettywoman',
  //   'psicosischuichuin',
  //   'psicosissuspenso',
  //   'puncharock161647',
  //   'ringtoneskillbillwhistle',
  //   'ringtonespinkpanther',
  // };
  List<String> ringtonesRaw = [
    "elpadrinopeliculas",
    "rocky",
    "freddykruegervieneporti1",
    'alarm1withreverberation30031',
    'alarmcarorhome62554',
    'alarmclockshort6402',
    'ringtonespinkpanther',
    'biohazardalarm143105',
    'civildefensesiren128262',
    'clockalarm',
    'fanfaretrumpets6185',
    'friendrequest14878',
    'glockenspieltreasurevideogame6346',
    'indianajonesseriestv',
    'killbillsirena',
    'misionimposiblepeliculas',
    'notificationssound127856',
    'prettywoman',
    'psicosischuichuin',
    'psicosissuspenso',
    'puncharock161647',
    'ringtoneskillbillwhistle',
    'ringtonespinkpanther',
  ];
  List<bool> ringtonesEnabled = [];

  bool isAudioPlayerPlaying = false;
  int indexAudioPlayer = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkStoragePermission();
    starTap();
    getRingtones();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  checkStoragePermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }

    switch (status) {
      case PermissionStatus.denied:
        _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.noAccepted;
        return false;
      case PermissionStatus.granted:
        _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.allow;
        return true;
      case PermissionStatus.restricted:
        _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.noAccepted;
        return false;
      case PermissionStatus.limited:
        _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.noAccepted;
        return true;
      case PermissionStatus.permanentlyDenied:
        _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.noAccepted;
        return false;
      case PermissionStatus.provisional:
        // TODO: Handle this case.
        break;
    }
    try {
      NotificationCenter().notify('refreshPermission');
    } catch (e) {
      print(e);
    }
    try {
      NotificationCenter().notify('refreshMenu');
    } catch (e) {
      print(e);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getRingtones() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    await Permission.scheduleExactAlarm.isDenied.then((value) {
      if (value) {
        Permission.scheduleExactAlarm.request();
      }
    });

    try {
      // final temp1 =
      //     await FlutterSystemRingtonesPlatform.instance.getNotifications();
      // final temp2 = await FlutterSystemRingtones.getRingtoneSounds();
      // final temp = await FlutterSystemRingtones.getAlarmSounds();
      //ringtones = temp;

      var count = 0;
      for (var element in ringtonesRaw) {
        if (_prefs.getNotificationAudio == element) {
          ringtonesEnabled.add(true);
        } else {
          ringtonesEnabled.add(false);
        }
        ringtonesTemp.add(element);
        // ringtones.add(element);
        count++;

        if (count == 10 && !_prefs.getUserPremium) break;
      }

      setState(() {});
    } catch (e) {
      debugPrint('Failed to get platform version');
    }

    if (!mounted) return;
  }

  Future<void> playNotificationSound(String soundResource) async {
    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notifications.initialize(initializationSettings);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      soundResource, soundResource,
      playSound: true,
      visibility: NotificationVisibility.public,
      importance: Importance.max,
      priority: Priority.high,

      groupKey: "testAudio",
      enableVibration: true,
      channelShowBadge: false,
      styleInformation: const BigTextStyleInformation(''),
      // fullScreenIntent: false,
      largeIcon: const DrawableResourceAndroidBitmap(
          '@drawable/logo_alertfriends_v2_background'),
      ticker: 'Nuevo mensaje recibido',
      audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
      sound: RawResourceAndroidNotificationSound(soundResource),
      // sound: UriAndroidNotificationSound(soundResource),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notifications.show(
        100, soundResource, 'Prueba de sonido', platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: false,
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.brown,
        title: Text(
          Constant.titleNavBar,
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 32,
                width: size.width,
                child: Center(
                  child: Text(
                    'Cambiar sonido notificación',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 22.0,
                      wordSpacing: 1,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 100),
                child: ListView.builder(
                  itemCount: ringtonesTemp.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                      leading: Transform.scale(
                        scale: 0.7,
                        child: const Image(
                          image: AssetImage("assets/images/audio_on.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      trailing: Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: ringtonesEnabled[index],
                          activeColor: ColorPalette.activeSwitch,
                          trackColor: CupertinoColors.inactiveGray,
                          onChanged: (bool? value) {
                            setState(() {
                              var count = 0;
                              for (var ringtoneEnableditem
                                  in ringtonesEnabled) {
                                ringtonesEnabled[count] = false;
                                count++;
                              }
                              ringtonesEnabled[index] = value!;
                            });
                          },
                        ),
                      ),
                      title: Text(
                          style: GoogleFonts.barlow(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: CupertinoColors.white,
                          ),
                          ringtonesTemp[index]),
                      //subtitle: Text(ringtones[index].uri),
                      onTap: () async {
                        if (indexAudioPlayer == index) {
                          // audioPlayer.pause();
                          indexAudioPlayer = -1;
                        } else {
                          Future.delayed(const Duration(seconds: 1), () {
                            // playNotificationSound(ringtones[index].uri);
                            playNotificationSound(ringtonesTemp[index]);
                          });
                          setState(() {});

                          indexAudioPlayer = index;
                        }
                      },
                    );
                  },
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
                      child: Text(Constant.saveBtn,
                          textAlign: TextAlign.center,
                          style: textBold16Black()),
                      onPressed: () async {
                        saveNotificationAudio();
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
                    border: Border.all(
                        color: const Color.fromRGBO(219, 177, 42, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 138,
                  height: 42,
                  child: Center(
                    child: TextButton(
                      child: Text(Constant.cancelBtn,
                          textAlign: TextAlign.center,
                          style: textNormal16White()),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveNotificationAudio() async {
    int selectedRingtoneIndex = -1;

    // Busca el índice de la primera notificación seleccionada
    for (int i = 0; i < ringtonesTemp.length; i++) {
      if (ringtonesEnabled[i]) {
        selectedRingtoneIndex = i;
        break;
      }
    }

    // Si se encontró un índice seleccionado
    if (selectedRingtoneIndex != -1) {
      _prefs.setNotificationAudio = ringtonesTemp[selectedRingtoneIndex];
    } else {
      _prefs.setNotificationAudio =
          ''; // Establece el tono de notificación en vacío
    }

    resetServicesBackground(); // Reinicia los servicios en segundo plano
  }
}

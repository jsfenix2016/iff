import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:flutter_system_ringtones/flutter_system_ringtones_platform_interface.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/main.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Provider/prefencesUser.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:flutter/services.dart' show MethodChannel, rootBundle;
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
    'clockalarm8761',
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

  AudioPlayer audioPlayer = AudioPlayer();
  bool isAudioPlayerPlaying = false;
  int indexAudioPlayer = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkStoragePermission();

    getRingtones();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.pause();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        audioPlayer.pause();
        break;
      case AppLifecycleState.paused:
        audioPlayer.pause();
        break;
      case AppLifecycleState.detached:
        break;
    }
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

    // ringtonesRaw = await fetchToneResources();
    print(ringtonesRaw);
    switch (status) {
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        return false;
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
      final temp1 =
          await FlutterSystemRingtonesPlatform.instance.getNotifications();
      final temp2 = await FlutterSystemRingtones.getRingtoneSounds();
      final temp = await FlutterSystemRingtones.getAlarmSounds();
      //ringtones = temp;

      var count = 0;
      for (var element in ringtonesRaw) {
        if (_prefs.getNotificationAudio == element) {
          ringtonesEnabled.add(true);
        } else {
          ringtonesEnabled.add(false);
        }
        ringtonesTemp.add(element);
        count++;

        if (count == 10 && !_prefs.getUserPremium) break;
      }

      setState(() {});
    } catch (e) {
      debugPrint('Failed to get platform version.');
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
      // fullScreenIntent: true,
      groupKey: "testAudio",
      styleInformation: const BigTextStyleInformation(''),
      fullScreenIntent: true,
      largeIcon:
          const DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
      ticker: 'Nuevo mensaje recibido',
      audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
      sound: RawResourceAndroidNotificationSound(soundResource),
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
      extendBodyBehindAppBar: false,
      key: scaffoldKey,
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
                    contentPadding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
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
                            for (var ringtoneEnabled in ringtonesEnabled) {
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
                        Future.delayed(const Duration(seconds: 8), () {
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
                    child: Text('Guardar',
                        textAlign: TextAlign.center, style: textBold16Black()),
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
                  border:
                      Border.all(color: const Color.fromRGBO(219, 177, 42, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                width: 138,
                height: 42,
                child: Center(
                  child: TextButton(
                    child: Text('Cancelar',
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
    );
  }

  void saveNotificationAudio() async {
    for (var i = 0; i <= ringtonesTemp.length; i++) {
      if (ringtonesEnabled[i]) {
        _prefs.setNotificationAudio = ringtonesTemp[i];

        final service = FlutterBackgroundService();
        var isRunning = await service.isRunning();
        if (isRunning) {
          service.invoke("stopService");
        }
        await service.startService();
        await activateService();
        break;
      }

      if (i == ringtonesTemp.length - 1) {
        _prefs.setNotificationAudio = '';
      }
    }
    // showSaveAlert(context, "Sonido notificación guardada",
    //     "El sonido para la notificación se ha guardado correctamente.");
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';

import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

import '../Provider/prefencesUser.dart';

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

  bool _guardado = false;

  late User user;
  late bool istrayed;

  late Image imgNew;

  final formKey = GlobalKey<FormState>();
  final formKeyName = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Ringtone> ringtones = [];
  List<bool> ringtonesEnabled = [];

  AudioPlayer audioPlayer = AudioPlayer();
  bool isAudioPlayerPlaying = false;
  int indexAudioPlayer = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getRingtones();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getRingtones() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final temp = await FlutterSystemRingtones.getRingtoneSounds();
      //ringtones = temp;

      var count = 0;
      for (var element in temp) {
        if (_prefs.getNotificationAudio == element.uri) {
          ringtonesEnabled.add(true);
        } else {
          ringtonesEnabled.add(false);
        }
        ringtones.add(element);
        count++;

        if (count == 10 && !_prefs.getUserPremium) break;
      }

      setState(() {});
    } catch (e) {
      debugPrint('Failed to get platform version.');
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundAppBar,
        title: const Text("Configuración"),
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
                  child: Text('Cambiar sonido notificación',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 22.0,
                        wordSpacing: 1,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 100),
                  child: ListView.builder(
                    itemCount: ringtones.length,
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
                            ringtones[index].title),
                        //subtitle: Text(ringtones[index].uri),
                        onTap: () {
                          if (indexAudioPlayer == index) {
                            audioPlayer.pause();
                            indexAudioPlayer = -1;
                          } else {
                            var audioUrl = UrlSource(ringtones[index].uri);
                            audioPlayer.play(audioUrl);
                            indexAudioPlayer = index;
                          }
                        },
                      );
                    },
                  ),
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
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
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
                    border: Border.all(color: Color.fromRGBO(219, 177, 42, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 138,
                  height: 42,
                  child: Center(
                    child: TextButton(
                      child: Text('Cancelar',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    audioPlayer.pause();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        audioPlayer.pause();
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        audioPlayer.pause();
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  void saveNotificationAudio() {
    for (var i = 0; i < ringtones.length; i++) {
      if (ringtonesEnabled[i]) {
        _prefs.setNotificationAudio = ringtones[i].uri;
        break;
      }

      if (i == ringtones.length - 1) {
        _prefs.setNotificationAudio = '';
      }
    }

    //showAlert();
    showSaveAlert(context, "Sonido notificación guardada",
        "El sonido para la notificación se ha guardado correctamente.");
  }

  void showAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sonido notificación guardada"),
            content: Text(
                "El sonido para la notificación se ha guardado correctamente."),
            actions: <Widget>[
              TextButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}

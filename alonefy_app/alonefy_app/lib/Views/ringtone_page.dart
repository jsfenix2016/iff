// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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

class RingTonePage extends StatefulWidget {
  const RingTonePage({super.key});

  @override
  State<RingTonePage> createState() => _RingTonePageState();
}

class _RingTonePageState extends State<RingTonePage> {
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

  @override
  void initState() {
    super.initState();

    getRingtones();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getRingtones() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final temp = await FlutterSystemRingtones.getRingtoneSounds();
      setState(() {
        ringtones = temp;
      });
    } catch (e) {
      debugPrint('Failed to get platform version.');
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Center(child: Text("Cambiar tono")),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: ListView.builder(
          itemCount: ringtones.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(ringtones[index].title),
              subtitle: Text(ringtones[index].uri),
              onTap: () {
                // FlutterRingtonePlayer.play(
                //   android: AndroidSounds.notification,
                //   ios: IosSounds.glass,
                //   looping: true,
                //   volume: 1.0,
                // );
                // FlutterRingtonePlayer.playRingtone();
                // FlutterRingtonePlayer.playAlarm();
                // FlutterRingtonePlayer.play(fromAsset: ringtones[index].uri);
                //  _flutterSystemRingtonesPlugin.playRingtone(ringtones[index]);
                // FlutterRingtonePlayer.play(
                //   fromAsset: '${ringtones[index]}.wav',
                //   android: AndroidSounds.ringtone,
                //   ios: IosSounds.glass,
                //   looping: true, // Android only - API >= 28
                //   volume: 1.0, // Android only - API >= 28
                //   asAlarm: false, // Android only - all APIs
                // );
                // FlutterRingtonePlayer.play(
                // fromAsset:
                //     "assets/sound/phone_20220908-111852_654268278.amr");
              },
            );
          },
        ),
      ),
    );
  }

  void _submit() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserRestPage()),
    );
  }
}





// Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('playAlarm'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.playAlarm();
                      //     },
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('playAlarm asAlarm: false'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.playAlarm(asAlarm: false);
                      //     },
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('playNotification'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.playNotification();
                      //     },
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('playRingtone'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.playRingtone();
                      //     },
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('Play from asset (iphone.mp3)'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.play(
                      //           fromAsset: "assets/iphone.mp3");
                      //     },
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('Play from asset (android.wav)'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.play(
                      //           fromAsset: "assets/android.wav");
                      //     },
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('play'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.play(
                      //         android: AndroidSounds.notification,
                      //         ios: IosSounds.glass,
                      //         looping: true,
                      //         volume: 1.0,
                      //       );
                      //     },
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     child: const Text('stop'),
                      //     onPressed: () {
                      //       FlutterRingtonePlayer.stop();
                      //     },
                      //   ),
                      // ),
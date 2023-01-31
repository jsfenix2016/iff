import 'dart:io';
import 'dart:async';

import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Utils/Widgets/customDropDown.dart';
import 'package:ifeelefine/Utils/Widgets/datepickerwidget.dart';
import 'package:ifeelefine/Views/protectuser_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';

// ignore: use_key_in_widget_constructors
class UserConfigPage2 extends StatefulWidget {
  @override
  State<UserConfigPage2> createState() => _UserConfigPageState2();
}

class _UserConfigPageState2 extends State<UserConfigPage2> {
  bool isCheck = false;

  bool _guardado = false;

  late bool istrayed;

  late Image imgNew;

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _picker = ImagePicker();
  var foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorPalette.principal,
        title: const Center(child: Text(Constant.personalInformation)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 10),

                    // _crearPais(),
                    CustomDropdownButtonWidgetWithDictionary(
                      instance: Constant.gender,
                      mensaje: Constant.selectGender,
                      isVisible: true,
                      onChanged: (value) {
                        print(value);
                      },
                    ),

                    Datepickerwidget(
                        date: DateTime.now(), onChange: (value) {}),

                    CustomDropdownButtonWidgetWithDictionary(
                      instance: Constant.maritalState,
                      mensaje: Constant.maritalStatus,
                      isVisible: true,
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    CustomDropdownButtonWidgetWithDictionary(
                      instance: Constant.lifeStyle,
                      mensaje: Constant.styleLive,
                      isVisible: true,
                      onChanged: (value) {
                        print(value);
                      },
                    ),

                    const SizedBox(height: 20),
                    _createButtonFree(),
                    _createButtonPremium(),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createBottom(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.remove_red_eye_outlined),
      backgroundColor: ColorPalette.principal,
      onPressed: () {
        //createPlantFoodNotification();
        Navigator.pushNamed(context, "preview", arguments: null);
      },
    );
  }

  Widget _crearTxtCodigoMail(String code) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: code,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: code,
                labelText: "Codigo correo",
              ),
              onSaved: (value) => value,
              validator: (value) {
                return "Ingresa un codigo correo";
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Expanded(
              flex: 0,
              child: IconButton(
                icon: Icon(Icons.check_circle_outline_sharp),
                onPressed: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearSmSTxtCodigoMail(String code) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: code,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: code,
                labelText: "Codigo sms",
              ),
              onSaved: (value) => value,
              validator: (value) {
                return "Ingresa un codigo sms";
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Expanded(
              flex: 0,
              child: IconButton(
                icon: Icon(Icons.check_circle_outline_sharp),
                onPressed: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearNombre(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        initialValue: name,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: name,
          labelText: "Nombre",
        ),
        onSaved: (value) => value,
        validator: (value) {
          return "Ingresa un nombre";
        },
      ),
    );
  }

  Widget _lastName(String lastName) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        initialValue: lastName,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: lastName,
          labelText: "Apellido",
        ),
        onSaved: (value) => value,
        validator: (value) {
          return "Ingresa un apellido";
        },
      ),
    );
  }

  Widget _telefono(String lastName) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        initialValue: lastName,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: lastName,
          labelText: "Telefono",
        ),
        onSaved: (value) => value,
        validator: (value) {
          return "Ingresa un telefono";
        },
      ),
    );
  }

//capturar imagen de la galeria de fotos
  Future getImageGallery(ImageSource origen) async {
    final XFile? image = await _picker.pickImage(source: origen);
    File file;
    // PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      file = File(image.path);
      // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        foto = file;
      });
    }
  }

  Widget _mostrarFoto() {
    if (foto != null) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(
              Radius.circular(25.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: DecorationImage(
            image: FileImage(foto, scale: 0.5),
            fit: BoxFit.fill,
          ),
        ),
      );
    } else {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(
              Radius.circular(25.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: const DecorationImage(
            image: AssetImage("assets/images/Group 97-new.png"),
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }

  Widget _createButtonFree() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Gratuito 30 dias"),
      icon: const Icon(
        Icons.security,
      ),
      onPressed: (_guardado) ? null : _submit,
    );
  }

  Widget _createButtonPremium() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Protección 360"),
      icon: const Icon(
        Icons.security,
      ),
      onPressed: (_guardado) ? null : _submit,
    );
  }

  Widget _crearBotonVerificate() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Verificar"),
      icon: const Icon(
        Icons.save,
      ),
      onPressed: (_guardado) ? null : _submit,
    );
  }

  void _submit() async {
    //if (!formKey.currentState.validate()) return;
    //formKey.currentState.save();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProtectUserPage()),
    );
  }
}

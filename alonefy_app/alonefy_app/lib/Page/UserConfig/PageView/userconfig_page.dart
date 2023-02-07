import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownMaritalState.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownStylelive.dart';
import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());
  bool isCheck = false;
  late bool selectImage = false;
  final bool _guardado = false;
  User? user;
  UserBD? userbd;
  late bool istrayed;

  late Image imgNew;

  final formKey = GlobalKey<FormState>();
  final formKeyName = GlobalKey<FormState>();
  final formKeyLastName = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _picker = ImagePicker();
  late File? foto = File("");

  var isValidEmail = false;
  var isValidSms = false;
  final List<String> _states = ["Seleccionar estado"];
  late String selectState = "";
  final List<String> _country = ["Seleccionar pais"];
  late String selectCountry = "";
  final String _selectedCountry = "Choose Country";
  Map<String, String> ages = {};
  @override
  void initState() {
    user = User(
        idUser: 0,
        name: "",
        lastname: "",
        email: "",
        telephone: "",
        gender: "",
        maritalStatus: "",
        styleLife: "",
        pathImage: "",
        age: '',
        country: '',
        city: '');
    super.initState();
    getUserData();
    _getAge();
    isValidEmail = userVC.validateEmail.isFalse;
    isValidSms = userVC.validateSms.isFalse;
  }

  Future<Map<String, String>> _getAge() async {
    ages = getAge();
    getCounty();
    return ages;
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');

    return jsonDecode(res);
  }

  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];
  Future getCounty() async {
    countryres = await getResponse() as List;
    for (var data in countryres) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) continue;
      setState(() {
        _country.add("${model.emoji!}  ${model.name!}");
      });
    }
    setState(() {});
    return _country;
  }

  Future filterState() async {
    for (var f in stateTemp) {
      if (!mounted) continue;
      f.forEach((data) {
        _states.add("${data['name']}");
      });
    }
    setState(() {});
    return _states;
  }

  Future getUserData() async {
    userbd = await userVC.getUserDate();
    if (userbd != null) {
      user = User(
          idUser: int.parse(userbd!.idUser),
          name: userbd!.name,
          lastname: userbd!.lastname,
          email: userbd!.email,
          telephone: userbd!.telephone,
          gender: userbd!.gender,
          maritalStatus: userbd!.maritalStatus,
          styleLife: userbd!.styleLife,
          pathImage: userbd!.pathImage,
          age: userbd!.age,
          country: user!.country,
          city: user!.city);
    }

    setState(() {});
  }

  Future<Image> getImage(String urlImage) async {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return imgNew = Image.memory(bytesImages,
        fit: BoxFit.cover, width: double.infinity, height: 250.0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromRGBO(115, 75, 24, 1),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromRGBO(115, 75, 24, 1),
        key: scaffoldKey,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   title: const Center(child: Text(Constant.personalInformation)),
        //   // actions: <Widget>[
        //   //   IconButton(
        //   //     icon: const Icon(Icons.photo_size_select_actual),
        //   //     onPressed: () {
        //   //       getImageGallery(ImageSource.gallery, context);
        //   //     },
        //   //   ),
        //   //   IconButton(
        //   //     icon: const Icon(Icons.camera_alt),
        //   //     onPressed: () {
        //   //       getImageGallery(ImageSource.camera, context);
        //   //     },
        //   //   ),
        //   // ],
        // ),
        body: SingleChildScrollView(
          child: Container(
            decoration: decorationCustom(),
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  // _mostrarFoto(),
                  // _mostrarFoto_2(),
                  const SizedBox(height: 50),
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      _crearNombre(""),
                      const SizedBox(height: 10),
                      _lastName(""),
                      const SizedBox(height: 10),
                      _telefono(""),
                      const SizedBox(height: 10),
                      _emailTxt(""),
                      const SizedBox(height: 10),
                      // Container(
                      //     color: Colors.red,
                      //     height: 100,
                      //     child: const ScheduleNotificationWidget()),
                      CustomDropdownMaritalState(
                        instance: Constant.gender,
                        mensaje: (userbd != null && userbd!.gender != "")
                            ? userbd!.gender
                            : Constant.selectGender,
                        isVisible: true,
                        onChanged: (value) {
                          user?.gender = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownMaritalState(
                        instance: Constant.maritalState,
                        mensaje: (userbd != null && userbd!.maritalStatus != "")
                            ? userbd!.maritalStatus
                            : Constant.maritalStatus,
                        isVisible: true,
                        onChanged: (value) {
                          user?.maritalStatus = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownStylelive(
                        instance: Constant.lifeStyle,
                        mensaje: (userbd != null && userbd!.styleLife != "")
                            ? userbd!.styleLife
                            : Constant.styleLive,
                        isVisible: true,
                        onChanged: (value) {
                          user?.styleLife = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: SizedBox(
                            height: 52,
                            child: DropdownButton<String?>(
                              underline: Container(),
                              hint: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (user != null && user!.age != "")
                                      ? user!.age
                                      : Constant.age,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: ColorPalette.principal),
                                ),
                              ),
                              dropdownColor: Colors.brown,
                              iconEnabledColor: ColorPalette.principal, //Ico
                              value: ages[0],
                              isExpanded: true,
                              items: ages.keys
                                  .toList()
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: ages[e],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          ages[e] ?? "",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: ColorPalette.principal),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                print(v);

                                user!.age = v.toString();
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: SizedBox(
                            height: 52,
                            child: DropdownButton<String?>(
                              underline: Container(),
                              dropdownColor: Colors.brown,
                              hint: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Selecciona el pais",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: ColorPalette.principal),
                                ),
                              ),
                              iconEnabledColor: ColorPalette.principal, //Ico
                              value: selectCountry.isEmpty
                                  ? _country[0]
                                  : selectCountry,
                              isExpanded: true,

                              items: _country
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: ColorPalette.principal),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                selectCountry = v!;
                                user?.country = v;
                                for (var element in countryres) {
                                  var model = StatusModel.StatusModel();
                                  model.name = element['name'];
                                  model.emoji = element['emoji'];
                                  if (!mounted) return;

                                  if (v.contains(
                                      ("${model.emoji!}  ${model.name!}"))) {
                                    stateTemp.add(element['state']);
                                  }
                                }
                                filterState();
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: SizedBox(
                            height: 52,
                            child: DropdownButton<String?>(
                              underline: Container(),
                              dropdownColor: Colors.brown,
                              hint: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Selecciona la ciudad",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorPalette.principal),
                                    ),
                                  ),
                                ),
                              ),
                              iconEnabledColor: ColorPalette.principal, //Ico
                              value: selectState.isEmpty
                                  ? _states[0]
                                  : selectState,
                              isExpanded: true,

                              items: _states
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: ColorPalette.principal),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                user?.city = v.toString();
                                selectState = v!;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ColorPalette.principal,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              height: 42,
                              width: 200,
                              child: Center(
                                child: Text(
                                  'Verificar',
                                  style: GoogleFonts.barlow(
                                    fontSize: 18.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              isValidSms = await userVC.validateSmsUser(context,
                                  int.parse(user!.telephone), user!.name);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _crearTxtCodigoMail(""),
                      const SizedBox(height: 20),
                      _crearSmSTxtCodigoMail(""),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                            onPressed: _submit,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: ColorPalette.principal,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                              ),
                              height: 42,
                              width: 200,
                              child: Center(
                                child: Text(
                                  'Configurar',
                                  style: GoogleFonts.barlow(
                                    fontSize: 18.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorPalette.principal),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: ColorPalette.principal), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  hintStyle: const TextStyle(color: ColorPalette.principal),
                  hintText: code,
                  labelText: Constant.codeEmail,
                  labelStyle: const TextStyle(color: ColorPalette.principal)),
              onSaved: (value) => value,
              validator: (value) {
                return Constant.codeEmailPlaceholder;
              },
              onChanged: (value) {},
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              icon: isValidEmail
                  ? const Icon(Icons.check_circle_outline_sharp)
                  : const Icon(Icons.check),
              onPressed: (() async => {
                    isValidEmail = await userVC.validateEmailUser(context),
                    if (isValidEmail == true) {setState(() {})}
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearSmSTxtCodigoMail(String code) {
    int num = 0;
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: code,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorPalette.principal),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: ColorPalette.principal), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  hintStyle: const TextStyle(color: ColorPalette.principal),
                  hintText: code,
                  labelText: Constant.codeSms,
                  labelStyle: const TextStyle(color: ColorPalette.principal)),
              onSaved: (value) => {num = int.parse(value!)},
              validator: (value) {
                return Constant.codeSmsPlaceholder;
              },
              onChanged: (value) {
                num = int.parse(value);
              },
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              icon: isValidSms
                  ? const Icon(Icons.check_circle_outline_sharp)
                  : const Icon(Icons.check),
              onPressed: (() async => {
                    if (isValidSms == true)
                      {(context as Element).markNeedsBuild()}
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearNombre(String name) {
    if (userbd != null) {
      name = userbd!.name;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Center(
        child: TextFormField(
          onChanged: (value) {
            user?.name = value;
          },
          style: const TextStyle(color: ColorPalette.principal),
          key: Key(name),
          initialValue: name,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorPalette.principal),
              borderRadius: BorderRadius.circular(100.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: ColorPalette.principal), //<-- SEE HERE
              borderRadius: BorderRadius.circular(100.0),
            ),
            hintStyle: const TextStyle(color: ColorPalette.principal),
            filled: true,
            hintText: name,
            labelText: Constant.nameUser,
            labelStyle: const TextStyle(color: ColorPalette.principal),
          ),
          onSaved: (value) => {
            user?.name = value!,
          },
          validator: (value) {
            return Constant.namePlaceholder;
          },
        ),
      ),
    );
  }

  Widget _lastName(String lastName) {
    if (userbd != null) {
      lastName = userbd!.lastname;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        onChanged: (valor) {
          user?.lastname = valor;
        },
        autofocus: false,
        key: Key(lastName),
        initialValue: userbd == null ? lastName : userbd?.lastname,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: userbd == null ? lastName : userbd?.lastname,
          labelText: Constant.lastName,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorPalette.principal),
            borderRadius: BorderRadius.circular(100.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
            borderRadius: BorderRadius.circular(100.0),
          ),
          hintStyle: const TextStyle(color: ColorPalette.principal),
          filled: true,
          labelStyle: const TextStyle(color: ColorPalette.principal),
        ),
        style: const TextStyle(color: ColorPalette.principal),
        onSaved: (value) => {
          user?.lastname = value!,
        },
      ),
    );
  }

  Widget _emailTxt(String email) {
    if (userbd != null) {
      email = userbd!.email;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        onChanged: (valor) {
          user!.email = valor;
        },
        autofocus: false,
        key: Key(email),
        initialValue: userbd == null ? email : userbd?.email,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: userbd == null ? email : userbd?.email,
          labelText: Constant.email,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorPalette.principal),
            borderRadius: BorderRadius.circular(100.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
            borderRadius: BorderRadius.circular(100.0),
          ),
          hintStyle: const TextStyle(color: ColorPalette.principal),
          filled: true,
          labelStyle: const TextStyle(color: ColorPalette.principal),
        ),
        style: const TextStyle(color: ColorPalette.principal),
        onSaved: (value) => {
          user!.email = value!,
        },
      ),
    );
  }

  Widget _telefono(String phone) {
    if (userbd != null) {
      phone = userbd!.telephone;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          user?.telephone = value;
        },
        key: Key(phone),
        initialValue: phone,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: phone,
          labelText: Constant.telephone,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorPalette.principal),
            borderRadius: BorderRadius.circular(100.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
            borderRadius: BorderRadius.circular(100.0),
          ),
          hintStyle: const TextStyle(color: ColorPalette.principal),
          filled: true,
          labelStyle: const TextStyle(color: ColorPalette.principal),
        ),
        style: const TextStyle(color: ColorPalette.principal),
        onSaved: (value) => {
          print(value),
          user?.telephone = value!,
        },
        validator: (value) {
          return Constant.telephonePlaceholder;
        },
      ),
    );
  }

//capturar imagen de la galeria de fotos
  Future getImageGallery(ImageSource origen, BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: origen);
    File file;
    if (image != null) {
      file = File(image.path);
      selectImage = true;
      setState(() {
        foto = file;
      });
    }
  }

  Widget _mostrarFoto_2() {
    if (userbd?.pathImage != null &&
        userbd?.pathImage != "" &&
        selectImage == false) {
      return FutureBuilder<Image>(
        future: getImage(userbd!.pathImage), // async work
        builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const FadeInImage(
                image: AssetImage("assets/images/icons8.png"),
                placeholder: AssetImage("assets/images/icons8.png"),
                height: 250.0,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            default:
              if (snapshot.hasError) {
                return Image.asset("assets/images/icons8.png",
                    width: double.infinity, height: 300.0);
              } else {
                return imgNew;
              }
          }
        },
      );
    }
    if (foto!.path != "") {
      return Image(
          fit: BoxFit.cover,
          image: FileImage(foto!, scale: 0.5),
          width: double.infinity,
          height: 250.0);
    } else {
      return Hero(
        tag: "imagen",
        child: Image.asset("assets/images/icons8.png",
            width: double.infinity, height: 250.0),
      );
    }
  }

  Widget _createButtonFree() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text(Constant.userConfigPageButtonFree),
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
      label: const Text(Constant.userConfigPageButtonConfig),
      icon: const Icon(
        Icons.settings,
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
    if (isValidSms == false) {
      mostrarAlerta(context, 'Debe verificar su numero de telefono');
      return;
    }

    // Uint8List? bytes;
    // String img64 = "";
    // if (foto?.path != "") {
    //   bytes = foto?.readAsBytesSync();
    //   img64 = base64Encode(bytes!);
    // } else {
    //   img64 = userbd!.pathImage;
    // }

    UserBD person = UserBD(
        idUser: '0',
        name: user!.name,
        lastname: user!.lastname,
        email: user!.email,
        telephone: user!.telephone,
        gender: user!.gender,
        maritalStatus: user!.maritalStatus,
        styleLife: user!.styleLife,
        pathImage: "",
        age: user!.age,
        country: user!.country,
        city: user!.city);

    int a = await userVC.saveUserData(context, person);

    if (a != -1) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Informacion"),
              content: Text("Datos guardados".tr),
              actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserRestPage()),
                    );
                  },
                )
              ],
            );
          });
    }
  }
}

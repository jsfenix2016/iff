import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Utils/Widgets/customDropDown.dart';
import 'package:ifeelefine/Utils/banner.dart';
import 'package:ifeelefine/Views/time_dream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_contacts/flutter_contacts.dart';

class ProtectUserPage extends StatefulWidget {
  const ProtectUserPage({super.key});

  @override
  State<ProtectUserPage> createState() => _ProtectUserPageState();
}

class _ProtectUserPageState extends State<ProtectUserPage> {
  List<Contact>? _contacts;

  bool _permissionDenied = false;
  int _activeCurrentStep = 0;

  void initPreference() async {}

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    super.initState();
    // _fetchContacts();
  }

  // Future _fetchContacts() async {
  //   if (!await FlutterContacts.requestPermission(readonly: true)) {
  //     setState(() => _permissionDenied = true);
  //   } else {
  //     final contacts = await FlutterContacts.getContacts();
  //     setState(() => _contacts = contacts);
  //   }
  // }

  List<Step> stepList() => [
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: const Text('Horas de uso del movil'),
          content: Center(
            child: Column(
              children: <Widget>[
                const Text(
                    'Durante el día, ¿Cada cuanto tiempo usas o coges tu movil?'),
                CustomDropdownButtonWidgetWithDictionary(
                  instance: Constant.timeDic,
                  mensaje: "select time",
                  isVisible: true,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ],
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 1,
          title: const Text('Horas descanzo'),
          content: Center(
            child: Column(
              children: <Widget>[
                const Divider(
                  height: 20,
                ),
                const Text('¿Cuantas horas sueles dormir de lunes a viernes?'),
                CustomDropdownButtonWidgetWithDictionary(
                  instance: Constant.timeDic,
                  mensaje: "select time",
                  isVisible: true,
                  onChanged: (value) {
                    print(value);
                  },
                ),
                const Divider(
                  height: 20,
                ),
                const Text('¿Cuantas horas sueles dormir de sabado a domingo?'),
                CustomDropdownButtonWidgetWithDictionary(
                  instance: Constant.timeDic,
                  mensaje: "select time",
                  isVisible: true,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ],
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 2,
          title: const Text('Confirmar horas de descanzo'),
          content: Center(
            child: Column(
              children: [
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text("Lunes"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: const Text('08:00'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onTap: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text("Martes"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: const Text('08:00'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onTap: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text("Miercoles"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: const Text('08:00'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onTap: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text("Jueves"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: const Text('08:00'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onTap: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text("Viernes"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: const Text('08:00'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onTap: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text("Sabado"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: const Text('08:00'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onTap: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text("Domingo"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: const Text('08:00'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onTap: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 3 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 3,
          title: const Text('Actividades en la semana'),
          content: Center(
            child: Column(
              children: <Widget>[
                const Text('¿Tienes actividades culturales en la semana?'),
                CustomDropdownButtonWidgetWithDictionary(
                  instance: Constant.weekend,
                  mensaje: "select day",
                  isVisible: true,
                  onChanged: (value) {
                    print(value);
                  },
                ),
                FloatingActionButton(
                  child: const Text('Add'),
                  onPressed: () {
                    addItemToList();
                  },
                ),
                Visibility(
                  visible: isVisible,
                  child: Container(
                    height: expandHeigth,
                    margin: const EdgeInsets.all(2),
                    color: Colors.blue[400],
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: tempList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          onDismissed: ((direction) => {
                                setState(() {
                                  tempList.removeAt(index);
                                  expandHeigth = expandHeigth - 60;
                                })
                              }),
                          key: UniqueKey(),
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.all(2),
                            child: Center(
                                child: Text(
                              '${tempList[index]}',
                              style: const TextStyle(fontSize: 18),
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 4 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 4,
          title: const Text('A que horas duermes'),
          content: Center(
            child: Column(
              children: <Widget>[
                const Text('A que hora te vas a dormir y despertar'),
                Visibility(
                  visible: true,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(0),
                    color: Colors.blue[400],
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(2),
                      itemCount: tempListDay.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            print(tempListDay[index]);
                            indexSelect = index;
                            setState(() {
                              if (isSelect == false) {
                                isSelect = true;
                                tempListDay.removeAt(index);
                              } else {
                                isSelect = false;
                              }
                              print(isSelect);
                            });
                            // Navigator.pushNamed(context, "product",
                            //     arguments: tempListDay[index]);
                          },
                          child: Dismissible(
                            onDismissed: ((direction) => {setState(() {})}),
                            key: UniqueKey(),
                            child: Container(
                              height: 50,
                              width: 37,
                              margin: const EdgeInsets.all(2),
                              child: Column(
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: index == indexSelect
                                            ? Colors.white
                                            : Colors.yellow,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        boxShadow: const <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3.0,
                                              offset: Offset(0.0, 5.0),
                                              spreadRadius: 3.0),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          tempListDay[index],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(0),
                    color: Colors.blue[400],
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(2),
                      itemCount: tempListDay.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            print(tempListDay[index]);
                            indexSelect = index;
                            setState(() {
                              if (isSelect == false) {
                                isSelect = true;
                                tempListDay.removeAt(index);
                              } else {
                                isSelect = false;
                              }
                              print(isSelect);
                            });
                            // Navigator.pushNamed(context, "product",
                            //     arguments: tempListDay[index]);
                          },
                          child: Dismissible(
                            onDismissed: ((direction) => {setState(() {})}),
                            key: UniqueKey(),
                            child: Container(
                              height: 50,
                              width: 37,
                              margin: const EdgeInsets.all(2),
                              child: Column(
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: index == indexSelect
                                            ? Colors.white
                                            : Colors.yellow,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        boxShadow: const <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3.0,
                                              offset: Offset(0.0, 5.0),
                                              spreadRadius: 3.0),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          tempListDay[index],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 5 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 5,
          title: const Text('A que horas duermes'),
          content: TimeDream(
            heigth: 600,
            onChanged: (value) {},
          ),
        ),
      ];

  Color colorSelect(int index) {
    isSelect == false ? Colors.white : Colors.yellow;
    return Colors.white;
  }

  var indexSelect = -1;
  final List<RestDay> tempDicRest = [];
  final List<int> tempList = <int>[];
  final List<int> tempListConfig = <int>[];
  final List<String> tempListDay = <String>[
    "L",
    "M",
    "M",
    "J",
    "V",
    "S",
    "D",
  ];
  var isSelect = false;
  // final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0];
  TextEditingController nameController = TextEditingController();
  var isVisible = false;
  var expandHeigth = 70.0;
  var expandHeigthDaySelect = 170.0;
  void addItemToList() {
    setState(() {
      if (isVisible) {
        expandHeigth = expandHeigth + 50;
      } else {
        isVisible = true;
        expandHeigth = 70;
      }

      tempList.insert(0, 0);
    });
  }

  void addToListDay() {
    setState(() {
      if (isVisible) {
        expandHeigthDaySelect = expandHeigthDaySelect + 50;
      } else {
        isVisible = true;
        expandHeigthDaySelect = 170;
      }

      tempListConfig.insert(0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Config. Actividades",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actionsIconTheme: const IconThemeData(color: Colors.grey, size: 36),
        actions: const [
          Icon(Icons.switch_account),
          Icon(Icons.add_alarm),
        ],
        leading: IconButton(
          icon:
              const Icon(Icons.menu, color: Colors.grey), // set your color here
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
            (context as Element).markNeedsBuild();
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Stepper(
            currentStep: _activeCurrentStep,
            steps: stepList(),
            onStepContinue: () {
              if (_activeCurrentStep < (stepList().length - 1)) {
                setState(() {
                  _activeCurrentStep += 1;
                });
              }
            },

            // onStepCancel takes us to the previous step
            onStepCancel: () {
              if (_activeCurrentStep == 0) {
                return;
              }

              setState(() {
                _activeCurrentStep -= 1;
              });
            },

            // onStepTap allows to directly click on the particular step we want
            onStepTapped: (int index) {
              setState(() {
                _activeCurrentStep = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30.0),
            width: size.width * 0.85,
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'titulo_login'.tr,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          TextButton(
            child: Text('new_user'.tr),
            onPressed: () => {},
          ),
          const SizedBox(
            height: 100.0,
          ),
          // const BannerCustom(),
        ],
      ),
    );
  }
}

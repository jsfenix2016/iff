import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final formKey = GlobalKey<FormState>();
  final formKeyName = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isValidEmail = false;
  var isValidSms = false;
  final List<String> tempListDay = <String>[
    "L",
    "M",
    "M",
    "J",
    "V",
    "S",
    "D",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: _createBottom(context),
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text("Alertas")),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: tempListDay.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {});
                  // Navigator.pushNamed(context, "product",
                  //     arguments: tempListDay[index]);
                },
                child: Dismissible(
                  background: Container(
                    color: Colors.red,
                    height: 80,
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        "Delete",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  onDismissed: ((direction) => {setState(() {})}),
                  key: UniqueKey(),
                  child: Container(
                    color: Colors.white,
                    height: 110,
                    width: size.width,
                    margin: const EdgeInsets.all(2),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 105,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
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
                        child: Stack(
                          children: [
                            Positioned(
                              left: -5,
                              top: 85 / 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width: 10,
                                height: 10,
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 25,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8.0),
                                child: Container(
                                  width: size.width,
                                  color: Colors.white,
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(Icons.add_alert),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            const Text(
                                              "Alarma activada",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const Text(
                                              "11:03h | 8/9/2022",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 110,
                                        ),
                                        const Icon(Icons.info),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

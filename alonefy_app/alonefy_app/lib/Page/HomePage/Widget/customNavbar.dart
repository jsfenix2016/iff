import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Page/Historial/PageView/historial_page.dart';
import 'package:ifeelefine/Page/LogActivity/PageView/logActivity_page.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/PageView/zoneRisk.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      bottom: -5,
      left: 0,
      child: Container(
        color: Colors.transparent,
        width: size.width,
        height: 130,
        child: Stack(
          children: [
            Container(
              height: 130,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/VectorNavBar.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.transparent,
              ),
            ),
            Center(
              heightFactor: 1,
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0.1,
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const RiskPage()),
                  // );
                },
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Group 880.png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              40.0) //                 <--- border radius here
                          ),
                      color: Colors.orange),
                  height: 60,
                  width: 60,
                ),
              ),
            ),
            Center(
              child: Container(
                color: Colors.transparent,
                height: 82,
                width: size.width,
                child: Center(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: size.width / 5,
                            color: Colors.transparent,
                            child: IconButton(
                              alignment: Alignment.topCenter,
                              iconSize: 70,
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 39,
                                    width: 35.7,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/alertas.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    Constant.history,
                                    textAlign: TextAlign.center,
                                    style: textNormal9White(),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistorialPage()),
                                );
                                // setBottomBarIndex(0);
                              },
                              splashColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: size.width / 5,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              alignment: Alignment.topCenter,
                              iconSize: 70,
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 39,
                                    width: 35.7,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/actividad 1.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    Constant.activity,
                                    textAlign: TextAlign.center,
                                    style: textNormal9White(),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LogActivityPage()),
                                );
                                // setBottomBarIndex(0);
                              },
                              splashColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width / 5.65,
                        color: Colors.transparent,
                        height: 85,
                      ),
                      Container(
                        width: size.width / 5,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              alignment: Alignment.topCenter,
                              iconSize: 70,
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 39,
                                    width: 35.7,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/cita-de-riesgo 1.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    Constant.dateRisk,
                                    textAlign: TextAlign.center,
                                    style: textNormal9White(),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RiskPage()),
                                );
                                // setBottomBarIndex(0);
                              },
                              splashColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width / 4.5,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              alignment: Alignment.topCenter,
                              iconSize: 70,
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 39,
                                    width: 35.7,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/zona-riesgo 1.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    Constant.zoneRisk,
                                    textAlign: TextAlign.center,
                                    style: textNormal9White(),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ZoneRiskPage()),
                                );
                                // setBottomBarIndex(0);
                              },
                              splashColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

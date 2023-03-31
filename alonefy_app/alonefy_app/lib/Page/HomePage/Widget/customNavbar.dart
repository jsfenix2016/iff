import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Page/LogActivity/PageView/logActivity_page.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/PageView/zoneRisk.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/Alerts/PageView/alerts_page.dart';
import 'package:ifeelefine/Views/menuconfig_page.dart';

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
      bottom: -1,
      left: 0,
      child: SizedBox(
        width: size.width,
        height: 90,
        child: Stack(
          children: [
            Container(
              height: 90,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RiskPage()),
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Group 880.png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              20.0) //                 <--- border radius here
                          ),
                      color: Colors.orange),
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              width: size.width,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 75,
                    height: 66,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 7,
                          top: 5,
                          child: Visibility(
                            visible: true,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          20.0) //                 <--- border radius here
                                      ),
                                  color: Colors.red),
                              height: 8,
                              width: 8,
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 61,
                          icon: Column(
                            children: [
                              Container(
                                height: 39,
                                width: 35.7,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/alertas.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  color: Colors.transparent,
                                ),
                              ),
                              Text(
                                "Historial",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.barlow(
                                  fontSize: 9.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MenuConfigurationPage()),
                            );
                            // setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 75,
                    height: 66,
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 61,
                      color: ColorPalette.principal,
                      onPressed: () async {
                        // setBottomBarIndex(2);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogActivityPage()),
                        );
                      },
                      icon: Column(
                        children: [
                          Container(
                            height: 39,
                            width: 35.7,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/actividad 1.png'),
                                fit: BoxFit.fill,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                          Text(
                            "Actividad",
                            style: GoogleFonts.barlow(
                              fontSize: 9.0,
                              wordSpacing: 1,
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 66,
                    color: Colors.transparent,
                  ),
                  Container(
                    width: 75,
                    height: 66,
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 61,
                      color: ColorPalette.principal,
                      onPressed: () {
                        // setBottomBarIndex(3);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RiskPage()),
                        );
                      },
                      icon: Column(
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
                            "Cita de riesgo",
                            style: GoogleFonts.barlow(
                              fontSize: 9.0,
                              wordSpacing: 1,
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 75,
                    height: 66,
                    color: Colors.transparent,
                    child: IconButton(
                      iconSize: 79,
                      color: ColorPalette.principal,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ZoneRiskPage()),
                        );
                        // setBottomBarIndex(4);
                      },
                      icon: Column(
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
                            "Zona de riesgo",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 9.0,
                              wordSpacing: 1,
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

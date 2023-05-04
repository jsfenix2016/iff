import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Page/ChangeNotificationTime/PageView/changeNotificationTime_page.dart';
import 'package:ifeelefine/Page/Disamble/Pageview/disambleIfeelfine_page.dart';
import 'package:ifeelefine/Page/EditUseMobil/Page/editUseMobil.dart';
import 'package:ifeelefine/Page/FallDetected/Pageview/fall_activation_config_page.dart';

import 'package:ifeelefine/Page/Geolocator/PageView/configGeolocator_page.dart';

import 'package:ifeelefine/Page/PreviewActivitiesFilteredByDate/PageView/previewActivitiesByDate_page.dart';
import 'package:ifeelefine/Page/RestoreMyConfiguration/PageView/restoreMyConfig_page.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';

import 'package:ifeelefine/Page/UserEdit/PageView/editUser_page.dart';

import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';

import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Views/contact_page.dart';
import 'package:ifeelefine/Views/geolocatos_test_page.dart';

import 'package:ifeelefine/Page/PermissionUser/Pageview/permission_page.dart';
import 'package:ifeelefine/Views/ringtone_page.dart';

class MenuConfigModel {
  late String name;
  late String icon;
  late double heigth;
  late double weigth;

  MenuConfigModel(this.name, this.icon, this.heigth, this.weigth);
}

class MenuConfigurationPage extends StatefulWidget {
  const MenuConfigurationPage({super.key});

  @override
  State<MenuConfigurationPage> createState() => _MenuConfigurationPageState();
}

class _MenuConfigurationPageState extends State<MenuConfigurationPage> {
  List<MenuConfigModel> permissionStatusI = [
    MenuConfigModel(
        "Configurar tus datos", 'assets/images/VectorUser.png', 22, 19.25),
    MenuConfigModel(
        "Configurar horas de sueño", 'assets/images/EllipseMenu.png', 22, 22),
    MenuConfigModel(
        "Configurar tiempo uso", 'assets/images/Group 1084.png', 22, 16.93),
    MenuConfigModel("Actividades", 'assets/images/Group 1084.png', 22, 16.93),
    MenuConfigModel("Seleccionar contacto de aviso",
        'assets/images/Group 1083.png', 22, 25.52),
    MenuConfigModel(
        "Configurar caída", 'assets/images/Group 506.png', 26, 22.76),
    MenuConfigModel(
        "Cambiar envío ubicación", 'assets/images/Group 1082.png', 24, 24),
    MenuConfigModel("Cambiar tiempo notificaciónes",
        'assets/images/Group 1099.png', 22, 17.15),
    MenuConfigModel("Cambiar sonido notificaciones",
        'assets/images/Group 1102.png', 22, 22.08),
    MenuConfigModel(
        "Ajustes de mi smartphone", 'assets/images/mobile.png', 22, 19.66),
    MenuConfigModel(
        "Restaurar mi configuración", 'assets/images/Vector-2.png', 22, 22),
    MenuConfigModel(
        "Desactivar mi instalación", 'assets/images/Group 533.png', 21, 17),
  ];

  @override
  void initState() {
    super.initState();
  }

  void redirectToConfigUser() {
    Route route = MaterialPageRoute(
      builder: (context) => const UserConfigPage(),
    );
    Navigator.pushReplacement(context, route);
  }

  void routeIndexSelect(int index) {
    final prefs = PreferenceUser();

    switch (index) {
      case 0:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserEditPage()),
        );
        break;
      case 1:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PreviewRestTimePage(
              isMenu: true,
            ),
          ),
        );
        break;

      case 2:
        // if (!prefs.isConfig) {
        //   redirectToConfigUser();
        //   return;
        // }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditUseMobilPage(),
          ),
        );
        break;
      case 3:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PreviewActivitiesByDate(),
          ),
        );
        break;
      case 4:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ContactList(
              isMenu: true,
            ),
          ),
        );
        break;
      case 5:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FallActivationConfigPage(),
          ),
        );
        break;
      case 6:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GeolocatorWidget(),
          ),
        );
        break;
      case 7:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfigGeolocator(
              isMenu: true,
            ),
          ),
        );
        break;
      case 8:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChangeNotificationTimePage(),
          ),
        );
        break;
      case 9:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RingTonePage(),
          ),
        );
        break;
      case 10:
        if (!prefs.isConfig) {
          redirectToConfigUser();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PermitionUserPage(),
          ),
        );
        break;
      case 11:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RestoreMyConfigPage(),
          ),
        );
        break;
      case 12:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DesactivePage(
              isMenu: true,
            ),
          ),
        );
        break;
      case 13:
        redirectToConfigUser();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 52, 22),
        title: const Text('Configuración'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, 1),
            colors: <Color>[
              ColorPalette.principalView,
              ColorPalette.secondView,
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            ListView.builder(
              itemCount: permissionStatusI.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    routeIndexSelect(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              height: 38,
                              width: 312,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      height: permissionStatusI[index].heigth,
                                      width: permissionStatusI[index].weigth,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              permissionStatusI[index].icon),
                                          fit: BoxFit.fill,
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Text(
                                      permissionStatusI[index].name,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.barlow(
                                        fontSize: 16.0,
                                        wordSpacing: 1,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}

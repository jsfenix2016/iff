import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/UserEdit/PageView/editUser_page.dart';

import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Views/contact_page.dart';
import 'package:ifeelefine/Views/geolocatos_page.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';

class menuConfigModel {
  late String name;
  late String icon;
  late double heigth;
  late double weigth;

  menuConfigModel(this.name, this.icon, this.heigth, this.weigth);
}

class MenuConfigurationPage extends StatefulWidget {
  const MenuConfigurationPage({super.key});

  @override
  State<MenuConfigurationPage> createState() => _MenuConfigurationPageState();
}

class _MenuConfigurationPageState extends State<MenuConfigurationPage> {
  List<menuConfigModel> permissionStatusI = [
    menuConfigModel(
        "Configurar tus datos", 'assets/images/VectorUser.png', 22, 19.25),
    menuConfigModel(
        "Configurar horas de sueño", 'assets/images/EllipseMenu.png', 22, 22),
    menuConfigModel(
        "Configurar tiempo uso", 'assets/images/Group 1084.png', 22, 16.93),
    menuConfigModel("Seleccionar contacto de aviso",
        'assets/images/Group 1083.png', 22, 25.52),
    menuConfigModel(
        "Configurar caída", 'assets/images/Group 506.png', 26, 22.76),
    menuConfigModel(
        "Configurar smartwatch", 'assets/images/Group 1100.png', 22, 15.87),
    menuConfigModel(
        "Cambiar envío ubicación", 'assets/images/Group 1082.png', 24, 24),
    menuConfigModel("Cambiar tiempo notificaciónes",
        'assets/images/Group 1099.png', 22, 17.15),
    menuConfigModel("Cambiar sonido notificaciones",
        'assets/images/Group 1102.png', 22, 22.08),
    menuConfigModel(
        "Ajustes de mi smartphone", 'assets/images/mobile.png', 22, 19.66),
    menuConfigModel(
        "Restaurar mi configuración", 'assets/images/Vector-2.png', 22, 22),
    menuConfigModel(
        "Desactivar mi instalación", 'assets/images/Group 533.png', 21, 17),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getContacts();
  }

  void routeIndexSelect(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserEditPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PreviewRestTimePage()),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInactivityPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ContactList()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ContactList()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GeolocatorWidget()),
        );
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
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
              Color.fromRGBO(21, 14, 3, 1),
              Color.fromRGBO(115, 75, 24, 1),
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
                                color: Color.fromRGBO(169, 146, 125, 0.8),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/habits.dart';

import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Controllers/mainController.dart';

import 'package:ifeelefine/Page/ChangeNotificationTime/PageView/changeNotificationTime_page.dart';
import 'package:ifeelefine/Page/Contact/Notice/PageView/contactNotice_page.dart';

import 'package:ifeelefine/Page/Disamble/Pageview/disambleIfeelfine_page.dart';
import 'package:ifeelefine/Page/EditUseMobil/Page/editUseMobil.dart';
import 'package:ifeelefine/Page/FallDetected/Pageview/fall_activation_config_page.dart';

import 'package:ifeelefine/Page/Geolocator/PageView/configGeolocator_page.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';

import 'package:ifeelefine/Page/PreviewActivitiesFilteredByDate/PageView/previewActivitiesByDate_page.dart';
import 'package:ifeelefine/Page/RestoreMyConfiguration/PageView/restoreMyConfig_page.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';

import 'package:ifeelefine/Page/UserEdit/PageView/editUser_page.dart';

import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Page/PermissionUser/Pageview/permission_page.dart';
import 'package:ifeelefine/Views/menu_controller.dart';
import 'package:ifeelefine/Views/ringtone_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification_center/notification_center.dart';
import 'package:slidable_button/slidable_button.dart';

import '../Common/Constant.dart';
import '../Common/utils.dart';
import '../Page/Premium/PageView/premium_page.dart';

class MenuConfigModel {
  late String name;
  late String icon;
  late double heigth;
  late double weigth;
  late bool config;
  MenuConfigModel(this.name, this.icon, this.heigth, this.weigth, this.config);
}

class MenuConfigurationPage extends StatefulWidget {
  const MenuConfigurationPage({super.key});

  @override
  State<MenuConfigurationPage> createState() => _MenuConfigurationPageState();
}

class _MenuConfigurationPageState extends State<MenuConfigurationPage> {
  final _prefs = PreferenceUser();
  var menuVC = Get.put(MenuControllerLateral());
  @override
  void initState() {
    print(permissionStatusI);
    super.initState();
    NotificationCenter().subscribe('refreshMenu', _refreshMenu);
    // _prefs.setlistConfigPage = addList;
    _refreshMenu();
  }

  void _refreshMenu() async {
    // Retrieve the list of contacts from the device
    // var contacts = await FlutterContacts.getContacts();
    // Set the list of contacts in the state
    await _prefs.initPrefs();
    // permissionStatusI = _prefs.getlistConfigPage;
    validateConfig();
    menuVC.update();
  }

  void redirectToConfigUser() {
    Route route = MaterialPageRoute(
      builder: (context) => const UserConfigPage(isMenu: true),
    );
    Navigator.push(context, route);
  }

  void routeIndexSelect(int index) async {
    MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    if (index != 0 && index != 10 && index != 9 && (user.idUser == "-1")) {
      Future.sync(
        () async => {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Atención"),
                content: const Text(
                    'Para usar esta funcionalidad, debes configurar tus datos'),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancelar", style: textBold16Black()),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text("Configurar", style: textBold16Black()),
                    onPressed: () => redirectToConfigUser(),
                  )
                ],
              );
            },
          ),
        },
      );

      return;
    }

    switch (index) {
      case 0:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserEditPage()),
            ));
        break;
      case 1:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PreviewRestTimePage(
                  isMenu: true,
                ),
              ),
            ));
        break;

      case 2:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditUseMobilPage(),
              ),
            ));
        break;
      case 3:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const PreviewActivitiesByDate(isMenu: true),
              ),
            ));
        break;
      case 4:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactNoticePage(),
              ),
            ));
        break;
      case 5:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }
        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FallActivationConfigPage(),
              ),
            ));
        break;
      case 6:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConfigGeolocator(isMenu: true),
              ),
            ));
        break;
      case 7:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeNotificationTimePage(),
              ),
            ));

        break;
      case 8:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RingTonePage(),
              ),
            ));
        break;
      case 9:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }

        Future.sync(() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PermitionUserPage(),
              ),
            ));
        break;
      case 10:
        // Future.sync(
        //   () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const RestoreMyConfigPage(),
        //     ),
        //   ),
        // );
        // return;
        if (_prefs.getUserPremium) {
          Future.sync(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RestoreMyConfigPage(),
              ),
            ),
          );
        } else {
          Future.sync(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PremiumPage(
                      isFreeTrial: false,
                      img: 'Pantalla5.jpg',
                      title: 'Protege tu Seguridad Personal las 24h:\n\n',
                      subtitle: Constant.premiumRestoreTitle)),
            ).then(
              (value) {
                if (value != null && value) {
                  _prefs.setUserPremium = true;
                  _prefs.setUserFree = false;
                  var premiumController = Get.put(PremiumController());
                  premiumController.updatePremiumAPI(true);
                  mainController.refreshHome();
                  Future.sync(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RestoreMyConfigPage(),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }
        break;
      case 11:
        if ((user.idUser == "-1") && _prefs.getUserFree) {
          redirectToConfigUser();
          return;
        }
        Future.sync(
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DesactivePage(
                isMenu: true,
              ),
            ),
          ),
        );

        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
        title: Text(
          Constant.titleNavBar,
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: GetBuilder<MenuControllerLateral>(builder: (context) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
                    child: ListView.builder(
                      itemCount: permissionStatusI.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            routeIndexSelect(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  height: 50,
                                  width: 312,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height:
                                              permissionStatusI[index].heigth,
                                          width:
                                              permissionStatusI[index].weigth,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  permissionStatusI[index]
                                                      .icon),
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
                                        flex: 1,
                                        child: Text(
                                          permissionStatusI[index].name,
                                          maxLines: 2,
                                          textAlign: TextAlign.left,
                                          style: textNormal16White(),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            permissionStatusI[index].config,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          child: Container(
                                            color: Colors.red,
                                            width: 10,
                                            height: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                      bottom: 32,
                      left: 32,
                      right: 32,
                      child: getHorizontalSlide()),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget getHorizontalSlide() {
    return HorizontalSlidableButton(
      isRestart: true,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      height: 55,
      width: 296,
      buttonWidth: 60.0,
      color: ColorPalette.principal,
      buttonColor: const Color.fromRGBO(157, 123, 13, 1),
      dismissible: false,
      label: Image.asset(
        scale: 1,
        fit: BoxFit.fill,
        'assets/images/Group 969.png',
        height: 13,
        width: 21,
      ),
      onChanged: (SlidableButtonPosition value) async {
        if (value == SlidableButtonPosition.end && _prefs.getUserPremium) {
          if (_prefs.getHabitsEnable) {
            showAlert(context, Constant.habitsActive);
            return;
          }
          updateHabits(context);
        } else if (value == SlidableButtonPosition.end) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PremiumPage(
                    isFreeTrial: false,
                    img: 'pantalla2.png',
                    title: "Protege tu Seguridad Personal las 24h:\n\n",
                    subtitle:
                        'AlertFriends aprende de tu ritmo de uso del móvil en cada momento')),
          ).then((value) {
            if (value != null && value) {
              _prefs.setUserFree = false;
              _prefs.setUserPremium = true;
              var premiumController = Get.put(PremiumController());
              premiumController.updatePremiumAPI(true);
              mainController.refreshHome();
              setState(() {});
            }
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Center(
                child: Text(
                  Constant.btnhabits,
                  textAlign: TextAlign.center,
                  style: textBold16White(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateHabits(BuildContext context) async {
    if (!_prefs.getHabitsEnable) {
      await Jiffy.locale('es');
      var datetime = DateTime.now();
      var strDatetime = Jiffy(datetime).format(getDefaultPattern());

      _prefs.setHabitsEnable = true;
      _prefs.setHabitsRefresh = strDatetime;
    }

    var habits = Habits();

    if (await habits.canUpdateHabits()) {
      await habits.fillHabits();
      await habits.fillRestDays();
      await habits.fillActivityDays();
      await habits.average();
      Future.sync(() => habits.updateUseTime(context));
    }
  }
}

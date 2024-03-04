import 'package:get/get.dart';

import 'package:ifeelefine/Views/menuconfig_page.dart';
import 'package:ifeelefine/main.dart';

class MenuControllerLateral extends GetxController {
  RxList<MenuConfigModel> menuList = <MenuConfigModel>[].obs;

  Future<RxList<MenuConfigModel>> refreshMenu() async {
    menuList.value = listMenuOptions;
    return menuList;
  }
}

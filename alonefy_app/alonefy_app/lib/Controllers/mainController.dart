import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/main.dart';

class MainController extends GetxController {
  final MainService contactServ = Get.put(MainService());

  Future<UserBD> getUserData() async {
    UserBD user = await const HiveData().getuserbd;
    // ignore: unnecessary_null_comparison
    if (user != null) {
      return user;
    } else {
      return initUserBD();
    }
  }

  Future<void> saveUserLog(String messaje, DateTime time) async {
    await inicializeHiveBD();
    LogAlertsBD mov = LogAlertsBD(type: messaje, time: time);
    const HiveData().saveUserPositionBD(mov);
  }

  Future<void> saveActivityLog(DateTime dateTime, String movementType) async {
    await inicializeHiveBD();
    LogActivityBD activityBD =
        LogActivityBD(time: dateTime, movementType: movementType);
    await logActivityController.saveLogActivity(activityBD);
  }
}

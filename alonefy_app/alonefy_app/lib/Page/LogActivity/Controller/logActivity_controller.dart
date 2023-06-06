import 'package:get/get.dart';
import 'package:ifeelefine/Model/logActivity.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Page/LogActivity/Service/logActivityService.dart';

import '../../../Controllers/mainController.dart';
import '../../../Data/hive_data.dart';

class LogActivityController extends GetxController {
  Future<List<LogActivity>> getActivities() async {
    try {
      var activitiesBD = await const HiveData().listLogActivitybd;

      List<LogActivity> activities = [];
      for (var activityBD in activitiesBD) {
        var activity = await convertLogActivityToBD(activityBD);
        activities.add(activity);
      }

      return activities;
    } catch (error) {
      return [];
    }
  }

  Future<LogActivity> convertLogActivityToBD(LogActivityBD activityBD) async {
    LogActivity logActivity = LogActivity();

    if (activityBD != null) {
      logActivity.dateTime = activityBD.time;
      logActivity.movementType = activityBD.movementType;
    }

    return logActivity;
  }

  Future<int> saveLogActivity(LogActivityBD activityBD) async {
    return await const HiveData().saveLogActivity(activityBD);
  }

  Future<void> saveLastMovement() async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    LogActivityService().saveData(user.telephone);
  }
}

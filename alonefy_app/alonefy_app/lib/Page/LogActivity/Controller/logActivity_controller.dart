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

        // Verificar si ya existe un elemento con la misma fecha y tipo de movimiento
        bool isDuplicate = activities.any((existingActivity) =>
            existingActivity.dateTime.day == activity.dateTime.day &&
            existingActivity.dateTime.month == activity.dateTime.month &&
            existingActivity.dateTime.year == activity.dateTime.year &&
            existingActivity.dateTime.hour == activity.dateTime.hour &&
            existingActivity.dateTime.minute == activity.dateTime.minute &&
            existingActivity.dateTime.second == activity.dateTime.second &&
            existingActivity.movementType == activity.movementType);

        // Si no es un duplicado, agregarlo a la lista
        if (!isDuplicate) {
          activities.add(activity);
        }
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
    LogActivityService().saveData(user.telephone.contains('+34')
        ? user.telephone.replaceAll("+34", "")
        : user.telephone);
  }
}

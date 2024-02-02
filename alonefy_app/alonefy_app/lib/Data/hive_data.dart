import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';

import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';

class HiveData {
  const HiveData();

  Future<void> saveUserBD(UserBD user) async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');
    await box.add(user);
  }

  Future<UserBD> saveUser(User user) async {
    var person = UserBD(
        idUser: user.idUser,
        name: user.name,
        lastname: user.lastname,
        email: user.email,
        telephone: user.telephone,
        gender: user.gender,
        maritalStatus: user.maritalStatus,
        styleLife: user.styleLife,
        pathImage: "",
        age: user.age,
        country: user.country,
        city: user.city);
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');
    await box.add(person);
    person = box.getAt(0)!;
    return person;
  }

  Future updateUser(UserBD user) async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

    await box.putAt(0, user);
  }

  Future<UserBD> get getuserbd async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');
    UserBD person = initUserBD();

    if (box.isEmpty == false) {
      person = box.getAt(0)!;
      return person;
    } else {
      return person;
    }
  }

  Future<bool> deleteUsers() async {
    // Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

    try {
      await Hive.deleteFromDisk();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<ContactBD>> get listUserContactbd async {
    try {
      var box = await Hive.openBox<ContactBD>('contactBD');

      var listContact = box.values.toList();
      Hive.close();
      return listContact;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<ContactBD?> getContactBD(String phones) async {
    try {
      final box = await Hive.openBox<ContactBD>('contactBD');

      for (ContactBD item in box.values.toList()) {
        if (item.phones == phones) {
          return item;
        }
      }

      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<ContactBD?> updateContact(ContactBD contact) async {
    try {
      var box = await Hive.openBox<ContactBD>('contactBD');

      // var index = 0;
      // for (var contactBD in box.values) {
      //   if (contact.phones == contactBD.phones) {}
      //   index++;
      // }

      var index = 0;
      for (var contactRiskBD in box.values.toList()) {
        if (contactRiskBD.phones == contact.phones) {
          await box.putAt(index, contact);
          break;
        }
        index++;
      }

      final listDate = box.values.toList();
      // contactNotifiers.value = listDate;
      int indexSelect =
          listDate.indexWhere((item) => item.phones == contact.phones);
      print(listDate);

      var temp = listDate[indexSelect];
      print(temp);
      return temp;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<ContactBD?> updateContactBackGround(ContactBD contact) async {
    try {
      var box = await Hive.openBox<ContactBD>('contactBD');
      ContactBD? contactTemp;

      var index = 0;
      for (var contactBD in box.values.toList()) {
        if (contactBD.phones == contact.phones) {
          contact = contactBD;
          contactTemp = contactBD;
          break;
        }
        index++;
      }

      await box.delete(contact.key);
      await box.add(contactTemp!);
      Hive.close();
      final listDate = box.values.toList();
      // contactNotifiers.value = listDate;
      int indexSelect =
          listDate.indexWhere((item) => item.phones == contact.phones);
      print(listDate);

      var temp = listDate[indexSelect];
      print(temp);
      return temp;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> saveUserContact(ContactBD user) async {
    final box = await Hive.openBox<ContactBD>('contactBD');
    try {
      await box.add(user);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> deleteUserContact(ContactBD contact) async {
    final Box<ContactBD> box = await Hive.openBox<ContactBD>('contactBD');

    return box.delete(contact.key);
  }

  // Future<int> deleteListHistorial(List list) async {
  //   try {
  //     final Box<LogAlertsBD> box =
  //         await Hive.openBox<LogAlertsBD>('UserPositionBD');
  //     Box<LogActivityBD> boxActivity =
  //         await Hive.openBox<LogActivityBD>('LogActivityBD');

  //     for (var element in list) {
  //       if (element.type == "Movimiento") {
  //         await boxActivity.deleteAll(element);
  //       }
  //       if (element.type == "Incactividad") {
  //         await box.delete(element);
  //       } else {}
  //       //
  //     }

  //     return 0;
  //   } catch (error) {
  //     return -1;
  //   }
  // }

  Future<List<LogAlertsBD>> get listHistorialLogbd async {
    final Box<LogAlertsBD> box =
        await Hive.openBox<LogAlertsBD>('listLogsHistorial');

    var listContact = box.values.toList();

    return listContact;
  }

  Future<int> deleteListLogHistorial(List<LogAlertsBD> listAlerts) async {
    try {
      final Box<LogAlertsBD> box =
          await Hive.openBox<LogAlertsBD>('listLogsHistorial');

      for (var element in listAlerts) {
        box.delete(element.key);
      }

      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<int> saveLogsHistorialBD(LogAlertsBD user) async {
    try {
      final Box<LogAlertsBD> box =
          await Hive.openBox<LogAlertsBD>('UserPositionBD');

      box.add(user);
      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<int> saveListLogsHistorial(List<dynamic> activities) async {
    Box<dynamic> box = await Hive.openBox<dynamic>('listLogsHistorial');

    for (var element in box.values) {
      box.delete(element.key);
    }

    for (ActivityDayBD element in activities) {
      box.add(element);
    }

    return 0;
  }

  Future<int> deleteListAlerts(List<LogAlertsBD> listAlerts) async {
    try {
      final Box<LogAlertsBD> box =
          await Hive.openBox<LogAlertsBD>('UserPositionBD');

      for (var element in listAlerts) {
        box.delete(element.key);
      }

      return 0;
    } catch (error) {
      return -1;
    }
  }

  // Future<int> deleteListHistorial(List list) async {
  //   try {
  //     final Box<LogAlertsBD> box =
  //         await Hive.openBox<LogAlertsBD>('UserPositionBD');
  //     Box<LogActivityBD> boxActivity =
  //         await Hive.openBox<LogActivityBD>('LogActivityBD');

  //     for (var element in list) {
  //       if (element.type == "Movimiento") {
  //         await boxActivity.deleteAll(element);
  //       }
  //       if (element.type == "Incactividad") {
  //         await box.delete(element);
  //       } else {}
  //       //
  //     }

  //     return 0;
  //   } catch (error) {
  //     return -1;
  //   }
  // }

  Future<int> saveUserPositionBD(LogAlertsBD user) async {
    try {
      final Box<LogAlertsBD> box =
          await Hive.openBox<LogAlertsBD>('UserPositionBD');

      box.add(user);
      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<List<LogAlertsBD>> getAlerts() async {
    Box<LogAlertsBD> box = await Hive.openBox<LogAlertsBD>('UserPositionBD');
    return box.values.toList();
  }

  Future<void> deleteAllAlerts() async {
    Box<LogAlertsBD> box = await Hive.openBox<LogAlertsBD>('UserPositionBD');

    for (var element in box.values) {
      box.delete(element);
    }
  }

  Future<List<ContactBD>> get listUserPositionbd async {
    final Box<List<ContactBD>> box =
        await Hive.openBox<List<ContactBD>>('listUserContactBD');

    return box.values.first;
  }

  Future<void> deleteAllContacts() async {
    Box<ContactBD> box = await Hive.openBox<ContactBD>('listUserContactBD');

    for (var element in box.values) {
      box.delete(element);
    }
  }

  Future<List<ActivityDayBD>> get listUserActivitiesbd async {
    final box = await Hive.openBox<ActivityDayBD>('listActivityDayBD');
    return box.values.toList();
  }

  Future<int> saveActivity(ActivityDayBD activity) async {
    Box<ActivityDayBD> box =
        await Hive.openBox<ActivityDayBD>('listActivityDayBD');

    box.add(activity);

    return 0;
  }

  Future<int> saveActivities(List<ActivityDayBD> activities) async {
    Box<ActivityDayBD> box =
        await Hive.openBox<ActivityDayBD>('listActivityDayBD');

    for (var element in box.values) {
      box.delete(element.key);
    }

    for (ActivityDayBD element in activities) {
      box.add(element);
    }

    return 0;
  }

  Future<int> updateActivity(ActivityDayBD activity) async {
    Box<ActivityDayBD> box =
        await Hive.openBox<ActivityDayBD>('listActivityDayBD');

    var index = 0;
    for (var activityBD in box.values) {
      if (activityBD.id == activity.id) {
        box.putAt(index, activity);
        break;
      }
      index++;
    }

    //box.put(activity.id, activity);

    return 0;
  }

  Future<int> updateActivities(List<ActivityDayBD> activities) async {
    final Box<ActivityDayBD> box =
        await Hive.openBox<ActivityDayBD>('listActivityDayBD');
    for (ActivityDayBD element in activities) {
      box.put(element.id, element);
    }

    return 0;
  }

  Future<void> deleteActivities(ActivityDayBD activities) async {
    final Box<ActivityDayBD> box =
        await Hive.openBox<ActivityDayBD>('listActivityDayBD');
    for (var element in box.values) {
      if (element.id == activities.id &&
          element.activity == activities.activity) {
        await box.delete(element.key);
      }
    }
  }

  Future<void> deleteAllActivities() async {
    Box<ActivityDayBD> box =
        await Hive.openBox<ActivityDayBD>('listActivityDayBD');

    for (var element in box.values) {
      box.delete(element);
    }
  }

  //TODO: all rest user
  Future<int> saveTimeRest(RestDayBD restDay) async {
    try {
      Box<RestDayBD> box = await Hive.openBox<RestDayBD>('RestDayBD');
      if (box.isEmpty) {
        await box.add(restDay);
        return 0;
      }
      for (var element in box.values) {
        if (element.day == restDay.day) {
          await box.put(int.parse(restDay.key), element);
          break;
        } else if (element.day != restDay.day) {
          await box.add(restDay);
          break;
        }
      }

      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<int> saveListTimeRest(List<RestDayBD> activities) async {
    Box<RestDayBD> box = await Hive.openBox<RestDayBD>('RestDayBD');

    for (var element in box.values) {
      box.delete(element.key);
    }

    for (RestDayBD element in activities) {
      box.put(element.day, element);
    }

    return 0;
  }

  Future<bool> updateUserRestTime(RestDayBD user) async {
    try {
      Box<RestDayBD> box = await Hive.openBox<RestDayBD>('RestDayBD');

      box.put(user.day, user);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<int> updateTimeRest(List<RestDayBD> activities) async {
    final Box<RestDayBD> box = await Hive.openBox<RestDayBD>('RestDayBD');
    for (RestDayBD element in activities) {
      box.put(element.day, element);
    }

    return 0;
  }

  Future<List<RestDayBD>> get listUserRestDaybd async {
    final box = await Hive.openBox<RestDayBD>('RestDayBD');
    return box.values.toList();
  }

  Future<void> deleteTimeRest(RestDayBD restDay) async {
    final Box<RestDayBD> box = await Hive.openBox<RestDayBD>('RestDayBD');
    for (var element in box.values) {
      if (element.key == restDay.day) {
        await box.delete(element.key);
      }
    }
  }

  Future<void> deleteAllRestDays() async {
    Box<RestDayBD> box = await Hive.openBox<RestDayBD>('RestDayBD');

    for (var element in box.values) {
      box.delete(element);
    }
  }

  Future<List<LogActivityBD>> get listLogActivitybd async {
    final box = await Hive.openBox<LogActivityBD>('LogActivityBD');
    return box.values.toList();
  }

  Future<int> saveLogActivity(LogActivityBD logActivityBD) async {
    final Box<LogActivityBD> box =
        await Hive.openBox<LogActivityBD>('LogActivityBD');

    return box.add(logActivityBD);
  }

  Future<void> deleteAllLogActivities() async {
    Box<LogActivityBD> box = await Hive.openBox<LogActivityBD>('LogActivityBD');

    for (var element in box.values) {
      box.delete(element);
    }
  }

  Future<int> saveListTimeUseMobil(List<UseMobilBD> useMobilDays) async {
    try {
      Box<UseMobilBD> box = await Hive.openBox<UseMobilBD>('TimeUseMobilBD');

      if (box.values.isNotEmpty) {
        for (var element in box.values) {
          box.delete(element.key);
        }
      }

      for (UseMobilBD element in useMobilDays) {
        box.put(element.day, element);
      }

      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<List<UseMobilBD>> get listUseMobilBd async {
    final box = await Hive.openBox<UseMobilBD>('TimeUseMobilBD');
    return box.values.toList();
  }

  Future<void> deleteAllUseMobil() async {
    Box<UseMobilBD> box = await Hive.openBox<UseMobilBD>('TimeUseMobilBD');

    for (var element in box.values) {
      box.delete(element);
    }
  }

  // Future<bool> updateUserRestTime(RestDayBD user) async {
  //   try {
  //     Box<RestDayBD> box = await Hive.openBox<RestDayBD>('RestDayBD');

  //     box.put(user.day, user);

  //     return true;
  //   } catch (error) {
  //     return false;
  //   }
  // }
}

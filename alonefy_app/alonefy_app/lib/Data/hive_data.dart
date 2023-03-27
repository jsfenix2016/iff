import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';

class HiveData {
  const HiveData();

  Future<int> saveUser(User user) async {
    UserBD person = UserBD(
        idUser: '0',
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

    return box.add(person);
  }

  Future updateUser(UserBD user) async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

    box.put(int.parse(user.idUser), user);
  }

  Future<UserBD> get getuserbd async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');
    UserBD person = UserBD(
        idUser: '-1',
        name: '',
        lastname: '',
        email: '',
        telephone: '',
        gender: '',
        maritalStatus: '',
        styleLife: '',
        pathImage: '',
        age: '18',
        country: '',
        city: '');

    if (box.isEmpty == false) {
      person = box.getAt(0)!;
      return person;
    } else {
      return person;
    }
  }

  Future<List<ContactBD>> get listUserContactbd async {
    final Box<ContactBD> box = await Hive.openBox<ContactBD>('contactBD');
    late final List<ContactBD> allMovTime = [];
    var listContact = box.values.toList();
    var contactTemp = ContactBD(0, "", null, null, "", "", "", '');
    for (var element in listContact) {
      contactTemp.id = element.id;
      contactTemp.displayName = element.displayName;

      contactTemp.phones = element.phones;
      contactTemp.photo = element.thumbnail;
      contactTemp.timeSendSMS = element.timeSendSMS;
      contactTemp.timeCall = element.timeCall;

      allMovTime.add(contactTemp);
    }

    return allMovTime;
  }

  Future<int> saveUserContact(ContactBD user) async {
    final Box<ContactBD> box = await Hive.openBox<ContactBD>('contactBD');

    return box.add(user);
  }

  Future<void> deleteUserContact(ContactBD user) async {
    final Box<ContactBD> box = await Hive.openBox<ContactBD>('contactBD');

    return box.delete(user.id);
  }

  Future<int> deleteListAlerts(List<UserPositionBD> listAlerts) async {
    try {
      final Box<UserPositionBD> box =
          await Hive.openBox<UserPositionBD>('UserPositionBD');

      for (var element in listAlerts) {
        box.delete(element.key);
      }

      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<int> saveUserPositionBD(UserPositionBD user) async {
    try {
      final Box<UserPositionBD> box =
          await Hive.openBox<UserPositionBD>('UserPositionBD');

      box.add(user);
      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<List<UserPositionBD>> getAlerts() async {
    Box<UserPositionBD> box =
        await Hive.openBox<UserPositionBD>('UserPositionBD');
    return box.values.toList();
  }

  Future<List<ContactBD>> get listUserPositionbd async {
    final Box<List<ContactBD>> box =
        await Hive.openBox<List<ContactBD>>('listUserContactBD');

    return box.values.first;
  }

  Future<List<ActivityDayBD>> get listUserActivitiesbd async {
    final box = await Hive.openBox<ActivityDayBD>('listActivityDayBD');
    return box.values.toList();
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
      if (element.key == activities.id &&
          element.activity == activities.activity) {
        await box.delete(element.key);
      }
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
}

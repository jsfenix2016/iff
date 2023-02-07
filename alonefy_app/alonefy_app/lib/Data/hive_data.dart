import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';

class HiveData {
  const HiveData();

  Future<int> saveUser(UserBD user) async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

    return box.add(user);
  }

  Future updateUser(UserBD user) async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

    box.put(user.idUser, user);
  }

  Future<UserBD> get getuserbd async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');
    return box.values.first;
  }

  Future<List<ContactBD>> get listUserContactbd async {
    final Box<List<ContactBD>> box =
        await Hive.openBox<List<ContactBD>>('listUserContactBD');
    return box.values.first;
  }

  Future<int> saveUserContact(ContactBD user) async {
    final Box<ContactBD> box = await Hive.openBox<ContactBD>('contactBD');

    return box.add(user);
  }

  Future<int> saveUserPositionBD(UserPositionBD user) async {
    final Box<UserPositionBD> box =
        await Hive.openBox<UserPositionBD>('UserPositionBD');

    return box.add(user);
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
  Future<int> saveTimeRest(List<RestDayBD> activities) async {
    Box<RestDayBD> box = await Hive.openBox<RestDayBD>('listRestDayBD');

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
      Box<RestDayBD> box = await Hive.openBox<RestDayBD>('listRestDayBD');

      box.put(user.day, user);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<int> updateTimeRest(List<RestDayBD> activities) async {
    final Box<RestDayBD> box = await Hive.openBox<RestDayBD>('listRestDayBD');
    for (RestDayBD element in activities) {
      box.put(element.day, element);
    }

    return 0;
  }

  Future<List<RestDayBD>> get listUserRestDaybd async {
    final box = await Hive.openBox<RestDayBD>('listRestDayBD');
    return box.values.toList();
  }

  Future<void> deleteTimeRest(RestDayBD activities) async {
    final Box<RestDayBD> box = await Hive.openBox<RestDayBD>('listRestDayBD');
    for (var element in box.values) {
      if (element.key == activities.day) {
        await box.delete(element.key);
      }
    }
  }
}

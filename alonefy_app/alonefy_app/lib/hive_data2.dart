import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';

class HiveData2 {
  const HiveData2();

  Future<int> saveUser(UserBD user) async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

    return box.add(user);
  }

  Future updateUser(UserBD user) async {
    final Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

    box.put(user.idUser, user);
    box.close();
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

  Future<Iterable<List<UserPositionBD>>> get listUserMovbd async {
    final Box<List<UserPositionBD>> box =
        await Hive.openBox<List<UserPositionBD>>('UserPositionBD');
    return box.values;
  }

  Future<List<ContactBD>> get listUserPositionbd async {
    final Box<List<ContactBD>> box =
        await Hive.openBox<List<ContactBD>>('listUserContactBD');
    return box.values.first;
  }
}

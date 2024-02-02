import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

class HiveDataRisk {
  const HiveDataRisk();

  Future<bool> saveContactRisk(ContactRiskBD contact) async {
    try {
      final Box<ContactRiskBD> box =
          await Hive.openBox<ContactRiskBD>('contactriskbd');

      final person = await box.add(contact);

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<ContactRiskBD> updateContactRisk(ContactRiskBD contact) async {
    ContactRiskBD? temp = initContactRisk();
    try {
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      var index = 0;
      for (var contactRiskBD in box.values.toList()) {
        if (contactRiskBD.id == contact.id) {
          await box.putAt(index, contact);
          break;
        }
        index++;
      }

      final listDate = box.values.toList();
      // contactNotifiers.value = listDate;
      int indexSelect = listDate.indexWhere((item) => item.id == contact.id);
      print(listDate);

      temp = listDate[indexSelect];

      // contactNotifiers.notifyListeners();
      return temp;
    } catch (error) {
      print(error);
      return temp!;
    }
  }

  Future deleteDate(ContactRiskBD contact) async {
    try {
      final Box<ContactRiskBD> box =
          await Hive.openBox<ContactRiskBD>('contactriskbd');

      var index = 0;
      for (var contactRiskBD in box.values.toList()) {
        if (contactRiskBD.id == contact.id) {
          await box.deleteAt(index);
          break;
        }
        index++;
      }
      print("delete");
      // final listDate = box.values.toList();
      // contactNotifiers.value = listDate;
    } catch (error) {
      print(error);
    }
  }

  Future<List<ContactRiskBD>> get getcontactRiskbd async {
    try {
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      return box.values.toList();
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<ContactRiskBD?> getContactRiskBD(int id) async {
    try {
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      for (ContactRiskBD item in box.values.toList()) {
        if (item.id == id) {
          return item;
        }
      }

      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<ContactRiskBD?> getContactRiskBDByTaskIds(List<String> taskIds) async {
    try {
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      for (ContactRiskBD item in box.values.toList()) {
        if (item.taskIds == taskIds) {
          return item;
        }
      }
      // final listDate = box.values.toList();
      // contactNotifiers.value = listDate;
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> deleteAllContactRisk() async {
    Box<ContactRiskBD> box = await Hive.openBox<ContactRiskBD>('contactriskbd');

    for (var element in box.values) {
      box.delete(element);
    }
  }

  ///ZONE RISK
  Future<List<ContactZoneRiskBD>> get getcontactZoneRiskbd async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');
      var listZone = box.values.toList();

      return listZone;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> saveContactZoneRisk(ContactZoneRiskBD contact) async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

      var temp = await box.add(contact);

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future updateContactZoneRisk(ContactZoneRiskBD contact) async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

      final listDate = box.values.toList();

      var index = 0;
      for (var contactZoneRiskBD in listDate) {
        if (contactZoneRiskBD.id == contact.id) {
          await box.putAt(index, contact);
          break;
        }
        index++;
      }

      print(listDate);
    } catch (error) {
      print(error);
    }
  }

  Future<bool> deleteContactZone(ContactZoneRiskBD contact) async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

      final listDate = box.values.toList();

      var index = 0;
      for (var contactZoneRiskBD in listDate) {
        if (contactZoneRiskBD.id == contact.id) {
          await box.deleteAt(index);
          break;
        }
        index++;
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> deleteAllContactZoneRisk() async {
    Box<ContactZoneRiskBD> box =
        await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

    for (var element in box.values) {
      box.delete(element);
    }
  }
}

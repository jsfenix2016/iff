import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

class HiveDataRisk {
  const HiveDataRisk();

  Future<int> saveContactRisk(ContactRiskBD contact) async {
    try {
      final Box<ContactRiskBD> box =
          await Hive.openBox<ContactRiskBD>('contactriskbd');

      var ind = box.values.length;
      contact.id = ind;
      final person = await box.add(contact);
      return person;
    } catch (error) {
      return -1;
    }
  }

  Future<bool> updateContactRisk(ContactRiskBD contact) async {
    try {
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      await box.put((contact.id), contact);
      final listDate = box.values.toList();
      print(listDate);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future deleteDate(ContactRiskBD contact) async {
    try {
      final Box<ContactRiskBD> box =
          await Hive.openBox<ContactRiskBD>('contactriskbd');
      await box.deleteAt(contact.id);
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

  Future<ContactRiskBD?> getContactRiskBD(String phones) async {
    try {
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      for (ContactRiskBD item in box.values.toList()) {
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

      await box.putAt(contact.id, contact);

      print(listDate);
    } catch (error) {
      print(error);
    }
  }

  Future<bool> deleteContactZone(ContactZoneRiskBD contact) async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');
      await box.delete(contact.id);

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

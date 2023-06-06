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

  Future<int> saveContactZoneRisk(ContactZoneRiskBD contact) async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

      var temp = await box.add(contact);

      return temp;
    } catch (error) {
      print(error);
      return -1;
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
      await box.delete(contact);

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

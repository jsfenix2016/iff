import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

class HiveDataRisk {
  const HiveDataRisk();

  Future<int> saveContactRisk(ContactRiskBD contact) async {
    final Box<ContactRiskBD> box =
        await Hive.openBox<ContactRiskBD>('ContactRiskBD');

    int nextId = 0;

    for (var element in box.keys) {
      if (element.id == nextId) {
        nextId++;
      }
    }

    contact.id = nextId;
    var ind = box.add(contact);
    box.compact();

    return ind;
  }

  Future updateContactRisk(ContactRiskBD contact) async {
    var box = await Hive.openBox<ContactRiskBD>('ContactRiskBD');

    for (var element in box.keys) {
      if (element == contact) {
        box.put((contact.id), contact);
        box.compact();

        break;
      }
    }
  }

  Future deleteDate(ContactRiskBD contact) async {
    final Box<ContactRiskBD> box =
        await Hive.openBox<ContactRiskBD>('ContactRiskBD');
    box.deleteAt(contact.id);
  }

  Future<List<ContactRiskBD>> get getcontactRiskbd async {
    final Box<ContactRiskBD> box =
        await Hive.openBox<ContactRiskBD>('ContactRiskBD');

    return box.values.toList();
  }

  ///ZONE RISK
  Future<List<ContactZoneRiskBD>> get getcontactZoneRiskbd async {
    final Box<ContactZoneRiskBD> box =
        await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

    return box.values.toList();
  }

  Future<int> saveContactZoneRisk(ContactZoneRiskBD contact) async {
    final Box<ContactZoneRiskBD> box =
        await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

    return box.add(contact);
  }

  Future updateContactZoneRisk(ContactZoneRiskBD contact) async {
    final Box<ContactZoneRiskBD> box =
        await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

    box.put((contact.id), contact);
  }

  Future deleteContactZone(ContactZoneRiskBD contact) async {
    final Box<ContactZoneRiskBD> box =
        await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');
    box.delete(contact);
  }
}

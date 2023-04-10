import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

class HiveDataRisk {
  const HiveDataRisk();

  Future<int> saveContactRisk(ContactRiskBD contact) async {
    try {
      await Hive.close();
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      var ind = await box.add(contact);

      return ind;
    } catch (error) {
      return -1;
    }
  }

  Future updateContactRisk(ContactRiskBD contact) async {
    try {
      await Hive.close();
      final box = await Hive.openBox<ContactRiskBD>('contactriskbd');

      await box.put((contact.id), contact);
      final listDate = box.values.toList();
      print(listDate);
    } catch (error) {
      print(error);
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

      late List<ContactRiskBD> allDate = [];

      ContactRiskBD contactTemp = ContactRiskBD(
          id: -1,
          photo: null,
          name: '',
          timeinit: '00:00',
          timefinish: '00:00',
          phones: '',
          titleMessage: '',
          messages: '',
          sendLocation: false,
          sendWhatsapp: false,
          isInitTime: false,
          isFinishTime: false,
          code: '',
          isActived: false,
          isprogrammed: false);

      for (var element in box.values.toList()) {
        contactTemp.id = element.id;
        contactTemp.photo = element.photo;

        contactTemp.name = element.name;
        contactTemp.photo = element.photo;
        contactTemp.timeinit = element.timeinit;
        contactTemp.timefinish = element.timefinish;

        contactTemp.phones = element.phones;
        contactTemp.titleMessage = element.titleMessage;
        contactTemp.messages = element.messages;
        contactTemp.sendLocation = element.sendLocation;

        contactTemp.sendWhatsapp = element.sendWhatsapp;
        contactTemp.isInitTime = element.isInitTime;
        contactTemp.isFinishTime = element.isFinishTime;
        contactTemp.code = element.code;

        contactTemp.isActived = element.isActived;
        contactTemp.isprogrammed = element.isprogrammed;
        allDate.add(contactTemp);
      }

      return allDate;
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
      await Hive.close();
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

      await box.add(contact);
      await Hive.close();
      return 0;
    } catch (error) {
      print(error);
      return -1;
    }
  }

  Future updateContactZoneRisk(ContactZoneRiskBD contact) async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

      await box.put((contact.id), contact);

      await Hive.close();
    } catch (error) {
      print(error);
    }
  }

  Future deleteContactZone(ContactZoneRiskBD contact) async {
    final Box<ContactZoneRiskBD> box =
        await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');
    await box.delete(contact);
    await Hive.close();
  }
}

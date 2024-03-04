import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Model/videopresignedbd.dart';

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

    await box.clear(); // Esto borrará todos los datos en la caja 'useMobil'
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

  Future<ContactZoneRiskBD> getcontactZoneRiskbdID(
      ContactZoneRiskBD zone) async {
    try {
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');
      var listZone = box.values.toList();

      var index = 0;
      for (var contactZoneRiskBD in listZone) {
        if (contactZoneRiskBD.id == zone.id) {
          return (contactZoneRiskBD);
        }
        index++;
      }
      return zone;
    } catch (error) {
      print(error);
      return zone;
    }
  }

  Future<bool> saveContactZoneRisk(ContactZoneRiskBD contact) async {
    try {
      await inicializeHiveBD();
      final Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

      var temp = await box.add(contact);

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveContactZoneRiskVideos(VideoPresignedBD videoZone) async {
    try {
      await inicializeHiveBD();
      final Box<VideoPresignedBD> box =
          await Hive.openBox<VideoPresignedBD>('VideoZoneRiskBD');

      var temp = await box.add(videoZone);

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

    await box.clear(); // Esto borrará todos los datos en la caja 'useMobil'
  }

  Future<void> deleteAllZoneRisk() async {
    try {
      Box<ContactZoneRiskBD> box =
          await Hive.openBox<ContactZoneRiskBD>('ContactZoneRiskBD');

      await box.clear();

      final Box<VideoPresignedBD> boxv =
          await Hive.openBox<VideoPresignedBD>('VideoZoneRiskBD');
      await boxv.clear();
    } catch (error) {
      print(error);
    } // Esto borrará todos los datos en la caja 'useMobil'
  }
}

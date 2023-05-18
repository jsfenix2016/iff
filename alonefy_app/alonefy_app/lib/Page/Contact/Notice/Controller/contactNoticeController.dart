import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:notification_center/notification_center.dart';

class ContactNoticeController extends GetxController {
  Future<List<ContactBD>> getAllContact() async {
    final listContact = await const HiveData().listUserContactbd;
    if (listContact.isNotEmpty) {
      return listContact;
    } else {
      return [];
    }
  }

  Future<void> deleteContact(ContactBD user) async {
    await const HiveData().deleteUserContact(user);
    NotificationCenter().notify('getContact');
  }
}

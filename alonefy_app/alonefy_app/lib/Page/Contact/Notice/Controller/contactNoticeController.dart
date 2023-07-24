import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/Service/contactService.dart';
import 'package:notification_center/notification_center.dart';

import '../../../../Controllers/mainController.dart';

class ContactNoticeController extends GetxController {
  Future<List<ContactBD>> getAllContact() async {
    final listContact = await const HiveData().listUserContactbd;
    if (listContact.isNotEmpty) {
      return listContact;
    } else {
      return [];
    }
  }

  Future<ContactBD?> getContact(String phones) async {
    final contact = await const HiveData().getContactBD(phones);
    return contact;
  }

  Future<void> deleteContact(ContactBD contact) async {
    await const HiveData().deleteUserContact(contact);

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    await ContactService().deleteContact(
        user.telephone.contains('+34')
            ? user.telephone.replaceAll("+34", "")
            : user.telephone,
        contact.phones.contains('+34')
            ? contact.phones.replaceAll("+34", "")
            : contact.phones);

    NotificationCenter().notify('getContact');
  }
}

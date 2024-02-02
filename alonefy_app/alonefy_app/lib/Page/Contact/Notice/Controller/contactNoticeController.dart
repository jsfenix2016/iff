import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/ListContact/Controller/list_contact_controller.dart';
import 'package:ifeelefine/Page/Contact/Service/contactService.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';

import '../../../../Controllers/mainController.dart';

class ContactNoticeController extends GetxController {
  RxList<ContactBD> contactList = <ContactBD>[].obs;
  Future<RxList<ContactBD>> getAllContactDB() async {
    await inicializeHiveBD();
    try {
      contactList.value = await const HiveData().listUserContactbd;
      print(contactList.value.toList());
      return contactList;
    } catch (error) {
      return contactList;
    }
  }

  Future<List<ContactBD>> getAllContact() async {
    await inicializeHiveBD();
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
    user = await mainController.getUserData();

    await ContactService().deleteContact(
        user!.telephone.contains('+34')
            ? user!.telephone.replaceAll("+34", "")
            : user!.telephone,
        contact.phones.contains('+34')
            ? contact.phones.replaceAll("+34", "")
            : contact.phones);

    NotificationCenter().notify('getContact');
  }
}

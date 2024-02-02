import 'package:get/get.dart';

import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';

class ListContactController extends GetxController {
  RxList<ContactBD> listContactDb = <ContactBD>[].obs;

  Future<List<ContactBD>> getAllContact() async {
    final listContact = await const HiveData().listUserContactbd;
    if (listContact.isNotEmpty) {
      listContactDb.value = listContact;
      return listContact;
    } else {
      return [];
    }
  }
}

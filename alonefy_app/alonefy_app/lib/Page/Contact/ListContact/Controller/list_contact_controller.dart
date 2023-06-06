import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';

class ListContactController extends GetxController {
  Future<List<ContactBD>> getAllContact() async {
    final listContact = await const HiveData().listUserContactbd;
    if (listContact.isNotEmpty) {
      return listContact;
    } else {
      return [];
    }
  }
}

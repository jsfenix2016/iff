import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

final _prefs = PreferenceUser();

class DisambleController extends GetxController {
  Future<void> saveDisamble(BuildContext context, String dismbletime) async {
    _prefs.setDisambleIFF = dismbletime;
    _prefs.setEnableIFF = false;
    showAlert(context, "Se a deshabilitado la protección");
  }
}

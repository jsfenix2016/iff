import 'dart:convert';

import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';
import 'package:http/http.dart' as http;

import '../../../Common/Constant.dart';

class ActivityService {

  Future<void> saveData(ActivityDayApi activityDayApi) async {

     final resp = await http.post(
         Uri.parse("${Constant.baseApi}/v1/activity"),
         body: activityDayApi
     );

     var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;

     print(decodedResponse['id'] as int);
  }
}
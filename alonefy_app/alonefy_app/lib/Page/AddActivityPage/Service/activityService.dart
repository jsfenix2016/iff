import 'dart:convert';

import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/activityDayApiResponse.dart';

import '../../../Common/Constant.dart';

class ActivityService {

  Future<ActivityDayApiResponse?> saveData(ActivityDayApi activityDayApi, String phone) async {

     final resp = await http.post(
         Uri.parse("${Constant.baseApi}/v1/activity/$phone"),
         body: activityDayApi
     );

     if (resp.statusCode == 200) {
       return ActivityDayApiResponse.fromJson(jsonDecode(resp.body));
     } else {
       return null;
     }
  }

  Future<void> updateData(ActivityDayApi activityDayApi, String phone) async {

    final resp = await http.put(
        Uri.parse("${Constant.baseApi}/v1/activity/$phone"),
        body: activityDayApi
    );

    var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;

    print(decodedResponse['id'] as int);
  }
}
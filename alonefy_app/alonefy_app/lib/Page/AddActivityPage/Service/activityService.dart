import 'dart:convert';

import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/activityDayApiResponse.dart';

import '../../../Common/Constant.dart';

class ActivityService {

  Future<ActivityDayApiResponse?> saveData(ActivityDayApi activityDayApi) async {

    var json = jsonEncode(activityDayApi);

     final resp = await http.post(
         Uri.parse("${Constant.baseApi}/v1/activity"),
         body: json
     );

     if (resp.statusCode == 200) {
       return ActivityDayApiResponse.fromJson(jsonDecode(resp.body));
     } else {
       return null;
     }
  }

  Future<void> updateData(ActivityDayApi activityDayApi, int id) async {

    var json = jsonEncode(activityDayApi);

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/activity/$id"),
        body: json
    );

    //var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;
//
    //print(decodedResponse['id'] as int);
  }

  Future<ActivityDayApiResponse?> getActivities(String phoneNumber) async {

    var response = await http.get(
      Uri.parse("${Constant.baseApi}/v1/activity/$phoneNumber")
    );

    if (response.statusCode == 200) {
      return ActivityDayApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
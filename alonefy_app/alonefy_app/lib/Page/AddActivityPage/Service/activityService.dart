import 'dart:convert';

import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/activityDayApiResponse.dart';

import '../../../Common/Constant.dart';

class ActivityService {
  Future<ActivityDayApiResponse?> saveData(
      ActivityDayApi activityDayApi) async {
    var json = jsonEncode(activityDayApi);

    final resp = await http.post(Uri.parse("${Constant.baseApi}/v1/activity"),
        headers: Constant.headers, body: json);

    if (resp.statusCode == 200) {
      return ActivityDayApiResponse.fromJson(jsonDecode(resp.body));
    } else {
      return null;
    }
  }

  Future<bool> updateData(ActivityDayApiResponse activityDayApi) async {
    try {
      var json = jsonEncode(activityDayApi);

      var response = await http.put(
          Uri.parse("${Constant.baseApi}/v1/activity"),
          headers: Constant.headers,
          body: json);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }

    //var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;
//
    //print(decodedResponse['id'] as int);
  }

  Future<ActivityDayApiResponse?> getActivities(String phoneNumber) async {
    var response = await http
        .get(Uri.parse("${Constant.baseApi}/v1/activity/$phoneNumber"));

    if (response.statusCode == 200) {
      return ActivityDayApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> deleteActivities(String id) async {
    try {
      var response =
          await http.delete(Uri.parse("${Constant.baseApi}/v1/activity/$id"));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

import 'package:ifeelefine/Model/ApiRest/AlertApi.dart';
import 'package:ifeelefine/Model/ApiRest/ContactRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/UseMobilApi.dart';
import 'package:ifeelefine/Model/ApiRest/UserRestApi.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/activityDayApiResponse.dart';
import 'package:ifeelefine/Model/ApiRest/userApi.dart';

import 'ContactApi.dart';

class RestoreApi {
  late UserApi userApi;
  late List<ContactApi> contacts;
  late List<ContactRiskApi> contactsRisk;
  late List<ZoneRiskApi> contactsZoneRisk;
  late List<ActivityDayApiResponse> activities;
  late List<UseMobilApi> inactivities;
  late List<UserRestApi> restDays;
  late List<AlertApi> alerts;
}
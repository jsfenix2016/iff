import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Page/FinishConfig/Pageview/finishConfig_page.dart';
import 'package:ifeelefine/Page/Geolocator/PageView/geolocator_page.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Onboarding/PageView/onboarding_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/PageView/zoneRisk.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:ifeelefine/Page/UserConfig2/Page/configuration2_page.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Views/contact_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoute = {
  "home": (BuildContext context) => const HomePage(),
  "onboarding": (BuildContext context) => OnboardingPage(),
  "risk": (BuildContext context) => const RiskPage(),
  "zone": (BuildContext context) => const ZoneRiskPage(),
  "contact": (BuildContext context) => const ContactList(
        isMenu: false,
      ),
  "config2": (BuildContext context) => UserConfigPage2(
        userbd: initUserBD(),
      ),
  "restDay": (BuildContext context) => const UserRestPage(),
  "previewRestDay": (BuildContext context) => const PreviewRestTimePage(
        isMenu: false,
      ),
  "useMobil": (BuildContext context) => UseMobilePage(
        userbd: initUserBD(),
      ),
  "inactivityDay": (BuildContext context) => const UserInactivityPage(),
  "configGeo": (BuildContext context) => const InitGeolocator(),
  "finishConfig": (BuildContext context) => const FinishConfigPage(),
  "userConfig": (BuildContext context) => const UserConfigPage(),
};

import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Page/Alternative/Pageview/alternative_page.dart';
import 'package:ifeelefine/Page/Contact/PageView/addContact_page.dart';
import 'package:ifeelefine/Page/FallDetected/Pageview/fall_activation_page.dart';
import 'package:ifeelefine/Page/FinishConfig/Pageview/finishConfig_page.dart';
import 'package:ifeelefine/Page/Geolocator/PageView/geolocator_page.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Onboarding/PageView/onboarding_page.dart';
import 'package:ifeelefine/Page/PreviewActivitiesFilteredByDate/PageView/previewActivitiesByDate_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/PageView/zoneRisk.dart';
import 'package:ifeelefine/Page/TermsAndConditions/PageView/conditionGeneral_page.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:ifeelefine/Page/UserConfig2/Page/configuration2_page.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Views/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Views/help_page.dart';

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
  "userConfig": (BuildContext context) => const UserConfigPage(isMenu: false),
  "addContact": (BuildContext context) => const AddContactPage(),
  "previewActivity": (BuildContext context) =>
      const PreviewActivitiesByDate(isMenu: false),
  "fallActivation": (BuildContext context) => const FallActivationPage(),
  "conditionGeneral": (BuildContext context) => const ConditionGeneralPage(),
  "cancelZone": (BuildContext context) => const CancelAlertPage(
        taskIds: [],
      ),
  "cancelDate": (BuildContext context) => const CancelDatePage(
        taskIds: [],
      ),
  "alternative": (BuildContext context) => const AlternativePage(),
  "help": (BuildContext context) => const HelpPage(),
};

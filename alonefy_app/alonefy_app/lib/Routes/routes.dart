import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Onboarding/PageView/onboarding_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/PageView/zoneRisk.dart';
import 'package:ifeelefine/Views/protectuser_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoute = {
  "home": (BuildContext context) => const HomePage(),
  "onboarding": (BuildContext context) => OnboardingPage(),
  "protect": (BuildContext context) => const ProtectUserPage(),
  "risk": (BuildContext context) => const RiskPage(),
  "zone": (BuildContext context) => const ZoneRiskPage(),
};

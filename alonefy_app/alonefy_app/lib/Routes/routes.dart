import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Onboarding/PageView/onboarding_page.dart';
import 'package:ifeelefine/Views/protectuser_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoute = {
  "home": (BuildContext context) => const HomePage(),
  "onboarding": (BuildContext context) => OnboardingPage(),
  "protect": (BuildContext context) => const ProtectUserPage(),
};

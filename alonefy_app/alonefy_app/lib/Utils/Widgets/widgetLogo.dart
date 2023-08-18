import 'package:flutter/material.dart';

class WidgetLogoApp extends StatelessWidget {
  const WidgetLogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.31,
      width: 250,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/new_logo.png'),
          fit: BoxFit.fill,
        ),
        color: Colors.transparent,
      ),
    );
  }
}

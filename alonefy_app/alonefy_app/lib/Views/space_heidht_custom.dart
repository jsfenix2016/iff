import 'package:flutter/material.dart';

class SpaceHeightCustom extends StatelessWidget {
  const SpaceHeightCustom({super.key, required this.heightTemp});
  final double heightTemp;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightTemp,
    );
  }
}

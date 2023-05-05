//import 'dart:async';
//
//import 'package:all_sensors/all_sensors.dart';
//import 'package:flutter/material.dart';
//import 'package:ifeelefine/Common/utils.dart';
//
//class AccelerometerBackground extends StatefulWidget {
//  const AccelerometerBackground({super.key});
//
//  @override
//  State<AccelerometerBackground> createState() =>
//      _AccelerometerBackgroundState();
//}
//
//class _AccelerometerBackgroundState extends State<AccelerometerBackground> {
//  List<double> _accelerometerValues = <double>[];
//  List<double> _userAccelerometerValues = <double>[];
//
//  final List<StreamSubscription<dynamic>> _streamSubscriptions =
//      <StreamSubscription<dynamic>>[];
//  @override
//  void initState() {
//    super.initState();
//
//    _streamSubscriptions
//        .add(accelerometerEvents!.listen((AccelerometerEvent event) {
//      setState(() {
//        _accelerometerValues = <double>[event.x, event.y, event.z];
//      });
//    }));
//
//    _streamSubscriptions
//        .add(userAccelerometerEvents!.listen((UserAccelerometerEvent event) {
//      setState(() {
//        _userAccelerometerValues = <double>[event.x, event.y, event.z];
//        if (event.x >= 5.5 || event.y >= 5.5 || event.z >= 5.5) {
//          showAlert(context, "mensaje");
//        }
//      });
//    }));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
//
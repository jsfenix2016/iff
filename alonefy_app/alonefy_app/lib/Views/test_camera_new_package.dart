// import 'dart:io';

// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:camerawesome/pigeon.dart';
// import 'package:flutter/material.dart';

// import 'package:path_provider/path_provider.dart';

// class TestNewCamera extends StatefulWidget {
//   const TestNewCamera({super.key});

//   @override
//   State<TestNewCamera> createState() => _TestNewCameraState();
// }

// class _TestNewCameraState extends State<TestNewCamera> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkCameraMultiple();
//   }

//   void checkCameraMultiple() async {
//     final isSupported = await CamerawesomePlugin.isMultiCamSupported();
//     print(isSupported);
//     if (isSupported) {
//       print(isSupported);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: CameraAwesomeBuilder.awesome(
//           // 1.
//           sensorConfig: SensorConfig.multiple(
//             // 2.
//             sensors: [
//               Sensor.position(SensorPosition.back),
//               Sensor.position(SensorPosition.front),
//             ],
//             // 3.
//             flashMode: FlashMode.auto,
//             aspectRatio: CameraAspectRatios.ratio_16_9,
//           ),
//           saveConfig: SaveConfig.video(),
//           // Other params
//         ),
//       ),
//     );
//   }
// }

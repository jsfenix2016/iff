// import 'dart:io';

// import 'package:flutter/material.dart';

// // COMPLETE: Import google_mobile_ads.dart
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class BannerCustom extends StatefulWidget {
//   const BannerCustom({super.key});

// // COMPLETE: Add _bannerAd
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/6300978111';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/2934735716';
//     } else {
//       throw new UnsupportedError('Unsupported platform');
//     }
//   }

//   @override
//   State<BannerCustom> createState() => _BannerCustomState();
// }

// class _BannerCustomState extends State<BannerCustom>
//     with WidgetsBindingObserver {
//   late AppLifecycleState _lastLifecycleState;

//   @override
//   void initState() {
//     super.initState();
//     bannerInit();

//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     setState(() {
//       _lastLifecycleState = state;
//       if (_lastLifecycleState == AppLifecycleState.resumed) {
//         _bannerAd.load();
//       } else {
//         try {
//           _bannerAd.dispose();
//           // _bannerAd = null;
//         } catch (ex) {
//           print("banner dispose error");
//         }
//       }
//     });
//   }

//   late BannerAd _bannerAd;

//   bool _isBannerAdReady = false;

//   void bannerInit() {
//     _bannerAd = BannerAd(
//       adUnitId: BannerCustom.bannerAdUnitId,
//       request: AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           _isBannerAdReady = true;
//           setState(() {});
//           // (context as Element).markNeedsBuild();
//         },
//         onAdFailedToLoad: (ad, err) {
//           print('Failed to load a banner ad: ${err.message}');
//           _isBannerAdReady = false;
//           ad.dispose();
//         },
//       ),
//     );

//     _bannerAd.load();
//   }

//   void limpiar() {}

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Visibility(
//       visible: _isBannerAdReady,
//       child: Container(
//         color: Colors.transparent,
//         height: 100,
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: Padding(
//             padding: const EdgeInsets.all(2.0),
//             child: Container(
//               width: size.width.toDouble(),
//               height: _bannerAd.size.height.toDouble(),
//               child: AdWidget(ad: _bannerAd),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

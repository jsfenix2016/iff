import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Utils/Widgets/video_player.dart';
import 'package:video_player/video_player.dart';

class PreviewVideoPage extends StatefulWidget {
  final String filePath;

  const PreviewVideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  State<PreviewVideoPage> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideoPage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late double _currentSliderValue;
  String elapsedTimeString = '';

  late Future<void> _initializeVideoPlayerFuture;
  late Stream<double> _videoPositionStream;
  bool _isRecording = false;

  late bool isLoading = false;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));

    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPositionStream =
        Stream<double>.periodic(const Duration(milliseconds: 200), (_) {
      return _videoPlayerController.value.position.inMilliseconds.toDouble();
    }).takeWhile((position) {
      return _videoPlayerController.value.isPlaying &&
          position <=
              _videoPlayerController.value.duration.inMilliseconds.toDouble();
    });
    _videoPlayerController.addListener(() {
      setState(() {
        _currentSliderValue =
            _videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });

    _videoPlayerController.play();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    super.dispose();
  }

  _actionButtonVideo() async {
    if (_isRecording) {
      await _videoPlayerController.pause();

      setState(() => _isRecording = false);
    } else {
      await _videoPlayerController.play();
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setContext(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Video zona de riesgo', style: textForTitleApp()),
        elevation: 0,
        backgroundColor: Colors.black26,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (_videoPlayerController.value.isInitialized) {
              Duration elapsedTimeTemp = Duration(
                  seconds: _videoPlayerController.value.duration.inSeconds);

              elapsedTimeString =
                  "${elapsedTimeTemp.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(elapsedTimeTemp.inSeconds.remainder(60)).toString().padLeft(2, '0')}";
            }

            return Stack(children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: VideoPlayerCustom(
                    filePath: File(widget.filePath).path,
                    initPlay: true,
                    isVisibleControl: true,
                    isLocalVideo: true),
              ),
              // isLoading
              //     ? const CircularProgressIndicator()
              //     : const SizedBox.shrink(),
              // Positioned(
              //   bottom: 0,
              //   child: Container(
              //     height: 75,
              //     width: size.width,
              //     color: Colors.white.withAlpha(50),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Container(
              //         color: Colors.transparent,
              //         child: Column(
              //           children: [
              //             StreamBuilder<double>(
              //               stream: _videoPositionStream,
              //               builder: (context, snapshot) {
              //                 if (snapshot.hasData) {
              //                   var temp = Duration(
              //                       milliseconds: _videoPlayerController
              //                           .value.position.inMilliseconds);

              //                   return Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceEvenly,
              //                     children: [
              //                       FloatingActionButton(
              //                         key: const Key("playVideo"),
              //                         backgroundColor: Colors.grey,
              //                         child: Icon(_isRecording
              //                             ? Icons.stop
              //                             : Icons.play_arrow),
              //                         onPressed: () => _actionButtonVideo(),
              //                       ),
              //                       const SizedBox(
              //                         width: 10,
              //                       ),
              //                       Text(
              //                         textAlign: TextAlign.center,
              //                         "${temp.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(temp.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
              //                         style: const TextStyle(
              //                           color: Colors.black,
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.bold,
              //                           decoration: TextDecoration.none,
              //                         ),
              //                       ),
              //                       Slider(
              //                         activeColor: Colors.white,
              //                         inactiveColor: Colors.grey,
              //                         value: _currentSliderValue,
              //                         min: 0,
              //                         max: _videoPlayerController
              //                             .value.duration.inMilliseconds
              //                             .toDouble(),
              //                         onChanged: (value) {
              //                           _currentSliderValue = value;

              //                           setState(() {
              //                             _videoPlayerController.seekTo(
              //                                 Duration(
              //                                     milliseconds: value.toInt()));
              //                           });
              //                         },
              //                       ),
              //                       Text(
              //                         textAlign: TextAlign.center,
              //                         "${_videoPlayerController.value.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_videoPlayerController.value.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
              //                         style: const TextStyle(
              //                           color: Colors.black,
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.bold,
              //                           decoration: TextDecoration.none,
              //                         ),
              //                       ),
              //                     ],
              //                   );
              //                 } else {
              //                   return const SizedBox.shrink();
              //                 }
              //               },
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ]);
          }
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Historial/PageView/preview_video_screen.dart';
import 'package:intl/intl.dart';

import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CellZoneRisk extends StatefulWidget {
  const CellZoneRisk({super.key, required this.logAlert});
  final LogAlertsBD logAlert;
  @override
  State<CellZoneRisk> createState() => _CellZoneRiskState();
}

class _CellZoneRiskState extends State<CellZoneRisk> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  late Stream<double> videoPositionStream;

  late File fileTemp = File("");

  void _initializeVideoPlayer() async {
    final cacheManager = DefaultCacheManager();
    if (widget.logAlert.video != null) {
      final videoFile = await cacheManager.putFile(
        'temp_video_${DateTime.now()}.mp4',
        widget.logAlert.video!,
        key: 'video_key',
      );
      fileTemp = videoFile;
      var pa = videoFile.basename;
      _videoPlayerController = VideoPlayerController.file(videoFile);
      _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    }
  }

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(File(""));

    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    videoPositionStream =
        Stream<double>.periodic(const Duration(milliseconds: 200), (_) {
      return _videoPlayerController.value.position.inMilliseconds.toDouble();
    }).takeWhile((position) {
      return _videoPlayerController.value.isPlaying &&
          position <=
              _videoPlayerController.value.duration.inMilliseconds.toDouble();
    });
    _initializeVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              IconButton(
                iconSize: 35,
                color: ColorPalette.principal,
                onPressed: () {},
                icon: searchImageForIcon(widget.logAlert.type),
              ),
              Container(
                width: 200,
                color: Colors.transparent,
                child: Text(
                  "Zona - ${DateFormat('dd-MM-yyyy').format(widget.logAlert.time).toString()} | ${widget.logAlert.time.hour.toString().padLeft(2, '0')}: ${widget.logAlert.time.minute.toString().padLeft(2, '0')}",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.barlow(
                    fontSize: 16.0,
                    wordSpacing: 1,
                    letterSpacing: 0.001,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, state) {
                  if (state.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTap: () {
                        if (fileTemp.path.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewVideoPage(
                                filePath: fileTemp.path,
                              ),
                            ),
                          );
                        }
                      },
                      child: SizedBox(
                        width: 150,
                        height: 110,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

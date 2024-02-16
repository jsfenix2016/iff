import 'dart:io';
import 'package:flutter/material.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Historial/PageView/preview_video_screen.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CellZoneRisk extends StatefulWidget {
  const CellZoneRisk({Key? key, required this.logAlert}) : super(key: key);

  final LogAlertsBD logAlert;

  @override
  State<CellZoneRisk> createState() => _CellZoneRiskState();
}

class _CellZoneRiskState extends State<CellZoneRisk> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  late File fileTemp = File("");
  bool notVideo = true;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(File(""));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    if (widget.logAlert.video != null ||
        (widget.logAlert.listVideosPresigned!.isNotEmpty &&
            widget.logAlert.listVideosPresigned != null)) {
      _initializeVideoPlayer();
    }

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
                  "Zona - ${DateFormat('dd-MM-yyyy').format(widget.logAlert.time)} | ${widget.logAlert.time.hour.toString().padLeft(2, '0')}: ${widget.logAlert.time.minute.toString().padLeft(2, '0')}",
                  textAlign: TextAlign.left,
                  style: textBold16White(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: notVideo,
                child: Container(
                  width: 200,
                  height: 100,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      "Video no disponible",
                      textAlign: TextAlign.center,
                      style: textBold16White(),
                    ),
                  ),
                ),
              ),
              if (!notVideo) ...[
                Visibility(
                  visible: !notVideo,
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
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
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorPalette.calendarNumber,
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text('Error al cargar el video'),
                        );
                      }
                    },
                  ),
                )
              ]
            ],
          ),
        ],
      ),
    );
  }

  void _initializeVideoPlayer() async {
    DefaultCacheManager cacheManager = DefaultCacheManager();
    print(widget.logAlert.video);
    File videoFile = File("");
    if (widget.logAlert.listVideosPresigned!.isNotEmpty &&
        widget.logAlert.listVideosPresigned != null) {
      videoFile = await cacheManager.putFile(
        'temp_video_${widget.logAlert.time}.mp4',
        widget.logAlert.listVideosPresigned!.first.videoDown!,
        key: 'video_key${widget.logAlert.video.hashCode}',
      );
    }
    if (widget.logAlert.video != null) {
      videoFile = await cacheManager.putFile(
        'temp_video_${widget.logAlert.time}.mp4',
        widget.logAlert.video!,
        key: 'video_key${widget.logAlert.time}',
      );
    }

    if (widget.logAlert.video != null ||
        (widget.logAlert.listVideosPresigned!.isNotEmpty &&
            widget.logAlert.listVideosPresigned != null)) {
      notVideo = false;
      fileTemp = videoFile;

      _videoPlayerController = VideoPlayerController.file(videoFile);
      _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    } else {
      notVideo = true;
    }
  }
}

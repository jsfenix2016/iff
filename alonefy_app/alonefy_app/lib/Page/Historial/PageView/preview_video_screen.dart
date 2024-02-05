import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Utils/Widgets/video_player.dart';
import 'package:ifeelefine/main.dart';

class PreviewVideoPage extends StatefulWidget {
  final String filePath;

  const PreviewVideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  State<PreviewVideoPage> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideoPage>
    with SingleTickerProviderStateMixin {
  String elapsedTimeString = '';

  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    starTap();
  }

  @override
  Widget build(BuildContext context) {
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('Video zona de riesgo', style: textForTitleApp()),
        elevation: 0,
        backgroundColor: Colors.black26,
      ),
      extendBodyBehindAppBar: true,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: VideoPlayerCustom(
            filePath: File(widget.filePath).path,
            initPlay: true,
            isVisibleControl: true,
            isLocalVideo: true),
      ),
    );
  }
}

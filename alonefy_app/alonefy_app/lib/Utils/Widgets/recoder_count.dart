import 'dart:async';
import 'package:flutter/material.dart';

class RecoderCount extends StatefulWidget {
  final ValueChanged<Duration> onChanged;
  final bool activate;
  const RecoderCount(
      {Key? key, required this.onChanged, required this.activate})
      : super(key: key);

  @override
  State<RecoderCount> createState() => _RecoderCountState();
}

class _RecoderCountState extends State<RecoderCount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Duration elapsedTimeDuration = Duration(seconds: 0);
  bool isPlaying = true;

  bool isRecording = true;
  int elapsedTime = 0;
  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant RecoderCount oldWidget) {
    // TODO: implement didUpdateWidget
    if (widget.activate) {
      toggleRecording();
    } else {
      stopRecording();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    timer
        .cancel(); // Asegúrate de cancelar el temporizador al eliminar el widget.
    super.dispose();
  }

  void startRecording() {
    isPlaying = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++;
      });
    });
    _controller.repeat(reverse: true);
  }

  void stopRecording() {
    elapsedTime = 0;
    timer.cancel();
    setState(() {
      _controller.reset();
      isPlaying = false;
    });
  }

  void toggleRecording() {
    if (isPlaying) {
      stopRecording();
    } else {
      startRecording();
    }

    widget.onChanged(elapsedTimeDuration);
    setState(() {
      isRecording = isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    elapsedTimeDuration = Duration(seconds: elapsedTime);
    String elapsedTimeString =
        "${elapsedTimeDuration.inHours.remainder(60).toString().padLeft(2, '0')}:${elapsedTimeDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(elapsedTimeDuration.inSeconds.remainder(60)).toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: toggleRecording,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(70),
              border: Border.all(color: const Color.fromRGBO(219, 177, 42, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            width: isRecording ? 160.0 : 60.0, // Anima el ancho
            height: 50.0, // Anima el alto
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      left: 35,
                      top: 18,
                      child: Visibility(
                        visible: _controller.value < 0.5,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            color: Colors.red,
                          ),
                          height: 8,
                          width: 8,
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        color: Colors.black,
                      ),
                      onPressed: toggleRecording,
                    ),
                    Visibility(
                      visible: isRecording,
                      child: Text(
                        elapsedTimeString,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

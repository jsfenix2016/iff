import 'package:flutter/material.dart';

class ImageListWidget extends StatefulWidget {
  final List<String> imageUrls;

  ImageListWidget({required this.imageUrls});

  @override
  _ImageListWidgetState createState() => _ImageListWidgetState();
}

class _ImageListWidgetState extends State<ImageListWidget> {
  int _currentIndex = 0;

  void _showImageGallery(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    widget.imageUrls[_currentIndex],
                    fit: BoxFit.contain,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _currentIndex =
                              (_currentIndex - 1) % widget.imageUrls.length;
                          if (_currentIndex < 0) {
                            _currentIndex = widget.imageUrls.length - 1;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          _currentIndex =
                              (_currentIndex + 1) % widget.imageUrls.length;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.photo),
      onPressed: () {
        _showImageGallery(context);
      },
    );
  }
}

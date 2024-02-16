import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

// ignore: must_be_immutable
class HeaderGroup extends StatelessWidget {
  HeaderGroup({Key? key, required this.date, required this.onDelete})
      : super(key: key);
  String date;
  final void Function(bool) onDelete;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        color: Colors.transparent,
        height: 50,
        child: Stack(
          children: [
            Container(
              width: 320,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 60,
                    child: Stack(children: [
                      Positioned(
                        top: 20,
                        child: Text(
                          date,
                          textAlign: TextAlign.left,
                          style: textNormal16White(),
                        ),
                      ),
                    ]),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      iconSize: 35,
                      onPressed: () {
                        onDelete(true);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
